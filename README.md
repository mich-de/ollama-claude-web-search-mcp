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

## 🧠 Qwen 3.5 Model Selection Matrix

The Qwen 3.5 family (Unsloth Optimized) offers a model for every hardware tier. Use this matrix to find your best fit:

| Model Tier | VRAM (4-bit) | Recommended Hardware | Performance Profile |
| :--- | :--- | :--- | :--- |
| **0.8B / 1.5B** | ~1.5 GB | Low-end / Mobile | **Extreme Speed** (>150 t/s) |
| **4B (Your Fit)**| ~3.5 GB | **NVIDIA T1000 / RTX 3050** | **Instant** (Real-time) |
| **9B** | ~6.5 GB | RTX 3060 / 4060 (8GB) | **Fast** |
| **27B / 35B-A3B**| ~18 - 22 GB | RTX 3090 / 4090 (24GB) | **Moderate** (Smart MoE) |
| **122B / 397B** | 70GB - 210GB| Multi-GPU / Mac Studio | **Strategic** (Giant) |

*Note: With your **64GB of RAM**, you can run the **27B** or **35B-A3B** models by offloading them to the CPU. They will be slower but significantly smarter for complex reasoning tasks.*

### 2. How to Download Any Unsloth Qwen 3.5 Model
Unsloth provides optimized **Dynamic 2.0 GGUF** versions of Qwen 3.5. To install:

1. Visit [huggingface.co/unsloth](https://huggingface.co/unsloth) and find a GGUF repository.
2. Copy the download link for the `Q4_K_M` or `UD-Q4_K_XL` version.
3. Use `curl.exe` to download:
   ```powershell
   curl.exe -L -o my-model.gguf https://huggingface.co/unsloth/REPO_NAME/resolve/main/MODEL_NAME.gguf
   ```
4. Create a `Modelfile` pointing to the file:
   ```dockerfile
   FROM ./my-model.gguf
   PARAMETER num_thread 24  # Set to your CPU thread count
   ```
5. Create the model in Ollama:
   ```bash
   ollama create my-custom-model -f Modelfile
   ```

### 3. Why Unsloth "Dynamic" GGUFs?
Standard quantization often loses accuracy in small models. Unsloth **Dynamic 2.0** (UD) quants keep critical layers at higher precision (16-bit) while compressing the rest to 4-bit. This gives you the intelligence of a larger model with the footprint of a smaller one.

---

## ⚡ Quick Access & Aliases

To avoid typing long commands every time, you can set up a permanent alias in your terminal.

### 1. PowerShell Alias (Recommended)
Add a custom function to your PowerShell Profile so you can simply type `claude-local` from any terminal:

1. Open your profile in Notepad:
   ```powershell
   notepad $PROFILE
   ```
2. Paste the following function at the end of the file:
   ```powershell
   function claude-local {
       $env:ANTHROPIC_BASE_URL="http://localhost:11434/v1"
       $env:ANTHROPIC_API_KEY="sk-ant-ollama-local"
       claude --model qwen3.5-4b-unsloth --mcp-config "$HOME\AppData\Roaming\Claude\claude_desktop_config.json"
   }
   ```
3. Restart your terminal and just type: `claude-local`

### 2. Windows Batch Script (`.bat`)
A `claude-start.bat` file is included in this repository. You can move it to your desktop and double-click it to launch the entire environment instantly.

---

## 🧪 Verification & Examples

Once Claude Code is running, try these queries to verify everything is working as expected:

### 1. Test Local Inference Speed
Ask something that doesn't require the web to see how fast the **i9-12900** and **T1000** are:
> "Write a Python script to scrape a website using BeautifulSoup and explain the logic briefly."

### 2. Test Real-Time Web Search (MCP)
Ask about something that happened today or very recently to trigger the `web_search` tool:
> "What are the top AI news stories from the last 24 hours? Use your web search tool to find the latest updates."

### 3. Technical Analysis + Web
Combine local coding knowledge with web documentation:
> "Check the current version of the 'FastAPI' library on PyPI and show me a basic example of how to implement an OIDC authentication flow with it."

### 4. Hardware Check
Verify if the model is aware of its environment:
> "Analyze my current hardware configuration (i9-12900, 24 threads, T1000 GPU) and suggest the best settings for running a 7B model if I upgrade my RAM to 128GB."

---

## 🛡️ License
MIT
