#!/usr/bin/env bash
set -u

URL="http://localhost:7860"

echo "[healthcheck] Test de ${URL} ..."
if curl -fsS "${URL}/health" > /dev/null 2>&1; then
  echo "[healthcheck] OK — l'UI repond sur ${URL}"
  exit 0
else
  echo "[healthcheck] ERREUR — l'UI ne repond pas sur ${URL}"
  exit 1
fi
