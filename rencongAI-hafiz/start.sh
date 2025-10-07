#!/bin/bash
set -euo pipefail

cd /app

echo "🧩 Preparing Hugging Face cache directories..."
export HF_HOME=/app/.hf
export TRANSFORMERS_CACHE=/app/.hf/transformers
export SENTENCE_TRANSFORMERS_HOME=/app/.hf/sentence_transformers
export XDG_CACHE_HOME=/app/.hf/xdg

mkdir -p "$HF_HOME" "$TRANSFORMERS_CACHE" "$SENTENCE_TRANSFORMERS_HOME" "$XDG_CACHE_HOME"
chmod -R 0777 "$HF_HOME" "$TRANSFORMERS_CACHE" "$SENTENCE_TRANSFORMERS_HOME" "$XDG_CACHE_HOME" || true
echo "✅ HF cache dirs created at $HF_HOME"

# --- Prepare nginx temp dirs ---
mkdir -p /tmp/nginx/client_body /tmp/nginx/proxy /tmp/nginx/fastcgi_temp /tmp/nginx/uwsgi_temp /tmp/nginx/scgi_temp /tmp/nginx/logs
chmod -R 0777 /tmp/nginx || true

# --- Start FastAPI backend ---
echo "🚀 Starting FastAPI (uvicorn) on 127.0.0.1:8000 ..."
python -m uvicorn main:app --host 127.0.0.1 --port 8000 --workers 1 &
UVICORN_PID=$!

# --- Start Streamlit frontend ---
echo "🎨 Starting Streamlit (frontend.py) on 127.0.0.1:8501 ..."
python -m streamlit run frontend.py \
  --server.address 127.0.0.1 \
  --server.port 8501 \
  --server.headless true \
  --server.enableCORS false \
  --server.enableXsrfProtection false &
STREAMLIT_PID=$!

# --- Start nginx ---
echo "🌐 Starting nginx ..."
nginx -c /etc/nginx/nginx.conf -g 'daemon off;' &
NGINX_PID=$!

# --- Wait for any process to exit ---
wait -n $UVICORN_PID $STREAMLIT_PID $NGINX_PID
EXIT_CODE=$?
echo "⚠️ One process exited with code $EXIT_CODE, stopping others..."
kill -TERM $UVICORN_PID $STREAMLIT_PID $NGINX_PID || true
wait
exit $EXIT_CODE
