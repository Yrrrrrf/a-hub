#!/usr/bin/env bash
echo "--- Tearing down existing DB container and volume ---"
podman stop a-hub-db-container 2>/dev/null || true
podman rm a-hub-db-container 2>/dev/null || true
podman volume rm a-hub-data 2>/dev/null || true

echo "--- Building new DB image ---"
podman build -f db.Dockerfile -t a-hub-db:latest .

echo "--- Starting new DB container ---"
podman run \
  --name a-hub-db-container \
  -p 5432:5432 \
  -v a-hub-data:/var/lib/postgresql/data \
  -e POSTGRES_PASSWORD=postgres \
  -e DB_NAME=a_hub \
  -e DB_OWNER_ADMIN=a_hub_admin \
  -e DB_OWNER_PWORD=password \
  a-hub-db:latest
