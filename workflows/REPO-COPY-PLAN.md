# Repo copy plan (do not push)

Staging only. **Do not `git push`** until the owner explicitly asks to publish these files.

Public repository: [Bilal10B/google-ads-transparency-mcp](https://github.com/Bilal10B/google-ads-transparency-mcp)

Canonical working copy on this machine: `/workspace/gh-v2/`
Secondary staging copy (no `.git`): `/workspace/apify-actors/google-ads-transparency/visibilite/github-repo/`

## Files to copy on the next GitHub update

| Source (this tree) | Destination in the public repo | Action |
|---|---|---|
| `workflows/n8n-weekly-winning-ads-slack.gallery.json` | `workflows/n8n-weekly-winning-ads-slack.gallery.json` | **Add** — this is the file to upload on [creators.n8n.io](https://creators.n8n.io) |
| `workflows/GALLERY-SUBMISSION.md` | `workflows/GALLERY-SUBMISSION.md` | **Add** — title, description, categories, setup |
| `workflows/GALLERY-FORM-FIELDS.md` | `workflows/GALLERY-FORM-FIELDS.md` | **Add** — creators.n8n.io form sections (Title, Quick overview, How it works, Setup, …) |
| `workflows/test-results/slack-message-captured.txt` | optional | Local e2e capture of the Slack payload (26 Nov 2026). Do not treat as a required public-repo file. |

| `workflows/REPO-COPY-PLAN.md` | `workflows/REPO-COPY-PLAN.md` | **Add** — this plan |
| `workflows/README.md` | `workflows/README.md` | **Update** — document the gallery workflow and credential setup |
| `workflows/n8n-weekly-winning-ads-slack.json` | `workflows/n8n-weekly-winning-ads-slack.json` | **Keep** the simpler repo variant for now (it still uses token placeholders in node bodies; prefer the gallery file for new imports) |
| `workflows/n8n-weekly-winning-ads-notion.json` | `workflows/n8n-weekly-winning-ads-notion.json` | **Unchanged** in this pass (still has token placeholders; not gallery-ready) |

Do **not** include any Apify token, Slack webhook, or n8n credential secret. The gallery JSON only references generic credential names (`Apify API`, `Slack account`).

## Copy commands (local only)

```bash
# Run from /workspace/gh-v2 (source of truth for these files).
# This only updates the secondary staging folder. It does not commit or push.
cp workflows/n8n-weekly-winning-ads-slack.gallery.json \
   workflows/GALLERY-SUBMISSION.md \
   workflows/REPO-COPY-PLAN.md \
   workflows/README.md \
   /workspace/apify-actors/google-ads-transparency/visibilite/github-repo/workflows/
```

The secondary staging copy should be updated with the same four files when this plan is applied locally. A git commit can be prepared later; **do not push**.

Suggested commit message (when the owner asks to commit, still without pushing unless they also ask to push):

```
Add n8n template gallery workflow (credentials, Set config, sticky notes)
```

## Not in this pass

- No `git push` to `origin`.
- No submission to creators.n8n.io.
- No change to Actor pricing or the published Actor version.
- The Notion workflow is not yet converted to gallery rules.

## 26 November 2026 update (Europe/Brussels)

The gallery JSON node and assignment IDs were changed from sequential `b2c3d4e5-0000-4000-8000-…` values (flagged by the n8n gallery AI review as a phone-like string) to random UUIDs. Workflow logic, sticky notes and parameters were not changed. Still do not push until asked.

## v2.1 update (26 Nov 2026)

| Source | Action |
|---|---|
| `README.md` (root) | **Update**: v2.1 prices, fields, MCP timing, Glama badges |
| `server.json` (root) | **Update**: version 2.1.0 (registry publish needs `mcp-publisher login github`) |
| `workflows/n8n-google-ads-radar-slack-notion.gallery.json` | **Add**: Radar workflow |
| `workflows/radar/GALLERY-FORM-FIELDS-RADAR.md` | **Add** |
| `workflows/CLAY-GUIDE.md` | **Add** |
| `workflows/test-results/radar-run*-report.txt` | **Add** (optional) |
| `workflows/n8n-weekly-winning-ads-*.json` | **Update**: ignore `domain_summary` rows |
| `workflows/README.md` | **Update** |
