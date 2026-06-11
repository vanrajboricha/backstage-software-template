# ── Selected by user in Backstage UI ──────────────────────────────
FROM node:${{ values.node_version }}

WORKDIR /app

COPY package*.json ./
RUN npm install --production

COPY . .

EXPOSE ${{ values.port }}

HEALTHCHECK --interval=15s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:${{ values.port }}/health || exit 1

CMD ["node", "index.js"]