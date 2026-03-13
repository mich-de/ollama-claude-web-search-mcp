# Antigravity Local AI Setup - Memory Log

## 📅 Session Date: 2026-03-13
**Hardware Context:**
- **CPU**: Intel Core i9-12900 (16 Cores, 24 Threads)
- **GPU**: NVIDIA T1000 (4GB VRAM)
- **RAM**: 64GB DDR5
- **OS**: Windows 11 (C: Drive focus)

---

## ✅ Accomplishments

### 1. Model Optimization (Ollama + Unsloth)
- **Model**: Qwen 3.5 4B (Unsloth Dynamic 2.0 Quantization).
- **Optimization**: Created a custom Ollama model named `qwen3.5` by injecting the Unsloth GGUF into the official Alibaba template to ensure full **Tool Support**.
- **Performance Tuning**: Forced usage of all **24 CPU threads** and a **16k Context Window** to handle large Claude Code prompts without lag.

### 2. Interface Integration (Claude Code)
- **Official Standards**: Configured environment variables based on official Ollama docs:
  - `ANTHROPIC_BASE_URL="http://localhost:11434"`
  - `ANTHROPIC_AUTH_TOKEN="ollama"`
  - Removed `ANTHROPIC_API_KEY` to avoid authentication conflicts.
- **Shortcut**: Created a permanent PowerShell alias `claude-local` and a batch script `claude-start.bat`.

### 3. Web Search Capabilities (MCP)
- **Protocol**: Model Context Protocol (MCP).
- **Server**: Developed a custom `mcp_server_search.py` using `curl.exe` and `BeautifulSoup` to perform free web searches via DuckDuckGo (bypassing library-level SSL issues).
- **Config**: Integrated the server into `%APPDATA%\Claude\claude_desktop_config.json`.

### 4. System Cleanup & Fixes
- **Drive Path Conflict**: Successfully performed a "Nuclear Reset" of Claude Code to eliminate old references to `D:\Antigravity_Profile`.
- **Location**: Everything is now cleanly installed on `C:\Users\mdeangelis\.local\bin`.

---

## 🛠️ Current Status
- **Repository**: `https://github.com/mich-de/ollama-claude-web-search-mcp`
- **Installer**: `install.ps1` automated script is fully functional.
- **Ready to Use**: Restart terminal -> Type `claude-local`.

---

## 🚀 Next Steps (To-Do)
- [ ] Test the web search tool within a live Claude Code session after restart.
- [ ] Explore increasing context beyond 16k if stability remains high.
- [ ] Potentially add more MCP tools (Filesystem access, SQL database queries).

---
*End of log. Reset and ready for operation.*
