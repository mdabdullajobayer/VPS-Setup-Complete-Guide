---

## 11. PM2 Setup for Node.js / Next.js

PM2 is used to keep your Node.js / Next.js app running in production with auto-restart and startup on reboot.

---

## 11.1 Install PM2

```bash
sudo npm install -g pm2
```

Verify installation:

```bash
pm2 -v
```

---

## 11.2 Start Next.js / Node App with PM2

Go to your frontend directory:

```bash
cd /var/www/project/frontend
```

### For Next.js (production build)

```bash
npm run build
pm2 start npm --name "next-app" -- start
```

### For Custom Node.js App

```bash
pm2 start app.js --name "node-app"
```

---

## 11.3 PM2 Ecosystem File (Recommended)

Create ecosystem file:

```bash
pm2 ecosystem
```

Edit `ecosystem.config.js`:

```js
module.exports = {
  apps: [
    {
      name: "next-app",
      script: "npm",
      args: "start",
      cwd: "/var/www/project/frontend",
      env: {
        NODE_ENV: "production",
        PORT: 3000
      }
    }
  ]
};
```

Start app:

```bash
pm2 start ecosystem.config.js
```

---

## 11.4 Enable PM2 on Server Boot

```bash
pm2 startup
```

Copy and run the generated command, then save process list:

```bash
pm2 save
```

---

## 11.5 PM2 Useful Commands

```bash
pm2 list
pm2 logs
pm2 restart next-app
pm2 stop next-app
pm2 delete next-app
```

---

## 11.6 Apache + PM2 Architecture

* Apache handles HTTP/HTTPS & SSL
* Apache proxies traffic to Node.js (PM2)
* PM2 keeps Node.js app alive

Request Flow:

```text
Client → Apache (80/443) → PM2 (Node.js :3000)
```

---

## 12. Recommended Production Stack

* Apache + PHP-FPM
* Laravel API
* Next.js with PM2
* MySQL / RDS
* Cloudflare CDN

---

## Done ✅

Your Apache2 server is now fully configured for **Laravel + Node.js**.

For Docker, CI/CD, or PM2 integration — extend this setup as needed.
