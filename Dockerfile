FROM alpine:latest

# Instala as ferramentas necessárias
RUN apk add --no-cache curl python3

# Baixa e configura o cloudflared
RUN curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared

EXPOSE 10000

# Cria o script Python que pega a URL externa da Render e faz o ping real por fora
RUN echo 'import http.server, socketserver, urllib.request, time, threading, os\n\
def ping():\n\
    time.sleep(30)\n\
    url = os.environ.get("RENDER_EXTERNAL_URL")\n\
    if not url: return\n\
    while True:\n\
        try:\n\
            urllib.request.urlopen(url)\n\
            print(f"Ping externo enviado para: {url}")\n\
        except Exception as e: print("Erro no ping:", e)\n\
        time.sleep(300)\n\
threading.Thread(target=ping, daemon=True).start()\n\
socketserver.TCPServer(("0.0.0.0", 10000), http.server.SimpleHTTPRequestHandler).serve_forever()' > /app.py

# Inicia o servidor e o túnel
CMD python3 /app.py & exec cloudflared tunnel run --token $TUNNEL_TOKEN
