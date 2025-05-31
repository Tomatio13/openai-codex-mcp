<h1 align="center">OpenAI Codex MCP Server</h1>

<p align="center">
    <img src="https://img.shields.io/badge/Python-3.12+-blue.svg" alt="Python Version"/>
    <img src="https://img.shields.io/badge/MCP-Protocol-green.svg" alt="MCP Protocol"/>
    <img src="https://img.shields.io/badge/OpenAI-Codex-orange.svg" alt="OpenAI Codex"/>
    <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License"/>
</p>

<p align="center">
    <a href="README_JP.md"><img src="https://img.shields.io/badge/ドキュメント-日本語-white.svg" alt="JA doc"/></a>
    <a href="README.md"><img src="https://img.shields.io/badge/english-document-white.svg" alt="EN doc"></a>
</p>

<p align="center">
    OpenAI Codex CLI を MCP (Model Context Protocol) サーバーとしてラップし、Claude との統合を可能にします。
</p>

## 🚀 機能

このMCPサーバーは以下のツールを提供します：

- **`codex_agent`**: OpenAI Codex CLI の全機能にアクセス可能な統合ツール
  - コード生成、説明、デバッグ、リファクタリング
  - セキュリティ分析、テスト作成、ドキュメント生成
  - マルチモーダル対応（画像入力サポート）
  - 複数のAIプロバイダー対応
  - 3段階の自動化レベル（suggest/auto-edit/full-auto）

- **`codex_interactive`**: インタラクティブセッション開始用ツール

## 🔌 サポートモード

- **stdio モード**: 標準入出力を使用（Claude Desktop用）
- **SSE モード**: Server-Sent Events を使用（Web API用）

## 📋 前提条件

1. **OpenAI Codex CLI**: 
   ```bash
   npm install -g @openai/codex
   ```

2. **Python 3.12以上**

3. **環境設定**: `.env.example` を `.env` にコピーして設定を行ってください

## 🛠️ インストール

### 1. リポジトリのクローン
```bash
git clone https://github.com/Tomatio13/openai-codex-mcp.git
cd openai-codex-mcp
```

### 2. セットアップ
```bash
./setup.sh
```

### 3. サーバーの起動

#### stdio モード（Claude Desktop用）
```bash
./run.sh
```

#### SSE モード（Web API用）
```bash
./run_sse.sh [ポート] [ホスト]

# 例:
./run_sse.sh 8080 0.0.0.0  # ポート8080、全てのインターフェースでリッスン
./run_sse.sh              # デフォルト: localhost:8000
```

#### 手動起動
```bash
# stdio モード
python codex_server.py --mode stdio

# SSE モード
python codex_server.py --mode sse --port 8000 --host localhost
```

または、セットアップと起動を一度に実行：
```bash
./setup_and_run.sh
```

### 手動インストール
```bash
# 依存関係のインストール
pip install -e .

# サーバーの起動
python codex_server.py
```

## 🔧 Claude での設定

### stdio モード（推奨）

Claude Desktop で MCP サーバーを使用するには、設定ファイルに以下を追加します：

#### macOS の場合
`~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "openai-codex": {
      "command": "python",
      "args": ["/path/to/openai-codex-mcp/codex_server.py", "--mode", "stdio"],
      "env": {
        "PATH": "/usr/local/bin:/usr/bin:/bin"
      }
    }
  }
}
```

#### Windows の場合
`%APPDATA%\Claude\claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "openai-codex": {
      "command": "python",
      "args": ["C:\\path\\to\\openai-codex-mcp\\codex_server.py", "--mode", "stdio"],
      "env": {
        "PATH": "C:\\Program Files\\nodejs;C:\\Windows\\System32"
      }
    }
  }
}
```

### SSE モード

SSEモードでは、HTTPエンドポイント経由でMCPサーバーにアクセスできます：

```bash
# サーバー起動
./run_sse.sh 8000

# 利用可能なエンドポイント
# GET  http://localhost:8000/sse - SSE接続
# POST http://localhost:8000/message - メッセージ送信
```

## 💡 使用方法

Claude Desktop でMCPサーバーが設定されると、以下のようにツールを使用できます：

