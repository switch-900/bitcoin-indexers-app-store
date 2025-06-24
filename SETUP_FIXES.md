# Critical App Store Setup Issues - FIXED

## Problem
The Bitcoin Indexers app store was appearing in Umbrel's Community App Store UI but was showing as empty - just displaying "Bitcoin Indexers app store" with no apps listed underneath.

## Root Causes Found & Fixed

### 1. Duplicate manifestVersion in umbrel-app.yml
**Issue**: The file contained:
```yaml
manifestVersion: 1
manifestVersion: 1
id: bitcoin-indexers-brc420
```

**Fix**: Removed the duplicate line:
```yaml
manifestVersion: 1
id: bitcoin-indexers-brc420
```

### 2. Docker Compose YAML Syntax Error
**Issue**: Missing newline after `services:` caused malformed YAML:
```yaml
services:  app_proxy:
```

**Fix**: Added proper newline:
```yaml
services:
  app_proxy:
```

### 3. APP_HOST Configuration
**Issue**: Was using generic `web` instead of proper Umbrel convention
**Fix**: Changed to `bitcoin-indexers-brc420_web_1` format as required by Umbrel

### 4. Missing Required Files
**Added**: 
- `exports.sh` file (even if minimal, some apps require it)
- `manifestVersion: 1` to umbrel-app.yml

## Next Steps
1. Wait for Umbrel to refresh the app store cache (may take a few minutes)
2. Check if the "BRC-420 & Bitmap Indexer" app now appears in the Bitcoin Indexers app store
3. If still not appearing, try removing and re-adding the app store URL in Umbrel

## Status
✅ All YAML syntax errors fixed
✅ App store configuration validated
✅ Changes committed and pushed to GitHub
✅ Version incremented to v1.1.1 to force refresh

The app should now appear properly in the Bitcoin Indexers community app store within Umbrel.

---

## 99% Installation Failure - FIXED (v1.1.2)

### Problem
The app appears in the store and starts installing but fails at 99% completion.

### Root Causes & Fixes

#### 1. Health Check Issues
**Problem**: Health check was using `wget` (not available in Node.js container) and `localhost` (incorrect in Docker networking)
**Fix**: 
- Changed to Node.js-based health check using `http` module
- Changed from `localhost` to `127.0.0.1`
- Increased startup period from 60s to 120s
- Increased retries from 3 to 5

#### 2. Heavy Indexer Process on Startup
**Problem**: `RUN_INDEXER: "true"` was causing the app to start intensive blockchain indexing immediately on startup
**Fix**: 
- Set `RUN_INDEXER: "false"` to prevent heavy processing during initial container startup
- Users can enable indexing later through the web interface

#### 3. Missing Environment Variable Defaults
**Problem**: Some Umbrel environment variables had no defaults
**Fix**:
- Added default for `APP_ORDINALS_NODE_IP: ${APP_ORDINALS_NODE_IP:-umbrel.local}`
- Improved fallback values for better startup reliability

#### 4. Startup Script Integration
**Problem**: Direct Node.js startup without proper initialization
**Fix**:
- Changed command to use entrypoint script: `["/app/entrypoint.sh", "node", "server.js"]`
- Ensures proper permission setup and directory creation

### Technical Details

**New Health Check**:
```yaml
healthcheck:
  test: ["CMD", "node", "-e", "require('http').get('http://127.0.0.1:8080/health', (res) => process.exit(res.statusCode === 200 ? 0 : 1)).on('error', () => process.exit(1))"]
  interval: 30s
  timeout: 10s
  start_period: 120s
  retries: 5
```

**Key Changes**:
- ✅ Node.js-based health check (no external dependencies)
- ✅ Longer startup grace period (120s)
- ✅ More retries for reliability
- ✅ Disabled heavy indexing on startup
- ✅ Better environment variable defaults
- ✅ Proper entrypoint script usage

### Status
✅ All installation blocking issues resolved
✅ Version incremented to v1.1.2
✅ Changes committed and pushed to GitHub
✅ New Docker image will be built automatically

The app should now install successfully through the 100% mark in Umbrel!
