const express = require('express');
const path = require('path');
const os = require('os');

const app = express();
const PORT = process.env.PORT || ${{ values.port }};

app.use(express.json());
app.use(express.static(path.join(__dirname, 'views')));

// ── UI route ───────────────────────────────────────────────────────
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'views', 'index.html'));
});

// ── Health check ───────────────────────────────────────────────────
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

// ── Info API endpoint ──────────────────────────────────────────────
app.get('/api/info', (req, res) => {
  res.json({
    app: '${{ values.app_name }}',
    description: '${{ values.description }}',
    version: '1.0.0',
    hostname: os.hostname(),
    uptime: `${Math.floor(process.uptime())}s`,
    memory: `${Math.round(process.memoryUsage().rss / 1024 / 1024)} MB`,
    node: process.version,
    port: PORT,
    timestamp: new Date().toISOString()
  });
});

// ── List all routes ────────────────────────────────────────────────
app.get('/api/routes', (req, res) => {
  res.json({
    routes: [
      { method: 'GET', path: '/',           description: 'UI Dashboard' },
      { method: 'GET', path: '/health',     description: 'Health check' },
      { method: 'GET', path: '/api/info',   description: 'App info' },
      { method: 'GET', path: '/api/routes', description: 'List all routes' }
    ]
  });
});

app.listen(PORT, () => {
  console.log(`✅ ${{ values.app_name }} running at http://localhost:${PORT}`);
  console.log(`   → UI:     http://localhost:${PORT}/`);
  console.log(`   → Health: http://localhost:${PORT}/health`);
  console.log(`   → Info:   http://localhost:${PORT}/api/info`);
});