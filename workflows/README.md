# Free workflows: weekly watch of your competitors' winning Google ads

Every Monday, get the Google ads that **became "winning" this week** (still running after 30+ days: advertisers keep ads that work) and the **ads launched in the last 7 days**, for 5 competitors, in Slack or Notion. Data: Google's official Ads Transparency Center, via the Apify Actor [xsi/google-ads-transparency](https://apify.com/xsi/google-ads-transparency).

Cost: 5 competitors × 50 ads ≈ $0.25 per week ($1 per 1,000 ads). The Apify free plan gives $5 of credit every month. Websites with no ads cost nothing and are listed at the bottom of the report.

## n8n (import in 30 seconds)

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
4. Test 5 rows (auto-update off), then click `status`, `headline`, `daysActive`, `isWinningAd`, `transparencyUrl` in a result cell to make columns. `status = "ok"` means the company runs Google ads, a lead signal for agencies. About $0.01 per company.

## Support

Bug or question: open an Issue on the Actor page (apify.com/xsi/google-ads-transparency → Issues) or in this repository. Answer within 24 hours.
