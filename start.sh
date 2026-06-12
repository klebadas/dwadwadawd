#!/bin/sh

if [ -z "$TUNNEL_TOKEN" ]; then
  echo "ERRO: variavel TUNNEL_TOKEN nao definida"
  exit 1
fi

echo "Iniciando healthcheck HTTP na porta ${PORT:-8080}..."
python3 -m http.server ${PORT:-8080} &

echo "Versao do cloudflared:"
cloudflared --version

echo "Iniciando Cloudflare Tunnel..."
exec cloudflared tunnel --no-autoupdate run --token "$TUNNEL_TOKEN"
