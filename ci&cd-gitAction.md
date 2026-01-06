### VPS

```bash
node -v
npm -v
pm2 -v
```
#### VPS SSH key Generate 
```bash
ssh-keygen -t ed25519 -C "github-actions"

Enter → Enter → Enter
 
~/.ssh/id_ed25519        (PRIVATE KEY)
~/.ssh/id_ed25519.pub    (PUBLIC KEY)

# VPS public key allow
cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

cd /var/www
git clone git@github.com:USERNAME/REPO_NAME.git
cd REPO_NAME
npm install
npm run build

#Private key
cat ~/.ssh/id_ed25519
```

#### GitHub Action Workflow

```bash
.github/workflows/deploy-next.yml

name: Deploy Next.js to VPS

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup SSH
        uses: webfactory/ssh-agent@v0.9.0
        with:
          ssh-private-key: ${{ secrets.SSH_PRIVATE_KEY }}

      - name: Deploy on VPS
        run: |
          ssh -o StrictHostKeyChecking=no -p ${{ secrets.SSH_PORT }} \
          ${{ secrets.SSH_USER }}@${{ secrets.SSH_HOST }} << 'EOF'

            cd /var/www/REPO_NAME

            echo "Pulling latest code..."
            git pull origin main

            echo "Installing dependencies..."
            npm install

            echo "Building Next.js..."
            npm run build

            echo "Reloading PM2..."
            pm2 reload next-app

          EOF
```
