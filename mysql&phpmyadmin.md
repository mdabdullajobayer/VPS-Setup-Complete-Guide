## 12. MySQL & phpMyAdmin Installation and Setup

This section explains how to install and configure **MySQL Server** and **phpMyAdmin** for a Laravel + Node.js production environment.

---

## 12.1 Install MySQL Server

```bash
sudo apt update
sudo apt install mysql-server -y
```

Check MySQL status:

```bash
sudo systemctl status mysql
```

Enable MySQL on boot:

```bash
sudo systemctl enable mysql
```

---

## 12.2 Secure MySQL Installation

Run the security script:

```bash
sudo mysql_secure_installation
```

Recommended answers:

* VALIDATE PASSWORD: Yes
* Password strength: Medium or Strong
* Remove anonymous users: Yes
* Disallow root login remotely: Yes
* Remove test database: Yes
* Reload privilege tables: Yes

---

## 12.3 Create Database & User for Laravel

Login to MySQL:

```bash
sudo mysql
```

Run the following SQL:

```sql
CREATE DATABASE laravel_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'laravel_user'@'localhost' IDENTIFIED BY 'strong_password';
GRANT ALL PRIVILEGES ON laravel_db.* TO 'laravel_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

Update Laravel `.env`:

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=laravel_db
DB_USERNAME=laravel_user
DB_PASSWORD=strong_password
```

---

## 12.4 Install phpMyAdmin

```bash
sudo apt install phpmyadmin -y
```

During installation:

* Select **apache2** (press space, then Enter)
* Choose **Yes** for database configuration
* Set phpMyAdmin MySQL password

---

## 12.5 Enable phpMyAdmin in Apache

If phpMyAdmin is not accessible, manually enable config:

```bash
sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
sudo systemctl restart apache2
```

Access phpMyAdmin:

```text
http://your-domain.com/phpmyadmin
```

---

## 12.6 phpMyAdmin Security (Highly Recommended)

### Change phpMyAdmin URL

```bash
sudo mv /usr/share/phpmyadmin /usr/share/db-admin
sudo ln -s /usr/share/db-admin /var/www/html/secure-db
```

Access:

```text
http://your-domain.com/secure-db
```

### Restrict Access by IP (Optional)

Edit Apache config:

```bash
sudo nano /etc/apache2/conf-available/phpmyadmin.conf
```

Add:

```apache
<Directory /usr/share/db-admin>
    Require ip YOUR_IP_ADDRESS
</Directory>
```

Reload Apache:

```bash
sudo systemctl reload apache2
```

---

## 12.7 Fix Common phpMyAdmin Issues

### mysqli extension missing

```bash
sudo apt install php8.2-mysql -y
sudo systemctl restart apache2
```

### Authentication error (MySQL 8)

```bash
sudo mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
FLUSH PRIVILEGES;
EXIT;
```

---

## 13. Recommended Production Stack

* Apache + PHP-FPM
* Laravel API
* Next.js with PM2
* MySQL / RDS
* Cloudflare CDN

---

## Done ✅

Your Apache2 server is now fully configured for **Laravel + Node.js**.

For Docker, CI/CD, or PM2 integration — extend this setup as needed.
