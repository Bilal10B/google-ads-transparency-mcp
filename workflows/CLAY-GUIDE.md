# Clay GTM table: "does this company run Google ads, and how hard?" (4 steps)

For a table of companies with a website column. One Clay row = one Apify run of [xsi/google-ads-transparency](https://apify.com/xsi/google-ads-transparency). No start fee: a company with no Google ads costs $0.

## 1. Connect Apify (once)
Clay → *Settings → Connections → Add connection → Apify* → paste your Apify API token (Apify Console → Settings → API & Integrations).

## 2. Add the enrichment
*Add enrichment* → **Run Apify Actor** → Actor `xsi/google-ads-transparency`. Turn auto-update off while testing.

## 3. Input (signals profile: fast and cheap)
```json
{ "domain": "/Website", "regions": ["US"], "maxAdsPerQuery": 25, "includeAdText": false, "ocrImageAds": false }
```
Insert the column with `/`: the key stays quoted, the column token replaces the value. Measured on 26 Nov 2026 (build 2.1.8, 256 MB): hubspot.com, 50 ads, 5.6 s; notion.so, 3 ads, 4.2 s; a website without ads, 4.9 s and $0. Cost: $0.001 per ad returned (FREE plan), so at most $0.025 per company with this cap. Want headlines and promo codes too? Remove `includeAdText` and `ocrImageAds`: slower (about 40–65 s per company) and promo detection needs the ad copy.

## 4. Columns to create
The result is a list of rows: up to 25 ad rows (`status: "ok"`), then one free summary row (`status: "domain_summary"`). A company with no ads returns a single row with `status: "no_ads_found"`.

Summary columns (from the row where `status = "domain_summary"`):

| Column | Field | Meaning |
|---|---|---|
| Runs Google ads | `status` of the first row | `ok` = yes, `no_ads_found` = no |
| Ads reported by Google | `totalAdsReportedMin` / `totalAdsReportedMax` | Google's own range for this country |
| Ads active now | `activeAdsCount` | Shown in the last 2 days, among the ads returned |
| Winning ads | `winningAdsCount` | Running 30+ days (change with `winningAdMinDays`) |
| New launches | `newLaunchesCount` | First shown in the last 7 days |
| Formats | `formatSplit.TEXT`, `formatSplit.IMAGE`, `formatSplit.VIDEO` | Search vs display vs YouTube mix |
| Oldest ad (days) | `oldestAdDays` | How long they have been advertising |
| Newest ad | `newestFirstShownDate` | Last launch date |
| Promo codes / discounts | `promoCodes`, `discounts` | Only with ad copy on |
| Top EU countries | `topEuCountries` | Only with `includeDetails: true` and EU regions |

Example summary row (hubspot.com, US, run bzOlb2F3EECTcefw6): 50 ads returned, 50 active, 47 winning, formats 29 text / 2 image / 19 video, oldest ad 1,859 days, newest first shown 2026-11-05, Google reports 1,000–2,000 ads.

If Clay shows only the first row, add a Formula column that picks the summary row from the list (for example, find the item whose `status` is `domain_summary`), then map the fields above from it. Check the exact formula syntax in your Clay workspace; it was not tested from Clay itself.

Lead logic for agencies: `no_ads_found` = pitch Google Ads; `activeAdsCount` high but `winningAdsCount` low = they test a lot without keepers (pitch optimisation); many `newLaunchesCount` = active campaign right now (good timing).
