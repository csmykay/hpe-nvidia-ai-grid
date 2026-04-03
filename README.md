# HPE / NVIDIA AI Grid — US Reference Architecture

Interactive near/far edge inferencing reference architecture diagram deployed as a GitHub Pages site.

## Live Demo

Once deployed: `https://<your-github-username>.github.io/<repo-name>/`

---

## Deploy in 5 Steps

### 1. Create a new GitHub repository

Go to [github.com/new](https://github.com/new) and create a new **public** repository.  
Name suggestion: `hpe-nvidia-ai-grid`

> **Note:** GitHub Pages requires a public repo on free accounts. Private repos require GitHub Pro or higher.

### 2. Push these files

```bash
# Unzip this archive, then from inside the folder:
git init
git add .
git commit -m "Initial deploy — HPE/NVIDIA AI Grid reference architecture"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
git push -u origin main
```

### 3. Enable GitHub Pages

1. Go to your repository on GitHub
2. Click **Settings** → **Pages** (left sidebar)
3. Under **Source**, select:
   - Branch: `main`
   - Folder: `/ (root)`
4. Click **Save**

### 4. Wait ~60 seconds

GitHub will build and publish the site. A green banner will appear at the top of the Pages settings with your URL:

```
Your site is live at https://YOUR_USERNAME.github.io/YOUR_REPO_NAME/
```

### 5. Open the URL

The diagram is live. Share the URL — no login required for public repos.

---

## Custom Domain (Optional)

To serve from `yourdomain.com` instead of `github.io`:

1. In your DNS provider, add a `CNAME` record:
   ```
   www  →  YOUR_USERNAME.github.io
   ```
2. In GitHub Pages settings, enter your custom domain under **Custom domain**
3. Check **Enforce HTTPS** (GitHub provisions the TLS certificate automatically via Let's Encrypt)

For an apex domain (`yourdomain.com` without `www`), add four `A` records pointing to GitHub's IPs:
```
185.199.108.153
185.199.109.153
185.199.110.153
185.199.111.153
```

---

## CDN Dependencies

The diagram loads these libraries from public CDNs at runtime — no installation needed:

| Library | CDN | Size |
|---|---|---|
| D3.js v7.8.5 | cdnjs.cloudflare.com | ~530 KB |
| topojson-client v3 | unpkg.com | ~30 KB |
| US Atlas (states-10m.json) | cdn.jsdelivr.net | ~500 KB |

These are all free, globally distributed CDNs with high availability. The page renders fully in modern Chrome, Firefox, Safari, and Edge.

---

## Self-Hosting Assets (Optional)

If you prefer zero external CDN dependencies, run this once on your local machine and commit the `assets/` folder alongside `index.html`:

```bash
mkdir -p assets

curl -fL "https://cdnjs.cloudflare.com/ajax/libs/d3/7.8.5/d3.min.js" \
     -o assets/d3.min.js

curl -fL "https://unpkg.com/topojson-client@3/dist/topojson-client.min.js" \
     -o assets/topojson-client.min.js

curl -fL "https://cdn.jsdelivr.net/npm/us-atlas@3/states-10m.json" \
     -o assets/states-10m.json

# Patch index.html to use local paths
sed -i \
    -e 's|https://cdnjs.cloudflare.com/ajax/libs/d3/7.8.5/d3.min.js|assets/d3.min.js|g' \
    -e 's|https://unpkg.com/topojson-client@3/dist/topojson-client.min.js|assets/topojson-client.min.js|g' \
    -e "s|'https://cdn.jsdelivr.net/npm/us-atlas@3/states-10m.json'|'assets/states-10m.json'|g" \
    index.html

git add assets/ index.html
git commit -m "Self-host CDN assets"
git push
```

---

## Updating the Diagram

Edit `index.html` locally, then push:

```bash
git add index.html
git commit -m "Update diagram — <describe change>"
git push
```

GitHub Pages re-deploys automatically within ~30 seconds of each push.

---

## Repository Structure

```
.
├── index.html      ← the interactive diagram (single file)
├── .nojekyll       ← tells GitHub Pages to skip Jekyll processing
└── README.md       ← this file
```

---

## Troubleshooting

| Issue | Fix |
|---|---|
| 404 after enabling Pages | Wait 60–90 seconds and hard-refresh (`Ctrl+Shift+R`) |
| Map renders grey, no US states | CDN for US Atlas blocked by network; try self-hosting assets |
| Site shows Jekyll error | Ensure `.nojekyll` file is present at the repo root |
| Custom domain shows "not secure" | Enable **Enforce HTTPS** in Pages settings; may take up to 24h for cert provisioning |
| Changes not showing | GitHub Pages caches aggressively — wait 60s and hard-refresh |
