FROM node:18-slim AS dependencies

WORKDIR /usr/local/app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev && npm cache clean --force

FROM node:18-slim AS final

WORKDIR /usr/local/app
RUN apt-get update && \
    apt-get install -y --no-install-recommends tini && \
    rm -rf /var/lib/apt/lists/*
COPY --from=dependencies /usr/local/app/node_modules ./node_modules
COPY package.json package-lock.json ./
COPY server.js ./
COPY views ./views
ENV PORT=80
EXPOSE 80
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["node", "server.js"]
