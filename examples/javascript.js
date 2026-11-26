// Compare Nike vs Adidas Google ads in the US, UK, Germany and France.
import { ApifyClient } from 'apify-client';

const client = new ApifyClient({ token: 'YOUR_APIFY_TOKEN' }); // https://console.apify.com/settings/integrations

const run = await client.actor('xsi/google-ads-transparency').call(
  {
    mode: 'search',
    queries: ['nike.com', 'adidas.com'],
    regions: ['US', 'GB', 'DE', 'FR'],
    includeDetails: true,
    includeAdText: true,
    maxAdsPerQuery: 2,
    maxItems: 16,
  },
  { timeout: 480, memory: 256, maxTotalChargeUsd: 0.08 },
);

const { items } = await client.dataset(run.defaultDatasetId).listItems();
for (const ad of items) {
  const region = ad.selectedRegion || {};
  console.log(
    ad.query,
    ad.region,
    ad.advertiserName,
    ad.format,
    ad.headline,
    `impressions ${region.impressionsMin}-${region.impressionsMax}`,
    ad.transparencyUrl,
  );
}
