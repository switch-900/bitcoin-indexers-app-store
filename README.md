# Bitcoin Indexers - Umbrel Community App Store

This is the official Umbrel Community App Store for Bitcoin indexing applications.

## Apps Available

### BRC-420 Indexer
A comprehensive Bitcoin inscription indexer that supports BRC-420 tokens and Bitcoin bitmaps. 

**Features:**
- 📊 Real-time Bitcoin inscription indexing
- 🔍 BRC-420 token deployment tracking
- 📈 Bitmap inscription analytics
- 🔗 Local-only operation (connects to your Umbrel's Bitcoin Core and Ordinals)
- ⚡ Fast SQLite database with optimized indexing
- 🌐 Beautiful web interface for browsing and searching

**Requirements:**
- Bitcoin Core app (for blockchain data)
- Ordinals app (for inscription data)

## Installation

1. Add this community app store to your Umbrel
2. Install the required dependencies (Bitcoin Core and Ordinals)
3. Install the BRC-420 Indexer app
4. Access the web interface at `http://umbrel.local:8080`

## Repository Structure

```
├── umbrel-app-store.yml          # App store metadata
└── bitcoin-indexers-brc420/      # BRC-420 Indexer app
    ├── umbrel-app.yml            # App configuration
    ├── docker-compose.yml        # Docker services
    └── README.md                 # App documentation
```

## Support

For issues or questions about this app store:
- GitHub Issues: [Report a bug](https://github.com/switch-900/bitcoin-indexers-app-store/issues)
- Docker Image: `ghcr.io/switch-900/bitmap-Bitmap-BRC-420-indexer:latest`
- Source Code: [Bitmap BRC-420 Indexer](https://github.com/switch-900/Bitmap-Bitmap-BRC-420-indexer)

---

**Privacy First**: All indexing happens locally on your Umbrel. Your Bitcoin data never leaves your device.
