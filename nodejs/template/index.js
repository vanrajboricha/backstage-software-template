const express = require('express');
const path    = require('path');
const os      = require('os');
{% if values.enable_prometheus %}
const promClient = require('prom-client');
{% endif %}

const app  = express();
const PORT = process.env.PORT || {{ values.port }};

{% if values.enable_prometheus %}
// ── Prometheus Setup ───────────────────────────────────────────
const register = new promClient.Registry();

promClient.collectDefaultMetrics({ register });

const httpRequestCounter = new promClient.Counter({
  name:       'http_requests_total',
  help:       'Total HTTP requests',
  labelNames: ['method', 'route', 'status_code'],
  registers:  [register],
});

const httpRequestDuration = new promClient.Histogram({
  name:       'http_request_duration_seconds',
  help:       'HTTP request duration in seconds',
  labelNames: ['method', 'route', 'status_code'],
  buckets:    [0.01, 0.05, 0.1, 0.3, 0.5, 1, 2, 5],
  registers:  [register],
});

const activeConnections = new promClient.Gauge({
  name:      'active_connections',
  help:      'Number of active connections',
  registers: [register],
});

// ── Request tracking middleware ────────────────────────────────
app.use((req, res, next) => {
  const end = httpRequestDuration.startTimer();
  activeConnections.inc();
  res.on('finish', () => {
    httpRequestCounter.inc({
      method:      req.method,
      route:       req.path,
      status_code: res.statusCode,
    });
    end({
      method:      req.method,
      route:       req.path,
      status_code: res.statusCode,
    });
    activeConnections.dec();
  });
  next();
});
{% endif %}

app.use(express.json());
app.use(express.static(path.join(__dirname, 'views')));

// ── Routes ─────────────────────────────────────────────────────
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'views', 'index.html'));
});

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

app.get('/api/info', (req, res) => {
  res.json({
    app:         '{{ values.app_name }}',
    description: '{{ values.description }}',
    version:     '1.0.0',
    hostname:    os.hostname(),
    uptime:      `${Math.floor(process.uptime())}s`,
    memory:      `${Math.round(process.memoryUsage().rss / 1024 / 1024)} MB`,
    node:        process.version,
    port:        PORT,
    monitoring:  {{ values.enable_prometheus }},
    timestamp:   new Date().toISOString(),
  });
});

app.get('/api/routes', (req, res) => {
  const routes = [
    { method: 'GET', path: '/',           description: 'UI Dashboard' },
    { method: 'GET', path: '/health',     description: 'Health check' },
    { method: 'GET', path: '/api/info',   description: 'App info' },
    { method: 'GET', path: '/api/routes', description: 'List all routes' },
{% if values.enable_prometheus %}
    { method: 'GET', path: '{{ values.prometheus_metrics_path }}', description: 'Prometheus metrics' },
{% endif %}
  ];
  res.json({ routes });
});

{% if values.enable_prometheus %}
// ── Prometheus metrics endpoint ────────────────────────────────
app.get('{{ values.prometheus_metrics_path }}', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});
{% endif %}

app.listen(PORT, () => {
  console.log(`✅ {{ values.app_name }} running at http://localhost:${PORT}`);
  console.log(`   → UI:     http://localhost:${PORT}/`);
  console.log(`   → Health: http://localhost:${PORT}/health`);
{% if values.enable_prometheus %}
  console.log(`   → Metrics: http://localhost:${PORT}{{ values.prometheus_metrics_path }}`);
{% endif %}
});