#!/bin/bash

# Script untuk menginstall Node.js langsung dari NodeSource
# Deteksi OS dan versi
if [ -f /etc/os-release ]; then
    # Distribusi berbasis freedesktop.org
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    # Distribusi berbasis linuxbase.org
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
else
    # Fallback ke uname
    OS=$(uname -s)
    VER=$(uname -r)
fi

echo "Terdeteksi OS: $OS $VER"

# Menentukan versi Node.js (default: 22.x)
NODE_MAJOR_VERSION=${1:-"22"}

# Instalasi untuk distribusi berbasis Debian/Ubuntu
if [[ "$OS" == *"Ubuntu"* ]] || [[ "$OS" == *"Debian"* ]] || [ -f /etc/debian_version ]; then
    echo "Menginstall Node.js ${NODE_MAJOR_VERSION}.x untuk Debian/Ubuntu..."
    
    # Perbarui apt dan install dependensi
    sudo apt update
    sudo apt install -y ca-certificates curl gnupg
    
    # Tambahkan NodeSource repository
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR_VERSION}.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
    
    # Install Node.js
    sudo apt update
    sudo apt install -y nodejs
    
# Instalasi untuk distribusi berbasis Red Hat/CentOS/Fedora
elif [[ "$OS" == *"CentOS"* ]] || [[ "$OS" == *"Red Hat"* ]] || [[ "$OS" == *"Fedora"* ]]; then
    echo "Menginstall Node.js ${NODE_MAJOR_VERSION}.x untuk RedHat/CentOS/Fedora..."
    
    # Tambahkan NodeSource repository
    sudo dnf module disable -y nodejs
    curl -fsSL https://rpm.nodesource.com/setup_${NODE_MAJOR_VERSION}.x | sudo bash -
    
    # Install Node.js
    sudo dnf install -y nodejs
    
# Instalasi untuk distribusi berbasis Amazon Linux
elif [[ "$OS" == *"Amazon"* ]]; then
    echo "Menginstall Node.js ${NODE_MAJOR_VERSION}.x untuk Amazon Linux..."
    
    # Tambahkan NodeSource repository
    curl -fsSL https://rpm.nodesource.com/setup_${NODE_MAJOR_VERSION}.x | sudo bash -
    
    # Install Node.js
    sudo yum install -y nodejs
    
else
    echo "Sistem operasi tidak didukung secara langsung. Mencoba cara umum..."
    
    # Fallback ke NVM
    echo "Menginstall melalui NVM sebagai fallback..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm install ${NODE_MAJOR_VERSION}
    nvm use ${NODE_MAJOR_VERSION}
    nvm alias default ${NODE_MAJOR_VERSION}
    
    echo "Jika menggunakan NVM, jalankan 'source ~/.bashrc' untuk mengaktifkan Node.js"
fi

# Cek versi yang terinstall
if command -v node &> /dev/null; then
    echo "Instalasi selesai!"
    echo "Versi Node.js: $(node -v)"
    echo "Versi npm: $(npm -v)"
else
    echo "ERROR: Instalasi Node.js tidak berhasil. Silakan coba cara lain atau periksa log untuk informasi lebih lanjut."
fi
