Here is a clean, comprehensive, and professional `docs/index.md` file tailored specifically for your Backstage template setup.

Since this file is part of a Scaffolder skeleton template, it uses the identical Nunjucks syntax (`{{ values.app_name }}`) as your code. When a developer runs the template, Backstage will automatically replace these placeholders with the actual values they typed into the UI form, leaving them with a perfectly customized documentation homepage!

---

### `docs/index.md`

```markdown
# 🚀 {{ values.app_name }} Documentation

Welcome to the official developer documentation for **{{ values.app_name }}**. This is a high-performance NodeJS service scaffolded directly via Backstage.

> **Description:** {{ values.description }}  
> **Default Port:** `{{ values.port }}`  
> **Monitoring Enabled:** `{{ values.enable_prometheus }}`

---

## 🛠️ Getting Started

### Prerequisites
Before running this application locally, ensure you have the following installed:
* **Node.js** (v18 or higher recommended)
* **npm** or **yarn**

### Local Setup
1. Clone your generated repository and navigate to the project directory:
   ```bash
   cd {{ values.app_name }}

```

2. Install the application dependencies:
```bash
npm install

```


3. Spin up the application server in development mode:
```bash
PORT={{ values.port }} npm start

```



The application will initialize and run locally at `http://localhost:{{ values.port }}`.

---

## 🛣️ API Directory & Endpoints

This application exposes standard health, information, and static UI routes. Below is the full directory mapping available out of the box:

| Method | Endpoint | Description | Expected Output |
| --- | --- | --- | --- |
| **GET** | `/` | Serves the main UI HTML dashboard | HTML Page View |
| **GET** | `/health` | Core system readiness probe endpoint | `{ "status": "ok" }` |
| **GET** | `/api/info` | Dynamic runtime data (Uptime, RAM usage, etc.) | JSON Object Metadata |
| **GET** | `/api/routes` | System-wide registered routing directory | JSON list of active routes |
| {% if values.enable_prometheus -%} |  |  |  |
| **GET** | `{{ values.prometheus_metrics_path }}` | Raw Prometheus infrastructure scraping metrics | OpenMetrics Text Format |
| {%- endif %} |  |  |  |

---

{% if values.enable_prometheus -%}

## 📊 Telemetry & Observability

This application has native **Prometheus instrumentation** pre-configured. It tracks HTTP layer lifecycle data using the `prom-client` engine.

### Tracked Metrics

The application exposes three primary telemetry points at the `{{ values.prometheus_metrics_path }}` endpoint:

* **`http_requests_total` (Counter):** Tracks total incoming HTTP requests broken down by HTTP method, path, and HTTP response status code.
* **`http_request_duration_seconds` (Histogram):** Measures execution duration buckets for incoming transactions to compute latency percentiles ($p95$, $p99$).
* **`active_connections` (Gauge):** Monitors a real-time floating count of open concurrent requests processing inside the event loop.

### Backstage Integration

To view these metrics inside your Backstage Catalog dashboard instead of digging through raw text logs, ensure your application's `catalog-info.yaml` includes the Prometheus annotation rules linked directly to your telemetry scraper.
{%- else -%}

## 📊 Telemetry & Observability

Observability and Prometheus telemetry tracking are currently disabled for this instance configuration block. If you require metrics tracking down the line, add the `prom-client` package and toggle telemetry parameters inside your runtime variables block.
{%- endif %}

---

## 🏗️ Architecture Information

The service relies on a minimalist asynchronous layout map:

* **Framework:** ExpressJS (Web API routing framework)
* **Static Assets:** Static web interface elements are stored inside the `/views` directory.
* **Deployment Context:** Container-ready footprint, passing system configuration properties via environmental variable keys (`PORT`).

```

```