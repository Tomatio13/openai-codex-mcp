#!/bin/bash

# OpenAI Codex MCP Server Run Script (stdio mode)

set -e

echo "🎯 Starting OpenAI Codex MCP Server in stdio mode..."

# Check if virtual environment exists and activate it
if [ -d "venv" ]; then
    source venv/bin/activate
    echo "✅ Virtual environment activated"
elif [ -z "$VIRTUAL_ENV" ]; then
    echo "⚠️  Warning: No virtual environment found"
    echo "Please run ./setup.sh first to set up the environment"
    exit 1
fi

# Check if codex CLI is still available
if ! command -v codex &> /dev/null; then
    echo "❌ Error: 'codex' command not found"
    echo "Please install the OpenAI Codex CLI:"
    echo "  npm install -g @openai/codex"
    exit 1
fi

echo "The server will run in stdio mode for MCP communication"
echo "Press Ctrl+C to stop the server"
echo ""

# Run the MCP server in stdio mode (default)
python codex_server.py --mode stdio