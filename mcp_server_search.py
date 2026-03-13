import sys
import subprocess
from bs4 import BeautifulSoup
from mcp.server.fastmcp import FastMCP

# Initialize FastMCP server for "web_search"
mcp = FastMCP("web_search")

@mcp.tool()
def search_web(query: str) -> str:
    """Search the web via DuckDuckGo and return the most recent results."""
    print(f"[*] Searching for: {query}...", file=sys.stderr)
    url = f"https://html.duckduckgo.com/html/?q={query.replace(' ', '+')}"
    
    try:
        # Use curl.exe for robust cross-platform connectivity
        result = subprocess.run(['curl.exe', '-L', '-s', '-A', 'Mozilla/5.0', url], capture_output=True, text=True, encoding='utf-8')
        
        if result.returncode != 0:
            return f"Connection error: {result.stderr}"

        soup = BeautifulSoup(result.stdout, 'html.parser')
        results = []
        for entry in soup.find_all('div', class_='result'):
            title_tag = entry.find('a', class_='result__a')
            snippet_tag = entry.find('a', class_='result__snippet')
            
            if title_tag and snippet_tag:
                results.append(f"TITLE: {title_tag.get_text()}\nSUMMARY: {snippet_tag.get_text()}\nURL: {title_tag['href']}\n")
        
        return "\n".join(results[:5]) if results else "No results found."

    except Exception as e:
        return f"Scraping error: {e}"

if __name__ == "__main__":
    mcp.run()
