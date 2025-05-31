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
    Wraps OpenAI Codex CLI as an MCP (Model Context Protocol) server for integration with Claude.
</p>

## 🚀 Features

This MCP server provides the following tools:

- **`codex_agent`**: Comprehensive tool with access to all OpenAI Codex CLI features
  - Code generation, explanation, debugging, refactoring
  - Security analysis, test creation, documentation generation
  - Multimodal support (image input)
  - Multiple AI provider support
  - 3-level automation modes (suggest/auto-edit/full-auto)

- **`codex_interactive`**: Tool for starting interactive sessions

## 🔌 Supported Modes

- **stdio mode**: Uses standard input/output (for Claude Desktop)
- **SSE mode**: Uses Server-Sent Events (for Web API)

## 📋 Prerequisites

1. **OpenAI Codex CLI**: 
   ```bash
   npm install -g @openai/codex
   ```

2. **Python 3.12 or higher**

3. **Environment setup**: Copy `.env.example` to `.env` and configure

## 🛠️ Installation

### 1. Clone the repository
```bash
git clone https://github.com/Tomatio13/openai-codex-mcp.git
cd openai-codex-mcp
```

### 2. Setup
```bash
./setup.sh
```

### 3. Start the server

#### stdio mode (for Claude Desktop)
```bash
./run.sh
```

#### SSE mode (for Web API)
```bash
./run_sse.sh [port] [host]

# Examples:
./run_sse.sh 8080 0.0.0.0  # Port 8080, listen on all interfaces
./run_sse.sh              # Default: localhost:8000
```

#### Manual startup
```bash
# stdio mode
python codex_server.py --mode stdio

# SSE mode
python codex_server.py --mode sse --port 8000 --host localhost
```

Or run setup and start in one command:
```bash
./setup_and_run.sh
```

### Manual installation
```bash
# Install dependencies
pip install -e .

# Start server
python codex_server.py
```

## 🔧 Claude Configuration

### stdio mode (recommended)

To use the MCP server with Claude Desktop, add the following to your configuration file:

#### macOS
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

#### Windows
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

### SSE mode

In SSE mode, you can access the MCP server via HTTP endpoints:

```bash
# Start server
./run_sse.sh 8000

# Available endpoints
# GET  http://localhost:8000/sse - SSE connection
# POST http://localhost:8000/message - Send message
```

## 💡 Usage

Once the MCP server is configured in Claude Desktop, you can use the tools as follows:

### Basic code generation
```
@openai-codex codex_agent prompt="Create a Python function to calculate Fibonacci numbers"
```

### Task-specific optimization
```
@openai-codex codex_agent prompt="Explain this code" task_type="code-explanation"
@openai-codex codex_agent prompt="Fix the bug in utils.py" task_type="debugging" model="o4-preview"
@openai-codex codex_agent prompt="Check for security vulnerabilities" task_type="security"
```

### Automation level settings
```
# Suggestions only (default, safest)
@openai-codex codex_agent prompt="Refactor this code" approval_mode="suggest"

# Auto-edit (automatic file read/write, command execution requires confirmation)
@openai-codex codex_agent prompt="Explain this codebase" approval_mode="auto-edit"

# Full auto (fully automatic execution in network-disabled sandbox)
@openai-codex codex_agent prompt="Create and run tests" approval_mode="full-auto"
```

### Multimodal (image input)
```
@openai-codex codex_agent prompt="Implement this UI design" images=["design.png"] task_type="code-generation"
```

### Using different AI providers
```
@openai-codex codex_agent prompt="Review this code" provider="azure" model="gpt-4.1"
@openai-codex codex_agent prompt="Explain this" provider="ollama" model="llama3"
```

### Interactive sessions
```
@openai-codex codex_interactive initial_prompt="Tell me about the project structure" approval_mode="auto-edit"
```

## 🎯 Task Types

Use the `task_type` parameter to generate prompts optimized for specific tasks:

- **`general`**: General coding assistance (default)
- **`code-generation`**: Generate new code
- **`code-explanation`**: Explain existing code  
- **`debugging`**: Find and fix bugs
- **`refactoring`**: Improve code structure
- **`testing`**: Write or fix tests
- **`security`**: Security analysis and fixes
- **`documentation`**: Generate or improve documentation

## 🤖 AI Providers

Supported AI providers through the `provider` parameter:

- **`openai`**: OpenAI (default)
- **`azure`**: Azure OpenAI
- **`gemini`**: Google Gemini
- **`ollama`**: Ollama (local models)
- **`mistral`**: Mistral AI
- **`deepseek`**: DeepSeek
- **`xai`**: xAI
- **`groq`**: Groq

## 🔒 Approval Modes

- **`suggest`**: Only suggests changes, requires approval for all actions (safest)
- **`auto-edit`**: Can read and write files automatically, asks for shell commands
- **`full-auto`**: Full autonomy with network-disabled sandbox (most powerful)

## 🛡️ Security

- The `full-auto` mode runs in a network-disabled sandbox for security
- File operations are limited to the current working directory
- All shell commands require explicit approval unless in `full-auto` mode

## 🐛 Troubleshooting

### Common Issues

1. **"codex command not found"**
   ```bash
   npm install -g @openai/codex
   ```

2. **Permission denied on scripts**
   ```bash
   chmod +x *.sh
   ```

3. **Python version issues**
   - Ensure Python 3.12+ is installed
   - Use virtual environment: `python3 -m venv venv && source venv/bin/activate`

4. **MCP connection issues**
   - Check Claude Desktop configuration file syntax
   - Verify file paths are absolute
   - Restart Claude Desktop after configuration changes

## 📝 License

MIT License with Attribution - see [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

If you encounter any issues or have questions, please open an issue on GitHub.

---

<p align="center">
    Made with ❤️ for the Claude + OpenAI Codex community
</p>