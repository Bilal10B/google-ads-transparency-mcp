#!/usr/bin/env bash
# Compare Nike vs Adidas Google ads in the US, UK, Germany and France.
# Put your token in APIFY_TOKEN (https://console.apify.com/settings/integrations). Never put it in the URL.
set -euo pipefail

: "${APIFY_TOKEN:?Set APIFY_TOKEN first}"

START=$(curl -sS -X POST \
  "https://api.apify.com/v2/acts/xsi~google-ads-transparency/runs?timeout=480&memory=256&maxTotalChargeUsd=0.08" \
  -H "Authorization: Bearer ${APIFY_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "mode": "search",
    "queries": ["nike.com", "adidas.com"],
    "regions": ["US", "GB", "DE", "FR"],
    "includeDetails": true,
    "includeAdText": true,
    "maxAdsPerQuery": 2,
    "maxItems": 16
  }')

RUN_ID=$(python3 -c 'import json,sys; print(json.load(sys.stdin)["data"]["id"])' <<<"$START")
echo "Run: https://console.apify.com/view/runs/${RUN_ID}"

while true; do
  STATUS=$(curl -sS "https://api.apify.com/v2/actor-runs/${RUN_ID}" \
    -H "Authorization: Bearer ${APIFY_TOKEN}")
  STATE=$(python3 -c 'import json,sys; print(json.load(sys.stdin)["data"]["status"])' <<<"$STATUS")
  echo "status: ${STATE}"
  case "${STATE}" in
    SUCCEEDED|FAILED|ABORTED|TIMED-OUT) break ;;
  esac
  sleep 3
done

DATASET=$(python3 -c 'import json,sys; print(json.load(sys.stdin)["data"]["defaultDatasetId"])' <<<"$STATUS")
curl -sS "https://api.apify.com/v2/datasets/${DATASET}/items?clean=true" \
  -H "Authorization: Bearer ${APIFY_TOKEN}"
