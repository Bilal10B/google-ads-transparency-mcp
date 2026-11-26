# n8n Creator Portal form fields

Plain text to paste into each section of the creators.n8n.io submission form. Copy only the text between the markers. Do not include the marker lines.

This is not a single description field. The form uses the sections below.

Character/word checks (26 November 2026, Europe/Brussels):
- Title: 65 characters (limit 80)
- Quick overview: 44 words (limit 10-50)
- How it works: 130 words (minimum 50, numbered list)
- Setup: 142 words (minimum 50, numbered list)

======= FIELD: Title =======
Watch competitors' winning Google Ads each week and post to Slack
======= END Title =======

======= FIELD: Quick overview =======
Every Monday, this workflow checks your competitors' public Google ads and posts a Slack digest of ads that became winning this week (still running after 30 days by default) and ads that just launched. Domains with no ads are listed instead of failing silently.
======= END Quick overview =======

======= FIELD: How it works =======
1. Every Monday at 08:00, or when you click Test once, the workflow starts and reads the competitor websites, country, day thresholds, ad cap and Slack channel from the configuration node.
2. It runs the xsi/google-ads-transparency Actor on Apify and waits for official Ads Transparency Center records as flat JSON. Authentication is an n8n HTTP Header Auth credential, not a token pasted into the node.
3. The report keeps ads that became winning in the lookback window (still running after the configured day threshold) and ads first shown in that window.
4. It posts one Slack message with both lists, plus any domain that returned no ads or could not be checked. If Apify fails or returns no rows, the workflow still posts a structured report instead of stopping silently.
======= END How it works =======

======= FIELD: Setup =======
1. In n8n, create an HTTP Header Auth credential. Set the header name to Authorization and the header value to Bearer followed by a space and your Apify API token (Apify Console, Settings, API and Integrations). Open the Run Google Ads Transparency node and select that credential.
2. Create a Slack credential using a bot access token or OAuth2, with the chat:write scope. Invite the bot to the destination channel. Open the Post weekly report to Slack node and select that credential.
3. In Configure competitors and thresholds, replace the example websites with your competitors and set the region, daysThreshold (default 30), lookbackDays (default 7), maxAdsPerQuery and slackChannel (for example #competitor-ads).
4. Click Test once, check that the Slack message lists winning ads, new launches and any domain with no ads, then activate the workflow so it runs every Monday at 08:00.
======= END Setup =======

======= FIELD: Requirements =======
You need an n8n instance (Cloud or self-hosted; this template uses built-in nodes only, no community nodes), an Apify account and API token, and a Slack workspace with a bot or OAuth credential that can post in the target channel. The Actor xsi/google-ads-transparency is pay-per-result. A free Apify account includes monthly credit that covers small use, such as five competitors times 50 ads. Confirm the current list price on the Store page; it is about $0.001 per ad. The template itself is free; Apify usage is billed to your Apify account.
======= END Requirements =======

======= FIELD: Customization =======
Change the Monday 08:00 schedule, adjust the winning-ad threshold or lookback window, or replace the Slack node with Notion, Google Sheets or email. Keep maxAdsPerQuery modest while you test so a run stays cheap. Repeated weekly runs can list the same ad again if it still falls in the new-winner window; treat the message as a digest, not a strictly deduplicated log.
======= END Customization =======

======= FIELD: Additional info =======
The data is public Ads Transparency Center data only. It is not access to anyone's private Google Ads account. This template is a weekly winning-ad and launch digest, not a full creative-archive logger. Nearby n8n templates focus on writing every new creative into Google Sheets. The Actor returns at most maxAdsPerQuery ads per website and country, so a very large advertiser may have older new winners fall outside that cap. Impression ranges and other EU DSA fields are only published by Google for EU/EEA countries, and this digest does not request those paid detail fields by default. The first test starts a real Apify run and is chargeable if you have used up free credit.
======= END Additional info =======
