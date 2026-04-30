#!/usr/bin/env bash
set -u

URL="http://localhost:7860"

echo "[healthcheck] Test de ${URL} ..."
# CloudCLI n'a pas d'endpoint /health dedie ; on teste juste que le port repond HTTP 200
STATUS=$(curl -s -o /dev/null -w "%{http_code}" "${URL}/" 2>/dev/null || echo "000")
if [ "${STATUS}" = "200" ] || [ "${STATUS}" = "304" ]; then
  echo "[healthcheck] OK — l'UI repond sur ${URL} (HTTP ${STATUS})"
  exit 0
else
  echo "[healthcheck] ERREUR — l'UI ne repond pas sur ${URL} (HTTP ${STATUS})"
  exit 1
fi
