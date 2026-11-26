# How to track any competitor's Google Ads (and get EU impression data) with an API / MCP

You do not need access to a rival's Google Ads account to see what they are running. Google already publishes a public library — the [Ads Transparency Center](https://adstransparency.google.com/) — covering Search, YouTube, Shopping, Maps and Google Play, in every country Google supports.

This article shows how to pull that data through an API, or let an AI agent do it over MCP, using the public [Google Ads Transparency Actor](https://apify.com/xsi/google-ads-transparency) on Apify. The walkthrough is a **real run** from 26 November 2026, comparing **Nike vs Adidas** in the **United States, United Kingdom, Germany and France**. EU impression ranges appear only at the end, as a bonus that exists in the EU and EEA and not in the US or the UK.

It is written for marketers, agencies, e-commerce teams, and people building ad-intelligence tools or AI agents.

## What I actually ran

On 26 November 2026 at 10:48 (Europe/Brussels, 09:48 UTC) I started Apify Actor run [`biPCUmNEKOhNQP5oO`](https://console.apify.com/view/runs/biPCUmNEKOhNQP5oO) with this input:

```json
{
  "mode": "search",
  "queries": ["nike.com", "adidas.com"],
  "regions": ["US", "GB", "DE", "FR"],
  "includeDetails": true,
  "includeAdText": true,
  "maxAdsPerQuery": 2,
  "maxItems": 16
}
```

That is two ads per brand and country — 16 ads, not a full dump. The point was to measure volume, then look closely at a small, real sample of creatives and copy.

The run finished in **46.8 seconds**. It billed 16 “ad-detail” events and 13 “ad-copy” events, which at the Actor's list prices is **$0.045**. There is no start fee. I also set a hard cap of $0.08 so the run could not exceed that. Apify recorded $0.0021 of platform usage (compute and proxy) for the run; those costs are included in the event prices for paying users.

Google refused a few requests along the way (2 rate limits and 1 CAPTCHA page out of 39 HTTP requests, a 5.1% refusal rate). The Actor retried and rotated the proxy session. It does not solve CAPTCHA pages. All 16 items came back, with 0 errors.

A free Apify account includes $5 of monthly credit, which is enough to repeat this kind of check many times.

## First, the volumes

Before looking at any headline, Google already tells you how many ads it holds for each domain in each country. These figures are Google's own ranges for the **global domains** `nike.com` and `adidas.com`. A brand may also advertise under a country site (for example `adidas.co.uk`); that would be a separate query, and I did not run one here.

| Domain | United States | United Kingdom | Germany | France |
|---|---|---|---|---|
| nike.com | 8,000–9,000 ads | 2,000–3,000 | 9,000–10,000 | 8,000–9,000 |
| adidas.com | 4,000–5,000 ads | 68 | 600–700 | 600–700 |

In this snapshot, Nike's global domain had a much larger Transparency Center footprint than Adidas's in every market I queried. The gap is especially large in the UK (thousands of Nike ads vs 68 Adidas ads on `adidas.com`). That is not the same thing as ad spend, and it is not a ranking of creative quality. It is a hard, official count of ads Google has on file for those domains.

The legal entities behind the sample were also consistent: **Nike, Inc.** in the US, **Nike Retail BV** in the UK, Germany and France, and **Adidas America, Inc.** in all four countries.

## What the ads were saying on 26 November 2026

The 16 returned ads are a sample of two per cell, not “the top ads.” Still, the copy is specific enough to be useful.

**Nike was in a Black Friday push.** A US text ad first shown on 22 November 2026 (05:02 UTC) and still serving on 26 November promoted the Nike Golf collection: “Save big this Black Friday using code BFRIDAY for an extra 25% off select styles.” Official page: [US creative CR09898538327395532801](https://adstransparency.google.com/advertiser/AR16735076323512287233/creative/CR09898538327395532801?region=US).

A UK text ad from Nike Retail BV used a broader Black Friday line: “Nike Black Friday Days Are On” / “Up To 40% Off Selected Styles. Ends On December 1st.” Google first recorded that creative on 19 September 2025, and it was still serving on 26 November 2026. Official page: [GB creative CR00669994402592063489](https://adstransparency.google.com/advertiser/AR18378488041124659201/creative/CR00669994402592063489?region=GB).

In France, a text ad promoted **NikeSKIMS** pilates wear (“Introducing An Updated Take On Pilates Wear From NikeSKIMS.”), first shown on 20 February 2026. Official page: [FR creative CR13374024866886320129](https://adstransparency.google.com/advertiser/AR18378488041124659201/creative/CR13374024866886320129?region=FR).

**Adidas's sample was more evergreen.** In the US, one of the two ads was a YouTube video (`WVLa-eUBGjE`, first shown 11 November 2026). Official page: [US creative CR03714073080885149697](https://adstransparency.google.com/advertiser/AR14017378248766259201/creative/CR03714073080885149697?region=US). The other US ad, also running in Germany and France under the same creative ID, sold the Terrex Freehiker 3: “Not a hiker? You Are Now.” Official page: [US creative CR02127259033550192641](https://adstransparency.google.com/advertiser/AR14017378248766259201/creative/CR02127259033550192641?region=US).

In the UK, Adidas copy included “Shop The adidas Official Site Today. Free Shipping For Members On All Orders.” and “Shop The Three Stripes.” In Germany and France the sample also included socks, kids' shoes and clothing, and the same Freehiker ad.

Two practical lessons from a 16-ad sample:

1. **The same creative can appear in several countries.** The Freehiker ad showed up in the US, Germany and France in this run. You can de-duplicate by `creativeId`.
2. **The language of the copy is not always the language of the country you queried.** A Nike ad sampled in Germany had Polish copy (“Oficjalna strona Nike” / Black Friday discounts up to 40% until 1 December). It was also shown in Poland, among other countries. Official page: [DE creative CR07648843056275259393](https://adstransparency.google.com/advertiser/AR18378488041124659201/creative/CR07648843056275259393?region=DE).

## The EU bonus: official impression ranges

Google does **not** publish impression counts for the United States or the United Kingdom. If you only work in those markets, you still get advertiser names, formats, first/last shown dates, countries, copy and official ad URLs.

In the EU and EEA, the Digital Services Act requires a public repository of ads with more detail. For those countries the Actor adds, when Google has published them:

- an official **impression range** for the country you asked for
- a **breakdown by platform** (Search, YouTube, Shopping, Maps, Play)
- an **EU-wide total** for the same creative
- **audience-selection criteria**: whether demographics, locations, contextual signals, customer lists and topics of interest were included, excluded, or not used

Google typically publishes the ranges only after about 90 days, and they are ranges, not exact counts. If an upper bound is missing, the Actor stores `impressionsMax` as `null`.

That bonus is where this run gets striking.

A long-running Nike Shopping image ad in France — mid-calf Everyday Cushioned training socks, 6-pack, black, size 42–46, first recorded on 25 October 2021 — had an official floor of **10,000,000 impressions in France**, with no upper bound published (`impressionsMax` is null). The platform split was Search at the same 10,000,000 floor, Shopping 450,000–500,000, and YouTube 15,000–20,000. Official page: [FR creative CR18139369585210556417](https://adstransparency.google.com/advertiser/AR18378488041124659201/creative/CR18139369585210556417?region=FR).

The Polish-language Nike ad sampled in Germany had only **0–1,000 impressions in Germany**, but **250,000–300,000 across the EU**. A small country number is not the same as a small campaign.

Even a UK query can carry an EU total when the same creative also ran in the EU. The Nike UK Black Friday ad above has no UK impression range, but Google reports 2,000–3,000 EU impressions for that creative, because it also ran in countries such as France, Germany, Spain and Italy.

## How to reproduce this

### Python

```python
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
    print(ad["query"], ad["region"], ad.get("headline"), ad.get("selectedRegion"))
```

JavaScript and cURL versions are in the [examples folder](https://github.com/Bilal10B/google-ads-transparency-mcp/tree/main/examples). Swap the domains and country codes for any other competitor: `shopify.com`, `apple.com`, a client's rival, whatever you need.

### MCP, for AI agents

The same product is a remote MCP server (Streamable HTTP):

```json
{
  "mcpServers": {
    "google-ads-transparency": {
      "url": "https://xsi--google-ads-transparency.apify.actor/mcp",
      "headers": {
        "Authorization": "Bearer YOUR_APIFY_TOKEN"
      }
    }
  }
}
```

Tools:

- `find_advertiser` — name or website → advertiser IDs
- `list_ads` — ads for a domain or advertiser, filtered by country, format, platform and dates
- `get_ad_details` — one ad, including EU impressions and targeting when they exist
- `new_ads_since` — ads first shown on or after a date, for a daily or weekly watch

An agent can then be asked, for example: “What new ads has Nike run in the US and Germany since 1 November?” or “Compare adidas.com ad volume in the UK and France.”

## Pricing (list prices)

You only pay for results. Compute and proxy are included. No start fee.

| Event | Price |
|---|---|
| Ad | $0.001 |
| Ad with EU details (replaces the ad price) | $0.002 |
| Ad copy, only when it is found | $0.001 |
| MCP tool call | $0.005, plus the events above |

A run never exceeds *Max ads per query*, *Max items*, or *Max cost per run*. Empty or failed results are not billed.

## Disclaimer

This is public data from Google's Ads Transparency Center. It is not access to anyone's private ads account. Impression figures are official ranges published by Google under the EU DSA; they are usually available only after about 90 days, they are ranges rather than exact counts, and they are not published for non-EU countries. Always open the official `transparencyUrl` if you need to verify a record.

Nike, Adidas and other brand names are used here only as examples of public transparency data.

## Links

- [Google Ads Transparency Actor on the Apify Store](https://apify.com/xsi/google-ads-transparency)
- [MCP endpoint](https://xsi--google-ads-transparency.apify.actor/mcp)
- [Sample output from this run](../examples/sample-output.json)
- [Google Ads Transparency Center](https://adstransparency.google.com/)
