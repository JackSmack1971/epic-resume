# Epic Resume - Single Optimized Setup for Codex
# Save this as setup-codex.sh and use as your setup script

# System essentials + Node.js + npm config + project setup
apt-get update -y && apt-get install -y curl wget git build-essential ca-certificates gnupg && \
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && apt-get install -y nodejs && \
npm config delete http-proxy https-proxy proxy 2>/dev/null || true && \
npm config set registry https://registry.npmjs.org/ && npm config set fund false && npm config set progress false && \
npm cache clean --force && npm install -g vite@latest serve@latest --silent && \
cd /workspace/epic-resume && \
echo '{"name":"epic-resume","version":"1.0.0","type":"module","main":"src/main.js","scripts":{"dev":"vite --host 0.0.0.0 --port 5173","build":"vite build","preview":"vite preview --host 0.0.0.0 --port 4173"},"dependencies":{"vite":"^5.4.11","vite-plugin-pwa":"^0.21.1"},"devDependencies":{"@babel/core":"^7.26.0","jest":"^29.7.0"},"overrides":{"glob":"^10.0.0","sourcemap-codec":"@jridgewell/sourcemap-codec"}}' > package.json && \
echo 'registry=https://registry.npmjs.org/\nfund=false\nupdate-notifier=false\nprogress=false\nloglevel=warn' > .npmrc && \
rm -rf node_modules package-lock.json 2>/dev/null || true && \
npm install --no-fund --no-audit --silent && npm audit fix --force --silent 2>/dev/null || true && \
echo 'node_modules/\ndist/\n.env\nnpm-debug.log*\npackage-lock.json' > .gitignore && \
apt-get autoremove -y && apt-get autoclean && rm -rf /var/lib/apt/lists/* && \
echo "✅ Epic Resume setup complete - ready for Codex!"
