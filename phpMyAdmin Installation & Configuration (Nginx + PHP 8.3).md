# phpMyAdmin Installation & Configuration (Nginx + PHP 8.3)

This guide explains how to install and configure phpMyAdmin on an Ubuntu server running **Nginx**, **PHP 8.3**, and **MySQL/MariaDB**.

---

## Requirements

- Ubuntu 22.04 / 24.04
- Nginx
- PHP 8.3 (FPM)
- MySQL or MariaDB
- sudo/root access

---

## Step 1: Update System

```bash
sudo apt update
sudo apt upgrade -y
```

---

## Step 2: Install PHP Extensions

```bash
sudo apt install -y \
php8.3-fpm \
php8.3-cli \
php8.3-common \
php8.3-mysql \
php8.3-mbstring \
php8.3-xml \
php8.3-curl \
php8.3-zip \
php8.3-gd \
php8.3-bcmath \
unzip \
wget \
curl
```

Restart PHP:

```bash
sudo systemctl restart php8.3-fpm
```

---

## Step 3: Download phpMyAdmin

Download the latest release from the official website.

Check the latest version:

```bash
curl https://www.phpmyadmin.net/home_page/version.txt
```

Download the latest release:

```bash
VERSION=$(curl -s https://www.phpmyadmin.net/home_page/version.txt | head -n1)

wget https://files.phpmyadmin.net/phpMyAdmin/${VERSION}/phpMyAdmin-${VERSION}-all-languages.zip
```

Extract:

```bash
unzip phpMyAdmin-${VERSION}-all-languages.zip

sudo mv phpMyAdmin-${VERSION}-all-languages /usr/share/phpmyadmin
```

---

## Step 4: Configure phpMyAdmin

```bash
cd /usr/share/phpmyadmin

sudo cp config.sample.inc.php config.inc.php
```

Generate Blowfish Secret:

```bash
openssl rand -base64 32
```

Edit configuration:

```bash
sudo nano config.inc.php
```

Find:

```php
$cfg['blowfish_secret'] = '';
```

Replace with:

```php
$cfg['blowfish_secret'] = 'YOUR_RANDOM_SECRET_KEY';
```

---

## Step 5: Create Temporary Directory

```bash
sudo mkdir -p /usr/share/phpmyadmin/tmp

sudo chown -R www-data:www-data /usr/share/phpmyadmin

sudo chmod 755 /usr/share/phpmyadmin/tmp
```

---

## Step 6: Configure Nginx

Edit your site configuration:

```bash
sudo nano /etc/nginx/sites-available/default
```

Add inside the `server` block:

```nginx
location /phpmyadmin {

    alias /usr/share/phpmyadmin/;

    index index.php;

    location ~ \.php$ {

        include snippets/fastcgi-php.conf;

        fastcgi_param SCRIPT_FILENAME $request_filename;

        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
    }

    location ~* \.(css|js|jpg|jpeg|gif|png|ico|svg)$ {

        expires max;

        log_not_found off;
    }
}
```

---

## Step 7: Test Configuration

```bash
sudo nginx -t
```

If successful:

```bash
sudo systemctl reload nginx
sudo systemctl restart php8.3-fpm
```

---

## Step 8: Access phpMyAdmin

```
http://YOUR_SERVER_IP/phpmyadmin
```

or

```
https://yourdomain.com/phpmyadmin
```

---

# Troubleshooting

## 404 Not Found

- Verify phpMyAdmin directory exists.

```bash
ls -la /usr/share/phpmyadmin
```

- Check Nginx configuration.

```bash
sudo nginx -t
```

---

## PHP File Download Instead of Opening

Check PHP-FPM:

```bash
sudo systemctl status php8.3-fpm
```

Restart:

```bash
sudo systemctl restart php8.3-fpm
```

---

## Permission Issues

```bash
sudo chown -R www-data:www-data /usr/share/phpmyadmin

sudo chmod -R 755 /usr/share/phpmyadmin
```

---

## phpMyAdmin Version

```bash
curl https://www.phpmyadmin.net/home_page/version.txt
```

---

# Useful Commands

Restart PHP:

```bash
sudo systemctl restart php8.3-fpm
```

Restart Nginx:

```bash
sudo systemctl restart nginx
```

Reload Nginx:

```bash
sudo systemctl reload nginx
```

Check PHP Version:

```bash
php -v
```

Check Nginx Version:

```bash
nginx -v
```

Check MySQL Version:

```bash
mysql --version
```

---

# Security Recommendations

- Disable root login in phpMyAdmin.
- Use HTTPS.
- Restrict `/phpmyadmin` access by IP if possible.
- Use strong MySQL passwords.
- Keep phpMyAdmin updated.
- Regularly update the server packages.

---

# References

- https://www.phpmyadmin.net/
- https://nginx.org/
- https://www.php.net/
