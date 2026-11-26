## Who this is for

Paid-search marketers, PPC agencies and e-commerce teams who want a Monday digest of competitors' *public* Google ads — not every creative in the archive, but the ads that became “winning” this week (still running after a chosen number of days, default 30: advertisers usually keep ads that work) and the ads first shown in the same window.

## How it works

1. A weekly schedule (Monday 08:00) or the **Test once** trigger starts the workflow.
2. **Configure competitors and thresholds** holds the values you should edit: competitor websites, Transparency Center country code, winning-ad day threshold, lookback window, ad cap and Slack channel.
3. **Run Google Ads Transparency** starts the [xsi/google-ads-transparency](https://apify.com/xsi/google-ads-transparency) Actor on Apify and waits for the dataset. Authentication is an n8n **HTTP Header Auth** credential (`Authorization: Bearer` + your Apify token), not a token pasted into the node.
4. **Build weekly winning ads report** keeps new winners and new launches, and turns empty results, `no_ads_found` rows and request errors into a readable report so the workflow does not stop on a silent empty dataset.
5. **Post weekly report to Slack** sends one message to the configured channel using your Slack credential.

The data is public Ads Transparency Center data only. It is not access to anyone's private Google Ads account.

This template is a weekly *winning-ad and launch digest* for that Actor. It is not a full creative-archive logger. Nearby templates in the library focus on writing every new creative into Google Sheets (for example [Track competitor Google Ads Transparency Center ads with Apify and Google Sheets](https://n8n.io/workflows/17698) and [Log weekly Google Ads Transparency creatives to Google Sheets with Apify alerts via Slack or email](https://n8n.io/workflows/22986)). Use this one when the outcome you want is a short Slack briefing of ads that crossed the longevity threshold or just launched.

## Setup

1. In n8n, create an **HTTP Header Auth** credential named something like `Apify API`. Header name: `Authorization`. Header value: `Bearer` followed by a space and your Apify API token (Apify Console → Settings → API & Integrations). Open **Run Google Ads Transparency** and select that credential.
2. Create a **Slack** credential (bot access token or OAuth2) with the `chat:write` scope. Invite the bot to the destination channel. Open **Post weekly report to Slack** and select that credential.
3. In **Configure competitors and thresholds**, replace the example websites with your competitors and set `region`, `daysThreshold` (default 30), `lookbackDays` (default 7), `maxAdsPerQuery` and `slackChannel` (for example `#competitor-ads`).
4. Click **Test once**. Check that the Slack message lists winning ads, new launches, and any domain with no ads. Then activate the workflow so it runs every Monday at 08:00.

## Requirements

- An n8n instance (Cloud or self-hosted). This template uses built-in nodes only (Schedule, Manual Trigger, Edit Fields, HTTP Request, Code, Slack). No community nodes.
- An [Apify](https://apify.com) account and API token. The Actor [xsi/google-ads-transparency](https://apify.com/xsi/google-ads-transparency) is **pay-per-result**. A free Apify account includes monthly credit that covers small use (for example five competitors × 50 ads). Confirm the current list price on the Store page; it is about $0.001 per ad at the time this template was prepared (26 November 2026, Europe/Brussels). The template is free; Apify usage is billed to your Apify account.
- A Slack workspace and a bot or OAuth credential with permission to post in the target channel.

## Limitations

- The Actor returns at most `maxAdsPerQuery` ads per website and country, so a very large advertiser may have older “new winners” fall outside that cap.
- Repeated weekly runs can mention the same ad again if it still sits in the “new winner” window. Treat the message as a digest, not a strictly deduplicated log.
- Impression ranges and other EU DSA fields are only published by Google for EU/EEA countries, and this digest does not request those paid detail fields by default.
- The first test starts a real Apify run and is chargeable if you have used up free credit. Use a low `maxAdsPerQuery` for the first test.
