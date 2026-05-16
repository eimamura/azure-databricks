# Azure AI Foundry — Terraform リファレンス

## リソース型の整理

Azure AI Foundry には名前が似た複数のリソース型が存在し混乱しやすい。

| リソース | プロバイダー | 種別 | 用途 |
|---|---|---|---|
| `azurerm_ai_foundry` | AzureRM | `Microsoft.MachineLearningServices/workspaces` kind=Hub | **Classic Hub（旧世代）。新規では使わない** |
| `azurerm_ai_foundry_project` | AzureRM | 〃 の Project | 同上、使わない |
| `azurerm_cognitive_account` | AzureRM | `Microsoft.CognitiveServices/accounts` kind=AIServices | **新 Foundry リソース。こちらを使う** |
| `azurerm_cognitive_account_project` | AzureRM | 〃 の Project | 新 Foundry のプロジェクト |
| `azurerm_cognitive_deployment` | AzureRM | 〃 の Deployment | モデルデプロイ |
| `azapi_resource` | AzAPI | 任意の ARM リソース | Connections / Agent standard 等、AzureRM 未対応の高度設定 |

---

## 推奨構成

```
azurerm_cognitive_account          # Foundry リソース本体
  └─ azurerm_cognitive_account_project
      └─ azurerm_cognitive_deployment   # モデルデプロイ（任意）
```

高度な設定（Connections / Agent standard setup / BYO Storage など）は AzureRM が未対応のため AzAPI を併用する。

---

## 最小 Terraform 実装

### Foundry アカウント

```hcl
resource "azurerm_cognitive_account" "foundry" {
  name                = "aif-sample-dev"
  location            = "eastus"
  resource_group_name = "rg-sample-dev"

  kind     = "AIServices"
  sku_name = "S0"

  custom_subdomain_name         = "aifsampledev"   # グローバルユニーク、英数小文字のみ、最大24文字
  project_management_enabled    = true              # Foundry として動かす必須フラグ
  local_auth_enabled            = true              # false にすると API Key 無効（Entra ID のみ）
  public_network_access_enabled = true              # dev 環境向け。本番では false 推奨

  identity {
    type = "SystemAssigned"
  }

  tags = { environment = "dev" }
}
```

### Foundry プロジェクト

```hcl
resource "azurerm_cognitive_account_project" "project" {
  name                 = "proj-sample-dev"
  cognitive_account_id = azurerm_cognitive_account.foundry.id
  location             = "eastus"

  identity {
    type = "SystemAssigned"
  }
}
```

### モデルデプロイ（任意）

```hcl
resource "azurerm_cognitive_deployment" "gpt4o_mini" {
  name                 = "gpt-4o-mini"
  cognitive_account_id = azurerm_cognitive_account.foundry.id

  sku {
    name     = "GlobalStandard"
    capacity = 1
  }

  model {
    format  = "OpenAI"
    name    = "gpt-4o-mini"
    version = "2024-07-18"
  }
}
```

---

## このプロジェクトのモジュール設計

### `terraform/modules/ai_foundry/`

- `azurerm_cognitive_account` + `azurerm_cognitive_account_project` を一括管理
- `random_string` で account name と `custom_subdomain_name` にサフィックスを付与（グローバルユニーク対応）
- `custom_subdomain_name` は最大 24 文字制限のため `substr(..., 0, 24)` でトリミング
- AzAPI プロバイダーはモジュール内では使用しない。env の `main.tf` には残す（将来の高度設定用）

### モジュールが受け取る変数

| 変数 | 説明 |
|---|---|
| `name` | アカウントのベース名（サフィックスが付く） |
| `resource_group_name` | リソースグループ名（azurerm は name で受け取る） |
| `location` | Azure リージョン |
| `project_name` | Foundry プロジェクト名 |
| `tags` | タグ |

---

## 注意点

### `azurerm_ai_foundry` は使わない

名前が紛らわしいが、これは旧 Classic Hub を作るリソース。Portal で見ると「Azure AI hub」と表示される。新規で Foundry リソースを作る場合は `azurerm_cognitive_account` (kind=AIServices) を使う。

### `custom_subdomain_name` の制約

- グローバルユニーク（Azure 全体で重複不可）
- 英小文字・数字のみ（ハイフン不可）
- 最大 24 文字

### `project_management_enabled = true` は必須

これが `false`（デフォルト）のままだと、Portal 上で Foundry として認識されず、プロジェクト作成が不可になる。`kind = "AIServices"` のときのみ設定可能。

### AzureRM が追いついていない機能

以下は 2025年5月時点で AzureRM 未対応。AzAPI を使う：

- Connections（他サービスとの接続設定）
- Capability Host / Agent standard setup
- BYO Storage / Application Insights の紐付け
- Network Injection（Agent Client のサブネット注入）

### soft-delete による名前衝突

`terraform destroy` 後に同名で `apply` すると、soft-delete 中のリソース名と衝突してエラーになる場合がある（特に Key Vault）。PoC での destroy/apply サイクルに注意。

---

## 参考リンク

- [Azure AI Foundry リソース種別の概念](https://learn.microsoft.com/en-us/azure/ai-foundry/concepts/resource-types)
- [Terraform で Foundry を作成する公式ガイド](https://learn.microsoft.com/en-us/azure/ai-foundry/how-to/create-resource-terraform)
- [azurerm_cognitive_account ドキュメント](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cognitive_account)
- [Foundry Samples 公式リファレンス実装](https://github.com/azure-ai-foundry/foundry-samples)
- [AVM Pattern Module (参考)](https://github.com/Azure/terraform-azurerm-avm-ptn-aiml-ai-foundry)
