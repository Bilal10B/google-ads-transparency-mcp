# n8n Creator Portal form fields — Radar variant (Slack + Notion)

File to upload: `workflows/n8n-google-ads-radar-slack-notion.gallery.json`
Status: **prepared, not submitted.** Submit manually on creators.n8n.io (the Slack digest, submission 23669, is still under review).

Local test (n8n 2.49.7, 26 Nov 2026, 15:35–15:38 Europe/Brussels), Slack/Notion nodes removed, real Apify runs on build 2.1.8:
- Run 1 (baseline): search cWXLzhgdZbewjlKMl + monitor 6NQE5AxNgfBdBJATq → 5 ads, 5 winning, 1 summary line, "no_ads_found" for the fake domain. 29 s end to end.
- Run 2 (after adding one fake ad to the monitor state): gRHfWRK7GplVi4UMp + sbrihhXx0vkK2U7Nk → "Stopped ads since last check: 1", 0 false positives. 24 s.
- Run 3: uHPDHXWvzgm9oYjdp (Slack digest patch test) + wnhfVJuGyWCLTVbYv + wWhcfPhXcLycI9fJU → stopped ad not repeated.
- Would-be charges per weekly run with these settings (chargedEventCounts): 5 ad + 2 ad-text + 2 monitor-check = $0.009 on the FREE price grid. Owner runs are not billed; platform cost of all 7 runs: $0.0067.

Word/character counts: Title 77 characters (limit 80), Quick overview 45 words (10–50), How it works 119 words (min 50), Setup 105 words (min 50).

======= FIELD: Title =======
Competitor Google Ads radar: winning, new and stopped ads to Slack and Notion
======= END Title =======

======= FIELD: Quick overview =======
Every Monday, this workflow checks your competitors' public Google ads and sends one digest to Slack and a Notion page: a summary per competitor, winning ads, new launches, ads that started or stopped since last week, and promo codes or discounts written in the ads.
======= END Quick overview =======

======= FIELD: How it works =======
1. Every Monday at 08:00, or when you click Test once, the workflow reads the competitor websites, country, winning-ad threshold, ad cap, Slack channel and Notion page from the Configure radar node.
2. Get current ads runs the xsi/google-ads-transparency Actor on Apify and returns flat rows from the official Ads Transparency Center, plus one free summary row per competitor.
3. Check new and stopped ads runs the same Actor in monitor mode. It compares with the previous week and returns new ads and stopped ads. The first run only stores a baseline.
4. One Code node builds the digest, also when a request fails or returns nothing, then posts it to Slack and saves it as a Notion page.
======= END How it works =======

======= FIELD: Setup =======
1. Create an HTTP Header Auth credential: header name Authorization, value Bearer followed by a space and your Apify API token. Select it in Get current ads and in Check new and stopped ads.
2. Select a Slack credential with the chat:write scope and invite the bot to the channel.
3. Select a Notion credential and share the parent page with that integration. Copy the page ID from its URL.
4. In Configure radar, set competitorDomains (about 3 per workflow), region, slackChannel and notionParentPageId. Keep monitorKey unique per workflow.
5. Click Test once, check the Slack message and the Notion page, then activate the workflow.
======= END Setup =======

======= FIELD: Requirements =======
An n8n instance (Cloud or self-hosted, built-in nodes only), an Apify account and API token, a Slack workspace and a Notion workspace. The Actor is pay-per-result on your Apify account: about $0.001 per ad on the free plan, OCR off (no OCR charge), $0.001 per competitor checked by the monitor, $0.005 per new-ad alert (capped by maxNewAdAlerts). Stopped-ad alerts, summary rows and websites with no ads are free. Apify's free plan includes monthly credit.
======= END Requirements =======

======= FIELD: Customization =======
Change the schedule, the winning-ad threshold (daysThreshold) or the ad cap. Remove the Slack or Notion node if you only need one. Apify synchronous runs stop after 300 seconds, so split large competitor lists across several copies of the workflow, each with its own monitorKey.
======= END Customization =======

======= FIELD: Additional info =======
Public Ads Transparency Center data only, not access to anyone's Google Ads account. "Winning" means still running after the threshold, not a performance metric: Google does not publish clicks or spend. Impression ranges are published only for EU/EEA countries and are not requested here. The first test starts real Apify runs and is chargeable once your free credit is used.
======= END Additional info =======

## Sticky notes in the JSON
Overview (what it does + 3-minute setup), 1. Schedule and settings, 2. Two Apify runs, 3. Build and send, Warning: paid Apify runs (costs and 300-s limit).
