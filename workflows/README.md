# Free workflows: weekly watch of your competitors' winning Google ads

Every Monday, get the Google ads that **became "winning" this week** (still running after 30+ days: advertisers keep ads that work) and the **ads launched in the last 7 days**, for 5 competitors, in Slack or Notion. Data: Google's official Ads Transparency Center, via the Apify Actor [xsi/google-ads-transparency](https://apify.com/xsi/google-ads-transparency).

Cost: 5 competitors × 50 ads ≈ $0.25 per week ($1 per 1,000 ads, ad copy included; +$0.001 per ad text read by OCR). The Apify free plan gives $5 of credit every month. Websites with no ads cost nothing and are listed at the bottom of the report.

> Actor v2.1 (26 Nov 2026) adds one free `domain_summary` row per website. All workflows here ignore it in the "No ads" line (updated files of 26 Nov 2026). If you imported an older copy, re-import it or add `&& row.status !== 'domain_summary'` to the filter of the report Code node.

## NEW — Radar: winning, new and stopped ads → Slack and Notion

[`n8n-google-ads-radar-slack-notion.gallery.json`](n8n-google-ads-radar-slack-notion.gallery.json): one weekly digest with a summary line per competitor, winning ads, new launches, **new and stopped ads since last week** (monitor mode) and promo codes or discounts seen in the ads. Setup takes about 3 minutes: Apify HTTP Header Auth credential in both Apify nodes, Slack and Notion credentials, then edit **Configure radar**. Form fields for a creators.n8n.io submission: [`radar/GALLERY-FORM-FIELDS-RADAR.md`](radar/GALLERY-FORM-FIELDS-RADAR.md).

Tested on n8n 2.49.7 on 26 Nov 2026 with real Apify runs (Slack and Notion nodes removed for the test): the first run stored a baseline, the second reported 1 stopped ad, the third did not repeat it. Reports: [`test-results/radar-run1-report.txt`](test-results/radar-run1-report.txt), [`radar-run2`](test-results/radar-run2-report.txt), [`radar-run3`](test-results/radar-run3-report.txt). Keep about 3 competitors per copy: Apify synchronous runs stop after 300 s.

## n8n template gallery file (recommended import)

For a first install, import [`n8n-weekly-winning-ads-slack.gallery.json`](n8n-weekly-winning-ads-slack.gallery.json). It follows the official [n8n template submission guidelines](https://docs.n8n.io/contribute/create-templates/submission-guidelines/): no tokens in node bodies, an **Edit Fields** configuration node, n8n credentials, sticky notes, and continue-on-fail handling for empty or failed Apify results.

1. n8n → **Workflows → Import from file** → pick `n8n-weekly-winning-ads-slack.gallery.json`.
2. Create an **HTTP Header Auth** credential: header name `Authorization`, value `Bearer` plus your Apify API token (Apify Console → Settings → API & Integrations). Select it on **Run Google Ads Transparency**.
3. Create a Slack credential (bot token or OAuth2, `chat:write`) and select it on **Post weekly report to Slack**. Invite the bot to the channel.
4. In **Configure competitors and thresholds**, set your websites, country, day thresholds, ad cap and Slack channel.
5. Click **Test once**, then **Activate**.

Title, description and categories for a [creators.n8n.io](https://creators.n8n.io) submission are in [`GALLERY-SUBMISSION.md`](GALLERY-SUBMISSION.md). Nothing has been submitted from this repository.

## n8n (import in 30 seconds)

The two files below are the original shorter variants. The Slack file still expects you to paste an Apify token and a Slack incoming-webhook URL into the HTTP Request nodes. Prefer the gallery file above for new setups.

| File | Destination |
|---|---|
| `n8n-weekly-winning-ads-slack.json` | Slack incoming webhook |
| `n8n-weekly-winning-ads-notion.json` | One page per ad in a Notion database |

1. n8n → **Workflows → Import from file** → pick the JSON.
2. Node **Run Google Ads Transparency**: replace `YOUR_APIFY_TOKEN` (Apify Console → Settings → API & Integrations) and the 5 websites / country in the JSON body.
3. Slack: replace the webhook URL (Slack → Apps → Incoming Webhooks). Notion: replace `YOUR_NOTION_TOKEN` and `YOUR_DATABASE_ID`, and share the database with your integration. Database properties: Name (title), Competitor (text), Type (select), Format (select), Days active (number), First shown (date), Link (URL).
4. Click **Test workflow**, then **Activate**.

Both files were imported into n8n (CLI `import:workflow`, 26 Nov 2026) and the report code was run on real Actor output. Sample Slack message:

```
Competitor Google Ads — weekly report (100 ads checked, 83 winning ads running 30+ days)
New winning ads this week (crossed 30 days, still running): 7
• ahrefs.com · TEXT · "Check Any Website's Traffic - See Which Page Types Win" · 36 days · view
New ads launched in the last 7 days: 0
No ads / not checked: nonexistent-shop-xyz-48213.com (no_ads_found)
```

## Make (5 modules)

1. **Schedule**: every week, Monday 08:00.
2. **Apify → Run an Actor**: Actor `xsi/google-ads-transparency`, *Run synchronously* = Yes, Input JSON: `{"domains": ["competitor1.com", "competitor2.com"], "regions": ["US"], "maxAdsPerQuery": 50}`.
3. **Apify → Get Dataset Items**: Dataset ID = `defaultDatasetId` from step 2.
4. **Filter**: `status` = `ok` AND `isWinningAd` = `true` AND `daysActive` ≤ `37` (new winners). Make a second route with `firstShownDate` ≥ `{{formatDate(addDays(now; -7); "YYYY-MM-DD")}}` for new launches.
5. **Text aggregator** (`{{inputDomain}} · {{headline}} · {{daysActive}} days · {{transparencyUrl}}`) → **Slack → Create a Message**, or **Notion → Create a Database Item** / **Google Sheets → Add a Row** (without the aggregator).

## Clay (4 steps)

1. Connect Apify once: *Settings → Connections → Add connection → Apify*, paste your Apify token.
2. In a table of companies with a website column: *Add enrichment* → **Run Apify Actor** → `xsi/google-ads-transparency`.
3. Input Data: `{ "domain": /Website, "regions": ["US"], "maxAdsPerQuery": 10 }` (insert the column with `/`; the key stays quoted, the token does not).
4. Test 5 rows (auto-update off), then click `status`, `headline`, `daysActive`, `isWinningAd`, `transparencyUrl` in a result cell to make columns. `status = "ok"` means the company runs Google ads, a lead signal for agencies. About $0.01 per company. Since v2.1 the last row of each result is a free `domain_summary` row (active, winning and new ads, formats, oldest ad, promo codes): see [`CLAY-GUIDE.md`](CLAY-GUIDE.md) for the exact columns.

## Support

Bug or question: open an Issue on the Actor page (apify.com/xsi/google-ads-transparency → Issues) or in this repository. Answer within 24 hours.
