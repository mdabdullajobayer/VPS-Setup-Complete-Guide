# Apache2 Installation & Configuration (Laravel + Node.js)

This guide explains how to **install, configure, and optimize Apache2** for a project using **Laravel (API backend)** and **Node.js / Next.js (frontend)** on **Ubuntu 20.04 / 22.04**.

---

## 1. System Requirements

* Ubuntu 20.04 / 22.04
* PHP 8.2+
* Node.js 18+
* Laravel 10+
* MySQL / MariaDB
* sudo privileges

---

## 2. Install Apache2

```bash
sudo apt update
sudo apt install apache2 -y
```

Check status:

```bash
sudo systemctl status apache2
```

Enable Apache on boot:

```bash
sudo systemctl enable apache2
```

---

## 3. Enable Required Apache Modules

Laravel requires several Apache modules.

```bash
sudo a2enmod rewrite
sudo a2enmod headers
sudo a2enmod ssl
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod proxy_fcgi
sudo a2enmod setenvif
```

Restart Apache:

```bash
sudo systemctl restart apache2
```

---

## 4. Configure PHP-FPM (Recommended)

Install PHP-FPM:

```bash
sudo apt install php8.2-fpm -y
```

Enable PHP-FPM configuration:

```bash
sudo a2enconf php8.2-fpm
sudo systemctl restart apache2
```

---

## 5. Laravel Virtual Host Configuration

Create a virtual host file:

```bash
sudo nano /etc/apache2/sites-available/laravel.conf
```

### Example Configuration

```apache
<VirtualHost *:80>
    ServerName api.example.com
    DocumentRoot /var/www/project/backend/public

    <Directory /var/www/project/backend/public>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/laravel_error.log
    CustomLog ${APACHE_LOG_DIR}/laravel_access.log combined
</VirtualHost>
```

Enable site:

```bash
sudo a2ensite laravel.conf
sudo a2dissite 000-default.conf
sudo systemctl reload apache2
```

---

## 6. File Permissions (Laravel)

```bash
sudo chown -R www-data:www-data /var/www/project/backend
sudo chmod -R 775 /var/www/project/backend/storage
sudo chmod -R 775 /var/www/project/backend/bootstrap/cache
```

---

## 7. Apache Reverse Proxy for Node.js / Next.js

Apache can proxy requests to a Node.js app running on **port 3000**.

```apache
<VirtualHost *:80>
    ServerName www.example.com

    ProxyPreserveHost On
    ProxyPass / http://127.0.0.1:3000/
    ProxyPassReverse / http://127.0.0.1:3000/

    ErrorLog ${APACHE_LOG_DIR}/node_error.log
    CustomLog ${APACHE_LOG_DIR}/node_access.log combined
</VirtualHost>
```

Enable proxy modules and reload:

```bash
sudo systemctl reload apache2
```

---

## 8. Enable HTTPS (Let’s Encrypt)

Install Certbot:

```bash
sudo apt install certbot python3-certbot-apache -y
```

Generate SSL:

```bash
sudo certbot --apache
```

Auto-renew check:

```bash
sudo certbot renew --dry-run
```

---

## 9. Security & Performance Tips

* Disable directory listing
* Use `.env` outside public access
* Enable OPcache
* Use HTTP/2 with SSL
* Set proper CORS headers

---

## 10. Common Commands

Restart Apache:

```bash
sudo systemctl restart apache2
```

Check config:

```bash
sudo apachectl configtest
```

View logs:

```bash
tail -f /var/log/apache2/laravel_error.log
```

---

## 11. Recommended Production Stack

* Apache + PHP-FPM
* Laravel API
* Next.js with PM2
* MySQL / RDS
* Cloudflare CDN

---

## Done ✅

Your Apache2 server is now fully configured for **Laravel + Node.js**.

For Docker, CI/CD, or PM2 integration — extend this setup as needed.
