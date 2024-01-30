#!/bin/bash

CGLFW="Custom GLFW"

if [ $# -gt 0 ]; then
    if [ "$1" = "--help" ]; then
        echo "$0 [clean]"
        exit 0
    fi
    if [ "$1" = "clean" ]; then
        echo "${CGLFW} executing make clean"
        rm -rf ./build
        exit 0
    else
        echo "Unknown parameter: $1"
        exit 1
    fi
fi

# Function to install packages on Debian/Ubuntu/Mint
install_debian_packages() {
    sudo apt install -y xorg-dev
}

# Function to install packages on RedHat/CentOS/Fedora
install_redhat_packages() {
    sudo dnf -y install libXcursor-devel libXi-devel libXinerama-devel libXrandr-devel
}

# Function to install packages on FreeBSD
install_freebsd_packages() {
    sudo pkg install -y xorgproto
}


# Detect the operating system
os_type=$(uname)
echo "${CGLFW} detected os type : $os_type"

# Detect the operating system
if [ ${os_type} == "Linux" ]; then
    
    # Check if Debian/Ubuntu/Mint
    if [ -f /etc/debian_version ]; then
        echo "${CGLFW}: debian"
        install_debian_packages
    # Check if RedHat/CentOS/Fedora
    elif [ -f /etc/redhat-release ]; then
        echo "${CGLFW}: redhat"
        install_redhat_packages
    else
        echo "Unsupported Linux distribution."
        exit 1
    fi
elif [ ${os_type} == "FreeBSD" ]; then
    echo "${CGLFW}: FreeBSD"
    install_freebsd_packages
else
    echo "Unsupported operating system: ${os_type}"
    exit 1
fi

mkdir -p build
echo "${CGLFW} build folder created"
cmake -S . -B ./build
echo "${CGLFW} cmake executed"

cd build
make

sudo cp ./build/src/libglfw3.a /usr/local/lib