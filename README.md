# Ollama + Claude Code: Free Web Search via MCP

This repository provides a step-by-step guide to setting up **Claude Code** (Anthropic's CLI agent) with a **Local Ollama Model** (optimized by Unsloth) and enabling **Free Web Search** using the Model Context Protocol (MCP).

## 🚀 Overview
- **LLM Engine**: [Ollama](https://ollama.com/)
- **Model**: Qwen 3.5 4B (Unsloth Optimized)
- **Interface**: Claude Code (CLI)
- **Web Search**: DuckDuckGo (Free, via MCP + Curl)
- **Hardware Optimized**: Tested on i9-12900 + 64GB RAM + NVIDIA T1000

---

## 🛠️ Installation & Hardware Optimization

### 1. Download the Unsloth Optimized Model
This setup uses the **Unsloth Qwen 3.5 4B (Dynamic 2.0 GGUF)**, which is specifically chosen for a balance between speed (fitting in 4GB VRAM) and intelligence.

1. Download the GGUF file from Hugging Face:
   ```powershell
   curl.exe -L -o Qwen3.5-4B-UD-Q4_K_XL.gguf https://huggingface.co/unsloth/Qwen3.5-4B-GGUF/resolve/main/Qwen3.5-4B-UD-Q4_K_XL.gguf
   ```

### 2. Configure for your Hardware
To get the most out of your **Intel i9-12900** and **NVIDIA T1000**, create a `Modelfile` (provided as `Modelfile.example`) with these critical parameters:

- `num_thread 24`: Symmetrically utilizes all 24 threads of the i9-12900.
- `num_ctx 4096`: Balanced context window to fit within 4GB VRAM alongside the model.
- `num_gpu 99`: Instructs Ollama to offload as many layers as possible to the GPU.

Create the local model:
```bash
ollama create qwen3.5-4b-unsloth -f Modelfile.example
```

### 3. Python Environment & MCP
Set up a virtual environment and install the required libraries:
```bash
python -m venv .venv
.\.venv\Scripts\activate
pip install -r requirements.txt
```

### 4. MCP Search Server
The repository includes `mcp_server_search.py`, which uses `curl.exe` for robust web searches via DuckDuckGo without requiring an API key.

---

## ⚙️ Configuration (Claude Code)

Claude Code looks for MCP servers in:
`%APPDATA%\Claude\claude_desktop_config.json`

Add the following (update the paths to your local directory):
```json
{
    "mcpServers": {
        "web_search": {
            "command": "C:\\Users\\<USER>\\.ollama\\.open-webui-venv\\Scripts\\python.exe",
            "args": ["C:\\Users\\<USER>\\.ollama\\ollama-claude-web-search-mcp\\mcp_server_search.py"]
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
