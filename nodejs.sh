#!/bin/bash

# Script untuk menginstall Node.js dengan satu perintah
# Menggunakan NVM (Node Version Manager)

echo "Memulai instalasi Node.js menggunakan NVM..."

# Menginstall NVM
echo "Menginstall NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# Memuat NVM tanpa perlu restart terminal
echo "Memuat NVM ke lingkungan saat ini..."
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Menginstall Node.js versi spesifik
echo "Menginstall Node.js v22.15.0..."
nvm install v22.15.0

# Menggunakan Node.js versi yang diinstall
echo "Mengatur Node.js v22.15.0 sebagai versi default..."
nvm use v22.15.0

# Menampilkan versi Node.js dan npm yang terinstall
echo "Instalasi selesai!"
echo "Versi Node.js: $(node -v)"
echo "Versi npm: $(npm -v)"