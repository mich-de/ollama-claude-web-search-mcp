# Ollama + Claude Code: Free Web Search via MCP

This repository provides a step-by-step guide to setting up **Claude Code** (Anthropic's CLI agent) with a **Local Ollama Model** (optimized by Unsloth) and enabling **Free Web Search** using the Model Context Protocol (MCP).

## 🚀 Overview
- **LLM Engine**: [Ollama](https://ollama.com/)
- **Model**: Qwen 3.5 4B (Unsloth Optimized)
- **Interface**: Claude Code (CLI)
- **Web Search**: DuckDuckGo (Free, via MCP + Curl)
- **Hardware Optimized**: Tested on i9-12900 + 64GB RAM + NVIDIA T1000

## 🚀 Quick Start (Automated Install)

If you are on Windows, you can install everything (Model, Claude Code, MCP, Python Venv, and Aliases) with a single command:

1. Clone this repo and enter the directory.
2. Run the installer:
   ```powershell
   .\install.ps1
   ```
3. Restart your terminal and type: `claude-local`

---

## 🛠️ Manual Installation & Hardware Optimization

### 0. Install Claude Code (Official CLI)
Claude Code is the official Anthropic CLI agent. Install it globally using npm:
```bash
npm install -g @anthropic-ai/claude-code
```

### 1. Download the Unsloth Optimized Model
This setup uses the **Unsloth Qwen 3.5 4B (Dynamic 2.0 GGUF)**, which is specifically chosen for a balance between speed (fitting in 4GB VRAM) and intelligence.

1. Download the GGUF file from Hugging Face:
   ```powershell
   curl.exe -L -o Qwen3.5-4B-UD-Q4_K_XL.gguf https://huggingface.co/unsloth/Qwen3.5-4B-GGUF/resolve/main/Qwen3.5-4B-UD-Q4_K_XL.gguf
   ```

### 2. Configure for Hardware & Tool Support
Claude Code requires specific model naming and metadata to support tools (like web search). We recommend creating a model named `qwen3.5` by injecting the Unsloth GGUF into the official template:

```powershell
# 1. Pull the official model to get the correct template
ollama pull qwen3.5:4b

# 2. Export official Modelfile
ollama show qwen3.5:4b --modelfile | Out-File -FilePath Modelfile.official -Encoding utf8

# 3. Create perfectly compatible model (Automated via install.ps1 or manual edit)
# Ensure the 'FROM' line points to your Unsloth .gguf file
# Set 'PARAMETER num_thread 24' for i9-12900
ollama create qwen3.5 -f Modelfile.final
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

## 🏃 Usage (Official Ollama Integration)

To launch Claude Code with Ollama, set the official environment variables:

```powershell
# Set official Ollama-Claude integration variables
$env:ANTHROPIC_BASE_URL="http://localhost:11434"
$env:ANTHROPIC_AUTH_TOKEN="ollama"
# IMPORTANT: Unset any existing API Key to avoid conflict
Remove-Item Env:\ANTHROPIC_API_KEY -ErrorAction SilentlyContinue

# Launch Claude Code
claude --model qwen3.5 --mcp-config "$HOME\AppData\Roaming\Claude\claude_desktop_config.json"
```

---

## 🛠️ Troubleshooting & Reset

### 1. Auth Conflict Error
If you see `Both a token (ANTHROPIC_AUTH_TOKEN) and an API key (ANTHROPIC_API_KEY) are set`, you MUST remove the `ANTHROPIC_API_KEY` variable.

### 2. Model "does not support tools"
Claude Code checks the model name. Ensure your model is named exactly `qwen3.5` and was created using the official `TEMPLATE` (see step 2 above).

### 3. Drive/Path Issues (e.g. searching in D:\)
If Claude Code looks for resources in the wrong drive, perform a reset:
```powershell
# Logout and clear local cache/plugins
claude /logout
Remove-Item -Path "$HOME\AppData\Roaming\Claude\cache" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$HOME\AppData\Roaming\Claude\plugins" -Recurse -Force -ErrorAction SilentlyContinue
```

## ⚡ Quick Access & Aliases

### 1. PowerShell Alias (Official Standards)
Update your PowerShell Profile (`notepad $PROFILE`):

```powershell
function claude-local {
    $env:ANTHROPIC_BASE_URL="http://localhost:11434"
    $env:ANTHROPIC_AUTH_TOKEN="ollama"
    if (Test-Path Env:\ANTHROPIC_API_KEY) { Remove-Item Env:\ANTHROPIC_API_KEY }
    claude --model qwen3.5 --mcp-config "$HOME\AppData\Roaming\Claude\claude_desktop_config.json"
}
```

The Qwen 3.5 family (Unsloth Optimized) offers a model for every hardware tier. Use this matrix to find your best fit:

| Model Tier | VRAM (4-bit) | Recommended Hardware | Performance Profile |
| :--- | :--- | :--- | :--- |
| **0.8B / 1.5B** | ~1.5 GB | Low-end / Mobile | **Extreme Speed** (>150 t/s) |
| **4B (Your Fit)**| ~3.5 GB | **NVIDIA T1000 / RTX 3050** | **Instant** (Real-time) |
| **9B** | ~6.5 GB | RTX 3060 / 4060 (8GB) | **Fast** |
| **27B / 35B-A3B**| ~18 - 22 GB | RTX 3090 / 4090 (24GB) | **Moderate** (Smart MoE) |
| **122B / 397B** | 70GB - 210GB| Multi-GPU / Mac Studio | **Strategic** (Giant) |

---

## 🏗️ The "Value King" Build: Intel Arc A770 16GB
The **Intel Arc A770 16GB** is a hidden gem for local LLMs due to its large VRAM at a budget price. Here is how to build a balanced system around it:

### 1. Arc A770 Selection Matrix (Qwen 3.5)
| Model Size | VRAM Usage (4-bit) | Performance Profile |
| :--- | :--- | :--- |
| **9B** | ~6.5 GB | **Extremely Fast** (Full VRAM) |
| **14B** | ~9.5 GB | **The Sweet Spot** (Full VRAM) |
| **27B / 35B-A3B**| ~18 - 22 GB | **Balanced** (Hybrid VRAM/RAM) |
| **70B** | ~40 GB | **Slow** (Strategic Thinking) |

### 2. Recommended Companion Hardware
To avoid bottlenecks and enable "Hybrid Reasoning" (GPU + CPU), pair the Arc A770 16GB with:
- **CPU**: **Intel i7-14700K** or **i9-12900K** (20+ Threads). A strong CPU is vital for handling web search, RAG indexing, and offloading larger models.
- **System RAM**: **64GB DDR5 (5600MT/s+)**. While 16GB of VRAM is great, 64GB of system RAM allows you to run **DeepSeek R1** or **Qwen 3.5 70B** by sharing the load between the Arc A770 and your RAM.
- **Storage**: **NVMe Gen4 SSD**. Essential for loading 20GB+ models into memory in seconds rather than minutes.

*Note: Since you have **64GB of RAM**, you can run the **27B** or **35B-A3B** models by offloading them to the CPU. They will be slower but significantly smarter for complex reasoning tasks.*

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

### 💡 Example Usage of `claude-local`

Once you are inside the `claude-local` session, you can use it like this:

- **General Coding**: 
  `> Create a React component for a responsive navigation bar.`
- **Using Web Search**: 
  `> What is the current stock price of NVIDIA? Use your web search tool.`
- **Technical Research**: 
  `> Search for the latest best practices for securing a FastAPI application in 2026.`
- **File Analysis**:
  `> Read the content of 'main.py' and suggest optimizations for better memory usage.`

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
