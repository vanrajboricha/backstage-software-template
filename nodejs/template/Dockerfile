# ── Selected by user in Backstage UI ──────────────────────────────
FROM node:${{ values.node_version }}

WORKDIR /app

COPY package*.json ./

{% if values.enable_prometheus %}
RUN npm install --production && npm install prom-client
{% else %}
RUN npm install --production
{% endif %}

COPY . .

EXPOSE ${{ values.port }}

HEALTHCHECK --interval=15s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:${{ values.port }}/health || exit 1

CMD ["node", "index.js"]