### 基本的なコード生成
```
@openai-codex codex_agent prompt="Pythonでフィボナッチ数列を計算する関数を作成して"
```

### 特定タスクタイプでの最適化
```
@openai-codex codex_agent prompt="このコードを説明して" task_type="code-explanation"
@openai-codex codex_agent prompt="utils.pyのバグを修正して" task_type="debugging" model="o4-preview"
@openai-codex codex_agent prompt="セキュリティ脆弱性をチェックして" task_type="security"
```

### 自動化レベルの設定
```
# 提案のみ（デフォルト、最も安全）
@openai-codex codex_agent prompt="リファクタリングして" approval_mode="suggest"

# 自動編集（ファイル読み書き自動、コマンド実行は確認）
@openai-codex codex_agent prompt="このコードベースを説明して" approval_mode="auto-edit"

# 完全自動（ネットワーク無効のサンドボックス内で完全自動実行）
@openai-codex codex_agent prompt="テストを作成して実行して" approval_mode="full-auto"
```

### マルチモーダル（画像入力）
```
@openai-codex codex_agent prompt="このUIデザインを実装して" images=["design.png"] task_type="code-generation"
```

### 異なるAIプロバイダーの使用
```
@openai-codex codex_agent prompt="コードレビューして" provider="azure" model="gpt-4.1"
@openai-codex codex_agent prompt="説明して" provider="ollama" model="llama3"
```

### インタラクティブセッション
```
@openai-codex codex_interactive initial_prompt="プロジェクトの構造を教えて" approval_mode="auto-edit"
```

## 🎯 タスクタイプ

`task_type` パラメータを使用して、特定のタスクに最適化されたプロンプトを生成できます：

- **`general`**: 一般的なコーディング支援（デフォルト）
- **`code-generation`**: 新しいコードの生成
- **`code-explanation`**: 既存コードの説明
- **`debugging`**: バグの発見と修正
- **`refactoring`**: コード構造の改善
- **`testing`**: テストの作成または修正
- **`security`**: セキュリティ分析と修正
- **`documentation`**: ドキュメントの生成または改善

## 🤖 AIプロバイダー

`provider` パラメータでサポートされるAIプロバイダー：

- **`openai`**: OpenAI（デフォルト）
- **`azure`**: Azure OpenAI
- **`gemini`**: Google Gemini
- **`ollama`**: Ollama（ローカルモデル）
- **`mistral`**: Mistral AI
- **`deepseek`**: DeepSeek
- **`xai`**: xAI
- **`groq`**: Groq

## 🔒 承認モード

- **`suggest`**: 変更の提案のみ、すべてのアクションに承認が必要（最も安全）
- **`auto-edit`**: ファイルの読み書きは自動、シェルコマンドは確認
- **`full-auto`**: ネットワーク無効のサンドボックス内で完全自動（最も強力）

## 🛡️ セキュリティ

- `full-auto` モードはセキュリティのためネットワーク無効のサンドボックスで実行
- ファイル操作は現在の作業ディレクトリに制限
- `full-auto` モード以外では、すべてのシェルコマンドに明示的な承認が必要

## 🐛 トラブルシューティング

### よくある問題

1. **"codex command not found"**
   ```bash
   npm install -g @openai/codex
   ```

2. **スクリプトの実行権限エラー**
   ```bash
   chmod +x *.sh
   ```

3. **Pythonバージョンの問題**
   - Python 3.12以上がインストールされていることを確認
   - 仮想環境を使用: `python3 -m venv venv && source venv/bin/activate`

4. **MCP接続の問題**
   - Claude Desktop設定ファイルの構文を確認
   - ファイルパスが絶対パスであることを確認
   - 設定変更後にClaude Desktopを再起動

## 📝 ライセンス

MIT License with Attribution - 詳細は [LICENSE](LICENSE) ファイルをご覧ください。

## 🤝 貢献

貢献を歓迎します！プルリクエストをお気軽に送信してください。

## 📞 サポート

問題が発生した場合や質問がある場合は、GitHubでissueを開いてください。

---

<p align="center">
    Claude + OpenAI Codex コミュニティのために ❤️ で作成
</p>