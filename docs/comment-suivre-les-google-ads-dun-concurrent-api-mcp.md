# Comment suivre les Google Ads de n’importe quel concurrent (et obtenir les impressions UE) avec une API / MCP

Pas besoin d’entrer dans le compte Google Ads d’un rival pour voir ce qu’il diffuse. Google publie déjà une bibliothèque publique — le [Ads Transparency Center](https://adstransparency.google.com/) — qui couvre Search, YouTube, Shopping, Maps et Google Play, dans tous les pays pris en charge.

Cet article montre comment extraire ces données via une API, ou laisser un agent IA le faire en MCP, avec l’[Actor Google Ads Transparency](https://apify.com/xsi/google-ads-transparency) publié sur Apify. Le fil rouge est un **vrai run** du 26 novembre 2026, qui compare **Nike et Adidas** aux **États-Unis, au Royaume-Uni, en Allemagne et en France**. Les fourchettes d’impressions de l’UE n’apparaissent qu’ensuite, comme un bonus disponible dans l’UE et l’EEE, pas aux États-Unis ni au Royaume-Uni.

Le public visé : marketeurs, agences, équipes e-commerce, et ceux qui construisent des outils d’ad intelligence ou des agents IA.

## Ce que j’ai réellement lancé

Le 26 novembre 2026 à 10 h 48 (heure de Bruxelles, 09 h 48 UTC), j’ai lancé le run Apify [`biPCUmNEKOhNQP5oO`](https://console.apify.com/view/runs/biPCUmNEKOhNQP5oO) avec cette entrée :

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

Cela fait deux pubs par marque et par pays — 16 pubs, pas un export complet. L’objectif était de mesurer les volumes, puis de lire un petit échantillon réel de créas et de textes.

Le run s’est terminé en **46,8 secondes**. Il a facturé 16 événements « ad-detail » et 13 événements « ad-copy », soit **0,045 $** aux tarifs de l’Actor. Il n’y a pas de frais de lancement. J’avais aussi plafonné le run à 0,08 $. Apify a enregistré 0,0021 $ d’usage plateforme (calcul et proxy) ; pour un client payant, ces frais sont inclus dans les prix des événements.

Google a refusé quelques requêtes en cours de route (2 limitations de débit et 1 page CAPTCHA sur 39 requêtes HTTP, soit 5,1 % de refus). L’Actor a réessayé et changé de session proxy. Il ne résout pas les pages CAPTCHA. Les 16 éléments sont revenus, sans erreur.

Un compte Apify gratuit inclut 5 $ de crédit par mois, largement assez pour répéter ce type de contrôle.

## D’abord, les volumes

Avant même de lire une accroche, Google indique combien de pubs il détient pour chaque domaine dans chaque pays. Ces chiffres sont les fourchettes officielles de Google pour les **domaines mondiaux** `nike.com` et `adidas.com`. Une marque peut aussi publier sous un site local (par exemple `adidas.co.uk`) : ce serait une autre requête, que je n’ai pas lancée ici.

| Domaine | États-Unis | Royaume-Uni | Allemagne | France |
|---|---|---|---|---|
| nike.com | 8 000–9 000 pubs | 2 000–3 000 | 9 000–10 000 | 8 000–9 000 |
| adidas.com | 4 000–5 000 pubs | 68 | 600–700 | 600–700 |

Dans cet instantané, le domaine mondial de Nike avait une présence bien plus large que celui d’Adidas dans chacun des marchés interrogés. L’écart est particulièrement net au Royaume-Uni (des milliers de pubs Nike contre 68 pubs Adidas sur `adidas.com`). Ce n’est pas une mesure de dépense publicitaire, ni un classement de la qualité des créas. C’est le décompte officiel des pubs que Google a en fichier pour ces domaines.

Les entités juridiques de l’échantillon étaient stables : **Nike, Inc.** aux États-Unis, **Nike Retail BV** au Royaume-Uni, en Allemagne et en France, et **Adidas America, Inc.** dans les quatre pays.

## Ce que disaient les pubs le 26 novembre 2026

Les 16 pubs renvoyées sont un échantillon de deux par case, pas « les meilleures pubs ». Le texte est pourtant déjà utile.

**Nike était sur un temps Black Friday.** Une pub texte américaine, d’abord vue le 22 novembre 2026 (05 h 02 UTC) et encore diffusée le 26 novembre, promouvait la collection Nike Golf : « Save big this Black Friday using code BFRIDAY for an extra 25% off select styles. » Page officielle : [créa US CR09898538327395532801](https://adstransparency.google.com/advertiser/AR16735076323512287233/creative/CR09898538327395532801?region=US).

Une pub texte britannique de Nike Retail BV utilisait une accroche plus large : « Nike Black Friday Days Are On » / « Up To 40% Off Selected Styles. Ends On December 1st. » Google a enregistré cette créa pour la première fois le 19 septembre 2025, et elle était encore diffusée le 26 novembre 2026. Page officielle : [créa GB CR00669994402592063489](https://adstransparency.google.com/advertiser/AR18378488041124659201/creative/CR00669994402592063489?region=GB).

En France, une pub texte présentait **NikeSKIMS** (« Introducing An Updated Take On Pilates Wear From NikeSKIMS. »), d’abord vue le 20 février 2026. Page officielle : [créa FR CR13374024866886320129](https://adstransparency.google.com/advertiser/AR18378488041124659201/creative/CR13374024866886320129?region=FR).

**L’échantillon Adidas était plus « evergreen ».** Aux États-Unis, l’une des deux pubs était une vidéo YouTube (`WVLa-eUBGjE`, d’abord vue le 11 novembre 2026). Page officielle : [créa US CR03714073080885149697](https://adstransparency.google.com/advertiser/AR14017378248766259201/creative/CR03714073080885149697?region=US). L’autre pub US, aussi diffusée en Allemagne et en France sous le même identifiant, vendait la Terrex Freehiker 3 : « Not a hiker? You Are Now. » Page officielle : [créa US CR02127259033550192641](https://adstransparency.google.com/advertiser/AR14017378248766259201/creative/CR02127259033550192641?region=US).

Au Royaume-Uni, les textes Adidas incluaient « Shop The adidas Official Site Today. Free Shipping For Members On All Orders. » et « Shop The Three Stripes. » En Allemagne et en France, l’échantillon comprenait aussi des chaussettes, des vêtements et chaussures enfants, et la même pub Freehiker.

Deux leçons concrètes, même sur 16 pubs :

1. **La même créa peut apparaître dans plusieurs pays.** La pub Freehiker est ressortie aux États-Unis, en Allemagne et en France. On déduplique avec `creativeId`.
2. **La langue du texte n’est pas toujours celle du pays demandé.** Une pub Nike échantillonnée en Allemagne avait un texte en polonais (« Oficjalna strona Nike » / Black Friday jusqu’à −40 % jusqu’au 1er décembre). Elle était aussi diffusée en Pologne, entre autres. Page officielle : [créa DE CR07648843056275259393](https://adstransparency.google.com/advertiser/AR18378488041124659201/creative/CR07648843056275259393?region=DE).

## Le bonus UE : les fourchettes d’impressions officielles

Google **ne publie pas** de nombre d’impressions pour les États-Unis ni pour le Royaume-Uni. Si vous travaillez surtout sur ces marchés, vous obtenez quand même le nom de l’annonceur, le format, les dates de première et dernière diffusion, les pays, le texte et l’URL officielle de la pub.

Dans l’UE et l’EEE, le Digital Services Act impose un dépôt public plus détaillé. Pour ces pays, l’Actor ajoute, lorsque Google les a publiées :

- une **fourchette d’impressions** officielle pour le pays demandé
- une **répartition par plateforme** (Search, YouTube, Shopping, Maps, Play)
- un **total UE** pour la même créa
- les **critères de sélection d’audience** : démographie, zones géographiques, signaux contextuels, listes de clients, centres d’intérêt (inclus, exclus, ou non utilisés)

Google publie en général ces fourchettes seulement après environ 90 jours, et ce sont des fourchettes, pas des comptes exacts. Si la borne haute manque, l’Actor enregistre `impressionsMax` à `null`.

C’est là que ce run devient frappant.

Une pub image Shopping Nike, ancienne, en France — chaussettes de training mi-mollet Everyday Cushioned, lot de 6, noir, taille 42–46, première mention le 25 octobre 2021 — avait un plancher officiel de **10 000 000 d’impressions en France**, sans borne haute publiée (`impressionsMax` est `null`). La répartition : Search au même plancher de 10 000 000, Shopping 450 000–500 000, YouTube 15 000–20 000. Page officielle : [créa FR CR18139369585210556417](https://adstransparency.google.com/advertiser/AR18378488041124659201/creative/CR18139369585210556417?region=FR).

La pub Nike en polonais échantillonnée en Allemagne n’avait que **0–1 000 impressions en Allemagne**, mais **250 000–300 000 dans l’UE**. Un petit chiffre national n’est pas une petite campagne.

Même une requête au Royaume-Uni peut porter un total UE si la créa a aussi tourné dans l’Union. La pub Black Friday Nike vue au Royaume-Uni n’a pas de fourchette d’impressions britannique, mais Google reporte 2 000–3 000 impressions UE pour cette créa, parce qu’elle a aussi été diffusée en France, en Allemagne, en Espagne et en Italie, entre autres.

## Comment reproduire ce run

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

Les versions JavaScript et cURL sont dans le [dossier examples](https://github.com/Bilal10B/google-ads-transparency-mcp/tree/main/examples). Remplacez les domaines et les codes pays pour n’importe quel autre concurrent : `shopify.com`, `apple.com`, le rival d’un client, ce que vous voulez.

### MCP, pour les agents IA

Le même produit est un serveur MCP distant (Streamable HTTP) :

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

Outils :

- `find_advertiser` — nom ou site → identifiants d’annonceurs
- `list_ads` — pubs d’un domaine ou d’un annonceur, filtrées par pays, format, plateforme et dates
- `get_ad_details` — une pub, avec impressions et ciblage UE lorsqu’ils existent
- `new_ads_since` — pubs d’abord vues à partir d’une date, pour une veille quotidienne ou hebdomadaire

On peut alors demander à un agent : « Quelles nouvelles pubs Nike a-t-il lancées aux États-Unis et en Allemagne depuis le 1er novembre ? » ou « Compare le volume de pubs adidas.com au Royaume-Uni et en France. »

## Tarifs (prix affichés)

On ne paie que les résultats. Le calcul et le proxy sont inclus. Pas de frais de lancement.

| Événement | Prix |
|---|---|
| Pub (texte inclus) | 0,001 $ (0,0007 $ en GOLD) |
| Pub avec détails UE (remplace le prix « pub ») | 0,0015 $ (0,001 $ en GOLD) |
| Texte lu par OCR, seulement s’il est trouvé | 0,001 $ |
| Alerte nouvelle pub (mode monitor) | 0,005 $ |
| Appel d’outil MCP | 0,003 $, plus les événements ci-dessus |

Un run ne dépasse jamais *Max ads per query*, *Max items* ou *Max cost per run*. Les résultats vides ou en échec ne sont pas facturés.

## Avertissement

Il s’agit de données publiques du Ads Transparency Center de Google. Ce n’est pas un accès au compte pub privé de qui que ce soit. Les impressions sont des fourchettes officielles publiées par Google au titre du DSA ; elles ne sont en général disponibles qu’après environ 90 jours, ce sont des fourchettes et non des comptes exacts, et elles ne sont pas publiées hors UE. Ouvrez toujours l’URL officielle `transparencyUrl` pour vérifier une fiche.

Les noms Nike, Adidas et d’autres marques sont utilisés uniquement comme exemples de données publiques de transparence.

## Liens

- [Actor Google Ads Transparency sur le Store Apify](https://apify.com/xsi/google-ads-transparency)
- [Endpoint MCP](https://xsi--google-ads-transparency.apify.actor/mcp)
- [Échantillon de ce run](../examples/sample-output.json)
- [Google Ads Transparency Center](https://adstransparency.google.com/)
