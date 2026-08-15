# Example Production Deployment Doc

## 1) Server and DNS

* Server public IP: `203.0.113.10`
* All domains point to this IP:

  * `example.com`
  * `back.example.com`
  * `shop.example.com`
  * `vapi.example.com`
  * `vdb.example.com`

## 2) Domain Routing Map

* `example.com` -> Nginx proxy -> `127.0.0.1:3000` -> PM2 app `web-client`
* `back.example.com` -> Nginx proxy -> `127.0.0.1:3001` -> PM2 app `admin-client`
* `shop.example.com` -> Nginx proxy -> `127.0.0.1:3002` -> PM2 app `landing-client`
* `vapi.example.com` -> Nginx Laravel site -> `/var/www/Backend/public` (php8.3-fpm)
* `vdb.example.com` -> Nginx phpMyAdmin site -> `/usr/share/phpmyadmin` (php8.3-fpm)

## 3) Active PM2 Config

File: `/var/www/ecosystem.config.cjs`

```js
module.exports = {
  apps: [
    {
      // domain: back.example.com
      name: 'admin-client',
      script: 'npm',
      args: 'run preview -- --host 0.0.0.0 --port 3001',
      cwd: '/var/www/admin-client',
      instances: 1,
      exec_mode: 'fork'
    },
    {
      // domain: example.com
      name: 'web-client',
      script: 'npm',
      args: 'run start -- --port 3000',
      cwd: '/var/www/web-client',
      instances: 1,
      exec_mode: 'fork'
    },
    {
      // domain: shop.example.com
      name: 'landing-client',
      script: 'npm',
      args: 'run start -- --port 3002',
      cwd: '/var/www/landing-client',
      instances: 1,
      exec_mode: 'fork'
    }
  ]
};
```

PM2 commands:

```bash
pm2 restart /var/www/ecosystem.config.cjs --update-env
pm2 save
pm2 list
```

## 4) Active Nginx Site Files

* `/etc/nginx/sites-available/example.com`
* `/etc/nginx/sites-available/back.example.com`
* `/etc/nginx/sites-available/shop.example.com`
* `/etc/nginx/sites-available/vapi.example.com`
* `/etc/nginx/sites-available/vdb.example.com`

All are enabled via symlink in:

* `/etc/nginx/sites-enabled/`

## 5) SSL (Let's Encrypt)

Certificate name:

* `example.com`

Covered domains in same cert:

* `example.com`
* `back.example.com`
* `shop.example.com`
* `vapi.example.com`
* `vdb.example.com`

Certificate paths:

* `/etc/letsencrypt/live/example.com/fullchain.pem`
* `/etc/letsencrypt/live/example.com/privkey.pem`

Re-apply cert to Nginx blocks:

```bash
sudo certbot --nginx --non-interactive --agree-tos --keep-until-expiring --cert-name example.com -d example.com -d back.example.com -d shop.example.com -d vapi.example.com -d vdb.example.com
```

Renewal test:

```bash
sudo certbot renew --dry-run
```

## 6) Nginx and Service Commands

Syntax check and reload:

```bash
sudo nginx -t
sudo systemctl reload nginx
```

Service status:

```bash
systemctl status nginx --no-pager
systemctl status php8.3-fpm --no-pager
```

## 7) Validation Commands

Ports:

```bash
ss -ltnp | grep -E ':80 |:443 |:3000 |:3001 |:3002 '
```

HTTP/HTTPS checks:

```bash
curl -I http://example.com
curl -I http://back.example.com
curl -I http://shop.example.com
curl -I http://vapi.example.com
curl -I http://vdb.example.com

curl -I https://example.com
curl -I https://back.example.com
curl -I https://shop.example.com
curl -I https://vapi.example.com
curl -I https://vdb.example.com
```

Local host-header checks:

```bash
curl -I -H 'Host: example.com' http://127.0.0.1
curl -I -H 'Host: back.example.com' http://127.0.0.1
curl -I -H 'Host: shop.example.com' http://127.0.0.1
curl -I -H 'Host: vapi.example.com' http://127.0.0.1
curl -I -H 'Host: vdb.example.com' http://127.0.0.1
```

## 8) Laravel and phpMyAdmin Notes

Laravel (`vapi`):

* Root must be `/var/www/Backend/public`
* php-fpm socket: `/run/php/php8.3-fpm.sock`
* Writable dirs:

  * `/var/www/Backend/storage`
  * `/var/www/Backend/bootstrap/cache`

Permissions example:

```bash
sudo chown -R www-data:www-data /var/www/Backend
sudo chmod -R 775 /var/www/Backend/storage /var/www/Backend/bootstrap/cache
```

phpMyAdmin (`vdb`):

* Root: `/usr/share/phpmyadmin`
* php-fpm socket: `/run/php/php8.3-fpm.sock`

## 9) Common Problems and Fix

### Problem: Browser shows `ERR_CONNECTION_REFUSED` on domain

* Check if 443 is listening:

```bash
ss -ltnp | grep ':443 '
```

* If not listening, run the Certbot Nginx deploy command in Section 5.

### Problem: `back.example.com` returns 403 but port 3001 works

Keep proxy host headers as configured in `back.example.com`:

```nginx
proxy_set_header Host 127.0.0.1:3001;
proxy_set_header X-Forwarded-Host $host;
```

### Problem: `vdb.example.com` shows old page in browser only

* Likely local DNS/browser cache.
* Test with `curl` and Incognito mode.

## 10) Quick Recovery Runbook

```bash
sudo nginx -t && sudo systemctl reload nginx
pm2 restart /var/www/ecosystem.config.cjs --update-env
pm2 save
ss -ltnp | grep -E ':80 |:443 |:3000 |:3001 |:3002 '
curl -I https://example.com
curl -I https://back.example.com
curl -I https://shop.example.com
curl -I https://vapi.example.com
curl -I https://vdb.example.com
```
