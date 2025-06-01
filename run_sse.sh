#!/bin/bash

# OpenAI Codex MCP Server SSE Mode Run Script

set -e

echo "🎯 Starting OpenAI Codex MCP Server in SSE mode..."

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

# Parse command line arguments
PORT=${1:-8000}
HOST=${2:-localhost}

echo "The server will run in SSE mode on http://${HOST}:${PORT}"
echo "Press Ctrl+C to stop the server"
echo ""

# Run the MCP server in SSE mode
python codex_server.py --mode sse --host "${HOST}" --port "${PORT}"