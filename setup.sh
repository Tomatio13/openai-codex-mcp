#!/bin/bash

# OpenAI Codex MCP Server Setup Script

set -e

echo "🚀 Setting up OpenAI Codex MCP Server..."

# Check if we're in a virtual environment
if [ -z "$VIRTUAL_ENV" ]; then
    echo "⚠️  Warning: Not in a virtual environment. Creating one..."
    python3 -m venv venv
    source venv/bin/activate
    echo "✅ Virtual environment created and activated"
fi

# Check if codex CLI is installed
if ! command -v codex &> /dev/null; then
    echo "❌ Error: 'codex' command not found"
    echo "Please install the OpenAI Codex CLI first:"
    echo "  npm install -g @openai/codex"
    exit 1
fi

echo "✅ OpenAI Codex CLI found"

# Install Python dependencies
echo "📦 Installing Python dependencies..."
pip install -e .

echo "✅ Setup completed successfully!"
echo ""
echo "To start the server, run:"
echo "  ./run.sh"