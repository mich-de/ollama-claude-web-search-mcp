# Ollama + Claude Code + Web Search: Automated Installer
# Optimized for Windows (i9-12900 + T1000)

$ErrorActionPreference = "Stop"

Write-Host "🚀 Starting Automated Installation..." -ForegroundColor Cyan

# 1. Verify Prerequisites
Write-Host "[*] Checking Prerequisites..." -ForegroundColor Yellow
if (!(Get-Command ollama -ErrorAction SilentlyContinue)) { throw "Ollama not found. Please install it from https://ollama.com/" }
if (!(Get-Command node -ErrorAction SilentlyContinue)) { throw "Node.js not found. Please install it from https://nodejs.org/" }
if (!(Get-Command python -ErrorAction SilentlyContinue)) { throw "Python not found. Please install it from https://python.org/" }

# 2. Download Unsloth Qwen 3.5 4B Model
$modelFile = "Qwen3.5-4B-UD-Q4_K_XL.gguf"
if (!(Test-Path $modelFile)) {
    Write-Host "[*] Downloading Unsloth Qwen 3.5 4B GGUF (3.4GB)..." -ForegroundColor Yellow
    curl.exe -L -o $modelFile https://huggingface.co/unsloth/Qwen3.5-4B-GGUF/resolve/main/Qwen3.5-4B-UD-Q4_K_XL.gguf
} else {
    Write-Host "[+] Model file already exists. Skipping download." -ForegroundColor Green
}

# 3. Create Ollama Model
Write-Host "[*] Creating Ollama model 'qwen3.5-4b-unsloth'..." -ForegroundColor Yellow
$modelfileContent = @"
FROM ./$modelFile
PARAMETER num_thread 24
PARAMETER num_ctx 4096
PARAMETER temperature 0.7
SYSTEM "You are a professional AI Assistant with real-time web search capabilities."
"@
$modelfileContent | Out-File -FilePath Modelfile -Encoding utf8
ollama create qwen3.5-4b-unsloth -f Modelfile

# 4. Install Claude Code
Write-Host "[*] Installing Claude Code globally..." -ForegroundColor Yellow
npm install -g @anthropic-ai/claude-code

# 5. Setup Python Virtual Environment
Write-Host "[*] Setting up Python venv..." -ForegroundColor Yellow
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt

# 6. Configure Claude Desktop MCP
Write-Host "[*] Configuring Claude MCP settings..." -ForegroundColor Yellow
$appDataPath = [System.Environment]::GetFolderPath('ApplicationData')
$claudeConfigDir = Join-Path $appDataPath "Claude"
if (!(Test-Path $claudeConfigDir)) { New-Item -ItemType Directory -Path $claudeConfigDir }

$currentDir = Get-Location
$config = @{
    mcpServers = @{
        web_search = @{
            command = "$currentDir\.venv\Scripts\python.exe"
            args = @("$currentDir\mcp_server_search.py")
        }
    }
} | ConvertTo-Json -Depth 10

$config | Out-File -FilePath (Join-Path $claudeConfigDir "claude_desktop_config.json") -Encoding utf8

# 7. Add PowerShell Alias
Write-Host "[*] Adding 'claude-local' alias to PowerShell Profile..." -ForegroundColor Yellow
$aliasFunction = @"

function claude-local {
    `$env:ANTHROPIC_BASE_URL="http://localhost:11434"
    `$env:ANTHROPIC_AUTH_TOKEN="ollama"
    `$env:ANTHROPIC_API_KEY=""
    claude --model qwen3.5-4b-unsloth --mcp-config "$claudeConfigDir\claude_desktop_config.json"
}
"@
if (!(Test-Path $PROFILE)) { New-Item -Type File -Path $PROFILE -Force }
Add-Content -Path $PROFILE -Value $aliasFunction

Write-Host "✅ Installation Complete!" -ForegroundColor Green
Write-Host "👉 Restart your terminal and type 'claude-local' to start." -ForegroundColor Cyan
