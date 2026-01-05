# PHP & Composer Installation Guide

This guide explains how to install and configure **PHP** and **Composer** for Laravel or any PHP-based project on **Ubuntu 20.04 / 22.04**.

---

## 1. System Requirements

* Ubuntu 20.04 / 22.04
* sudo privileges
* Internet connection

---

## 2. Update System

```bash
sudo apt update && sudo apt upgrade -y
```

---

## 3. Install Required Dependencies

```bash
sudo apt install -y software-properties-common ca-certificates lsb-release curl unzip
```

---

## 4. Install PHP (8.2 Recommended)

Add PHP repository:

```bash
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update
```

Install PHP and common extensions:

```bash
sudo apt install -y \
php8.2 \
php8.2-cli \
php8.2-fpm \
php8.2-common \
php8.2-mbstring \
php8.2-xml \
php8.2-curl \
php8.2-zip \
php8.2-bcmath \
php8.2-gd \
php8.2-mysql
```

Verify PHP installation:

```bash
php -v
```

---

## 5. Configure PHP (Recommended Settings)

Edit PHP configuration:

```bash
sudo nano /etc/php/8.2/cli/php.ini
```

Recommended values:

```ini
memory_limit = 512M
upload_max_filesize = 50M
post_max_size = 50M
max_execution_time = 300
date.timezone = Asia/Dhaka
```
```sh
sudo apt install php8.4-fpm

Apache-এ FPM enable

sudo a2enmod proxy_fcgi setenvif
sudo a2enconf php8.4-fpm

sudo systemctl restart php8.4-fpm
sudo systemctl restart apache2

```

Restart PHP-FPM (if used):

```bash
sudo systemctl restart php8.2-fpm
```

---

## 6. Install Composer

Download and install Composer globally:

```bash
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
```

Verify Composer installation:

```bash
composer --version
```

---

## 7. Configure Composer (Recommended)

Increase Composer memory limit:

```bash
export COMPOSER_MEMORY_LIMIT=-1
```

Make it permanent:

```bash
echo 'export COMPOSER_MEMORY_LIMIT=-1' >> ~/.bashrc
source ~/.bashrc
```

---

## 8. Laravel Recommended Extensions Check

```bash
php -m
```

Ensure these extensions exist:

* openssl
* pdo
* mbstring
* tokenizer
* xml
* ctype
* json
* bcmath

---

## 9. Common Issues & Fixes

### PHP Version Conflict

```bash
sudo update-alternatives --set php /usr/bin/php8.2
```

### Composer Permission Issue

```bash
sudo chown -R $USER:$USER ~/.composer
```

### Zip Extension Missing

```bash
sudo apt install php8.2-zip -y
```

---

## 10. Recommended Production Versions

* PHP: 8.2
* Composer: Latest Stable

---

## Done ✅

PHP and Composer are now fully installed and ready for Laravel or any PHP project.

You can now run:

```bash
composer install
```

and start developing 🚀
