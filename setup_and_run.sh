#!/bin/bash

# OpenAI Codex MCP Server Setup and Run Script (Wrapper)

set -e

echo "🚀 Running setup and start sequence..."

# Run setup first
echo "Step 1: Running setup..."
./setup.sh

echo ""
echo "Step 2: Starting server..."
./run.sh