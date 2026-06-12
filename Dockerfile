FROM alpine:latest

# Instala o cloudflared, curl (para o healthcheck) e o python3 (para o servidor web fake)
RUN apk add --no-cache curl python3

# Baixa a versão mais recente do binário do cloudflared
RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O /usr/local/bin/cloudflared
RUN chmod +x /usr/local/bin/cloudflared

# Cria uma página HTML simples para a Render checar se o serviço está vivo
RUN echo "<h1>Tunnel Active</h1>" > /index.html

# Comando que roda o servidor fake na porta que a Render mandar ($PORT) e inicia o túnel da Cloudflare
CMD python3 -m http.server $PORT & cloudflared tunnel run --token $TUNNEL_TOKEN
