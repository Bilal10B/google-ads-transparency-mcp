"""Compare Nike vs Adidas Google ads in the US, UK, Germany and France."""
from apify_client import ApifyClient

client = ApifyClient("YOUR_APIFY_TOKEN")  # https://console.apify.com/settings/integrations

run = client.actor("xsi/google-ads-transparency").call(
    run_input={
        "mode": "search",
        "queries": ["nike.com", "adidas.com"],
        "regions": ["US", "GB", "DE", "FR"],
        "includeDetails": True,
        "includeAdText": True,
        "maxAdsPerQuery": 2,
        "maxItems": 16,
    },
    timeout_secs=480,
    memory_mbytes=256,
    max_total_charge_usd=0.08,
)

for ad in client.dataset(run["defaultDatasetId"]).iterate_items():
    region = ad.get("selectedRegion") or {}
    print(
        ad.get("query"),
        ad.get("region"),
        ad.get("advertiserName"),
        ad.get("format"),
        ad.get("headline"),
        f"impressions {region.get('impressionsMin')}-{region.get('impressionsMax')}",
        ad.get("transparencyUrl"),
    )
