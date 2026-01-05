#!/bin/bash

set -e

echo "===================================="
echo " Laravel + Node.js Project Setup"
echo "===================================="

# ---------- VARIABLES ----------
PHP_VERSION="8.2"
NODE_VERSION="18"
BACKEND_DIR="backend"
FRONTEND_DIR="frontend"

# ---------- SYSTEM UPDATE ----------
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# ---------- BASIC TOOLS ----------
echo "Installing basic tools..."
sudo apt install -y \
    curl \
    git \
    unzip \
    software-properties-common \
    ca-certificates \
    lsb-release

# ---------- PHP ----------
echo "Installing PHP ${PHP_VERSION}..."
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update

sudo apt install -y \
    php${PHP_VERSION} \
    php${PHP_VERSION}-cli \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-mysql \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-bcmath \
    php${PHP_VERSION}-gd

php -v

# ---------- COMPOSER ----------
if ! command -v composer &> /dev/null
then
    echo "Installing Composer..."
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
fi

composer --version

# ---------- NODE.JS ----------
if ! command -v node &> /dev/null
then
    echo "Installing Node.js ${NODE_VERSION}..."
    curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | sudo -E bash -
    sudo apt install -y nodejs
fi

node -v
npm -v

# ---------- YARN ----------
if ! command -v yarn &> /dev/null
then
    echo "Installing Yarn..."
    npm install -g yarn
fi

yarn -v

# ---------- MYSQL CLIENT ----------
echo "Installing MySQL client..."
sudo apt install -y mysql-client

# ---------- LARAVEL SETUP ----------
if [ -d "$BACKEND_DIR" ]; then
    echo "Setting up Laravel backend..."

    cd $BACKEND_DIR

    if [ ! -f ".env" ]; then
        cp .env.example .env
    fi

    composer install --no-interaction --prefer-dist

    php artisan key:generate

    echo "Laravel backend ready ✅"
    cd ..
else
    echo "Backend directory not found ❌"
fi

# ---------- NODE / NEXT SETUP ----------
if [ -d "$FRONTEND_DIR" ]; then
    echo "Setting up frontend..."

    cd $FRONTEND_DIR

    if [ -f "package.json" ]; then
        yarn install
    fi

    echo "Frontend ready ✅"
    cd ..
else
    echo "Frontend directory not found ❌"
fi

# ---------- PERMISSIONS ----------
echo "Fixing permissions..."
sudo chown -R $USER:www-data .
sudo chmod -R 775 backend/storage backend/bootstrap/cache

echo "===================================="
echo " Setup Completed Successfully 🎉"
echo "===================================="
