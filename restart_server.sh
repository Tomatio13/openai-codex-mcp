#!/bin/bash
# OpenAI Codex MCP Server Restart Script

echo "🔄 Restarting OpenAI Codex MCP Server..."

# Kill any existing server processes
pkill -f "python.*codex_server.py" || true
sleep 2

# Start the server again
echo "🚀 Starting MCP Server..."
python codex_server.py