# frontend.py (Streamlit) - versi diperbarui
import os
import streamlit as st
import requests
import base64
from pathlib import Path

# CONFIG: gunakan env var BACKEND_URL jika diset (berguna untuk deploy berbeda)
# Default: panggil backend internal di container (uvicorn pada 127.0.0.1:8000)
BACKEND_URL = os.getenv("BACKEND_URL", "http://127.0.0.1:8000")
REQUEST_TIMEOUT = int(os.getenv("REQUEST_TIMEOUT", "30"))  # detik

# helper: aman baca gambar (jika file tidak ada -> skip)
def safe_image_path(filename: str) -> str | None:
    p = Path(filename)
    if p.exists():
        return str(p)
    return None

def set_background(image_file):
    img_path = safe_image_path(image_file)
    if not img_path:
        # jika tidak ada file background, jangan crash — cukup lewati
        return
    with open(img_path, "rb") as f:
        img_data = f.read()
    b64 = base64.b64encode(img_data).decode()
    css = f"""
    <style>
    .stApp {{
        background-image: url(data:image/png;base64,{b64});
        background-size: cover;
        background-repeat: no-repeat;
        background-attachment: fixed;
        background-position: center;
    }}
    .stApp::before {{
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(38, 39, 48, 1);
        backdrop-filter: blur(10px);
        z-index: -1;
    }}
    [data-testid="stAppViewContainer"] {{
        color: #E0E0E0;
    }}
    [data-testid="stAppViewContainer"] h1,
    [data-testid="stAppViewContainer"] h2,
    [data-testid="stAppViewContainer"] h3 {{
        color: #FFFFFF;
    }}
    [data-testid="stChatMessage"] {{
        background-color: rgba(38, 39, 48, 0.8);
        border-radius: 10px;
        padding: 1rem !important;
        border: 1px solid rgba(255, 255, 255, 0.1);
    }}
    [data-testid="stAlert"] {{
        background-color: rgba(38, 39, 48, 0.9);
        border-radius: 10px;
        border: 1px solid rgba(255, 255, 255, 0.1);
    }}
    </style>
    """
    st.markdown(css, unsafe_allow_html=True)

# Page config
st.set_page_config(
    page_title="Laskar Budaya Aceh",
    page_icon="🕌",
    layout="wide"
)

# optional: set background if file exists in repo
set_background("masjid_raya_baiturrahman.png")

# Sidebar
with st.sidebar:
    logo_path = safe_image_path("rencong_aceh_logo.png")
    if logo_path:
        st.image(logo_path,  width='stretch')
    st.title("Navigasi")
    page = st.radio("Pilih Halaman:", ("Chatbot Budaya Aceh", "Prototipe Analisis Sentimen"))
    st.markdown("---")
    st.info("Aplikasi ini didukung oleh model AI pada backend FastAPI.")

# helper untuk panggil backend dengan error handling
def post_json(url: str, payload: dict, timeout: int = REQUEST_TIMEOUT):
    try:
        resp = requests.post(url, json=payload, timeout=timeout)
        resp.raise_for_status()
        try:
            return resp.json()
        except ValueError:
            return {"error": "Response bukan JSON", "raw_text": resp.text}
    except requests.exceptions.RequestException as e:
        return {"error": f"Request failed: {e}"}

# PAGE: Chatbot
if page == "Chatbot Budaya Aceh":
    st.title("Laskar Budaya: Chatbot Budaya Aceh 🕌")
    st.markdown("Silakan ajukan pertanyaan tentang sejarah, kuliner, tradisi Aceh, dsb.")
    st.markdown("---")

    if "chat_messages" not in st.session_state:
        st.session_state.chat_messages = [
            {"role": "assistant", "content": "Assalamu'alaikum! Ada yang bisa saya bantu untuk ceritakan tentang budaya Aceh?"}
        ]

    for message in st.session_state.chat_messages:
        with st.chat_message(message["role"]):
            st.markdown(message["content"])

    if prompt := st.chat_input("Contoh: 'Ceritakan tentang Kopi Gayo.'"):
        st.session_state.chat_messages.append({"role": "user", "content": prompt})
        with st.chat_message("user"):
            st.markdown(prompt)

        with st.chat_message("assistant"):
            with st.spinner("Juru Cerita kami sedang mencari informasi..."):
                # URL internal untuk memanggil FastAPI pada container yang sama
                url = f"{BACKEND_URL}/chat_budaya"
                result = post_json(url, {"message": prompt})
                if result is None or "error" in result:
                    st.error(f"Gagal terhubung ke backend: {result.get('error') if result else 'unknown error'}")
                    st.session_state.chat_messages.append({"role": "assistant", "content": "Maaf, tidak dapat terhubung ke backend."})
                else:
                    bot_response = result.get("bot_response") or result.get("answer") or str(result)
                    st.markdown(bot_response)
                    st.session_state.chat_messages.append({"role": "assistant", "content": bot_response})

# PAGE: Analisis Sentimen
else:
    st.title("Prototipe: Analisis Sentimen Budaya 📊")
    st.warning("DISCLAIMER: Model sentimen saat ini adalah prototipe dan dilatih pada dataset umum.")
    st.markdown("---")

    text_to_analyze = st.text_area(
        "Masukkan teks sastra / hikayat / puisi di sini:",
        "Malin Kundang adalah seorang anak yang durhaka pada ibunya...",
        height=150
    )

    if st.button("Analisis Sentimen"):
        if not text_to_analyze:
            st.warning("Mohon masukkan teks terlebih dahulu.")
        else:
            with st.spinner("Model sedang menganalisis..."):
                url = f"{BACKEND_URL}/predict_sentiment"
                result = post_json(url, {"text": text_to_analyze})
                if result is None or "error" in result:
                    st.error(f"Gagal terhubung ke backend: {result.get('error') if result else 'unknown error'}")
                else:
                    sentiment = result.get("sentiment", "tidak diketahui")
                    disclaimer = result.get("disclaimer", "")
                    st.subheader("Hasil Analisis Sentimen")
                    if sentiment == "positive":
                        st.success("Sentimen Terdeteksi: Positif")
                        st.write("Model mengidentifikasi nada yang positif.")
                    elif sentiment == "negative":
                        st.error("Sentimen Terdeteksi: Negatif")
                        st.write("Model mengidentifikasi nada yang negatif.")
                    else:
                        st.info("Sentimen Terdeteksi: Netral")
                        st.write("Model mengidentifikasi nada yang netral.")
                    if disclaimer:
                        st.caption(f"Catatan Model: \"{disclaimer}\"")

# NOTE untuk deploy:
# - Jika Streamlit dijalankan di container yang sama dengan FastAPI (seperti setup Docker yang saya buat),
#   biarkan BACKEND_URL default = http://127.0.0.1:8000
# - Jika Streamlit berjalan di mesin berbeda (mis. lokal) dan ingin panggil Space publik,
#   export BACKEND_URL=https://<space-name>-<username>.hf.space sebelum menjalankan Streamlit.
