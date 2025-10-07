# =============================
# Hugging Face Spaces Dockerfile
# FastAPI (backend) + Streamlit (frontend) + nginx reverse proxy
# =============================

FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    build-essential \
    gcc \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# --- Copy requirements ---
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# --- Create writable cache dirs for huggingface / transformers ---
ENV HF_HOME=/app/.hf
ENV TRANSFORMERS_CACHE=/app/.hf/transformers
ENV XDG_CACHE_HOME=/app/.hf/xdg

RUN mkdir -p /app/.hf/transformers /app/.hf/xdg && chmod -R 0777 /app/.hf || true

# --- Copy project files ---
COPY . /app

# --- Copy nginx config & startup script ---
COPY nginx.conf /etc/nginx/nginx.conf
COPY start.sh /start.sh
RUN chmod +x /start.sh

# --- Expose Hugging Face public port ---
EXPOSE 7860

# --- Run ---
CMD ["/start.sh"]
