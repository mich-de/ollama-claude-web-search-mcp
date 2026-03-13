@echo off
SET ANTHROPIC_BASE_URL=http://localhost:11434
SET ANTHROPIC_AUTH_TOKEN=ollama
SET ANTHROPIC_API_KEY=
claude --model qwen3.5-4b-unsloth --mcp-config C:\Users\mdeangelis\AppData\Roaming\Claude\claude_desktop_config.json
pause
