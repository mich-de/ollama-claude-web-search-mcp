# Ollama + Claude Code: Free Web Search via MCP

This repository provides a step-by-step guide to setting up **Claude Code** (Anthropic's CLI agent) with a **Local Ollama Model** (optimized by Unsloth) and enabling **Free Web Search** using the Model Context Protocol (MCP).

## 🚀 Overview
- **LLM Engine**: [Ollama](https://ollama.com/)
- **Model**: Qwen 3.5 4B (Unsloth Optimized)
- **Interface**: Claude Code (CLI)
- **Web Search**: DuckDuckGo (Free, via MCP + Curl)
- **Hardware Optimized**: Tested on i9-12900 + 64GB RAM + NVIDIA T1000

---

## 🛠️ Installation

### 1. Ollama & Unsloth Model
First, ensure Ollama is installed. Then, download the optimized Qwen 3.5 4B model from Unsloth:
```bash
# Pull the base model
ollama pull qwen3.5:4b

# Create an optimized version using the provided Modelfile
ollama create qwen3.5-4b-fast -f Modelfile.example
```

### 2. Python Environment & MCP
Set up a virtual environment and install the required libraries:
```bash
python -m venv .venv
.\.venv\Scripts\activate
pip install -r requirements.txt
```

### 3. MCP Search Server
The repository includes `mcp_server_search.py`, which uses `curl.exe` to perform robust web searches via DuckDuckGo without requiring an API key.

---

## ⚙️ Configuration

### Claude Desktop/CLI Config
Claude Code looks for MCP servers in a specific configuration file. On Windows, create or edit:
`%APPDATA%\Claude\claude_desktop_config.json`

Add the following:
```json
{
    "mcpServers": {
        "web_search": {
            "command": "C:\\Path\\To\\Your\\.venv\\Scripts\\python.exe",
            "args": ["C:\\Path\\To\\Your\\mcp_server_search.py"]
        }
    }
}
```

---

## 🏃 Usage

Launch Claude Code by pointing it to your local Ollama endpoint and loading the MCP configuration:

```powershell
# Set local Ollama endpoint (OpenAI compatible)
$env:ANTHROPIC_BASE_URL="http://localhost:11434/v1"
$env:ANTHROPIC_API_KEY="sk-ant-ollama-local"

# Launch Claude Code
claude --model qwen3.5-4b-fast --mcp-config %APPDATA%\Claude\claude_desktop_config.json
```

### Testing the Search
Once inside Claude, ask:
> "Search for the latest news on AI models released this week."

Claude will call the `web_search` tool, fetch results via DuckDuckGo, and provide an updated answer using your local model.

---

## 🛡️ License
MIT
