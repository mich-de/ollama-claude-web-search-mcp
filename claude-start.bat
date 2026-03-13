@echo off
SET ANTHROPIC_BASE_URL=http://localhost:11434/v1
SET ANTHROPIC_API_KEY=sk-ant-ollama-local
claude --model qwen3.5-4b-unsloth --mcp-config C:\Users\mdeangelis\AppData\Roaming\Claude\claude_desktop_config.json
pause
