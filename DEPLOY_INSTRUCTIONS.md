# 🎯 Create GitHub Repository and Deploy App Store

## Step 1: Create GitHub Repository
**In the GitHub web interface:**
1. Repository name: `bitcoin-indexers-app-store`
2. Description: `Umbrel community app store for Bitcoin indexing applications`
3. Make it **Public** (required for Umbrel community stores)
4. **Don't** initialize with README, .gitignore, or license (we already have files)
5. Click "Create repository"

## Step 2: Push to GitHub
**After creating the repository, run these commands:**

```powershell
# Add the GitHub remote
git remote add origin https://github.com/switch-900/bitcoin-indexers-app-store.git

# Push the app store to GitHub
git branch -M main
git push -u origin main
```

## Step 3: Update Umbrel to Use New App Store
**SSH into Umbrel and run:**

```bash
# Remove old app store
sudo rm -rf ~/umbrel/app-stores/switch-900-brc-420-indexer-github-*

# Add new app store via Umbrel web interface
# Go to: Settings → App Stores → Add Community App Store
# URL: https://github.com/switch-900/bitcoin-indexers-app-store.git
```

## Step 4: Install the App
1. Go to **App Store** → **Community App Stores**
2. Find "Bitcoin Indexers" 
3. Install "BRC-420 Indexer"
4. Access at: http://umbrel.local:8080

---
**Next: Create the repository in GitHub, then run the PowerShell commands above!**
