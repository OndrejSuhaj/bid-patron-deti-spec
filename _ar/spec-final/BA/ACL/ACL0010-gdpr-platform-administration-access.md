---
doc_id: ACL0010
title: GDPR & Platform Administration Access
layer: ACL
spec_type: access-control
status: imported
modules: []
references:
  - EN0008
  - UC0015
  - UC0020
  - UC0022
  - FN0021
  - FN0023
  - FN0025
  - BR-DataProtectionAndErasure
  - BR-OperationalAlerting
  - ARCH0011
  - ARCH0012
---

# ACL0010 – Přístup ke GDPR a administraci platformy

## Účel

Přístup k průřezovým administrativním oblastem: GDPR oblast (ochrana osobních údajů / anonymizace),
oprávnění pro administraci entit `administer *`, přepínače funkcí (feature toggles), administrace
stavů žádosti, administrace taxonomie/konfigurace webu a super-role. Model aktérů je vlastněn ACL0001.

## Model aktérů

- `administrator` je super-role platformy (`is_admin: true`); obchází všechny kontroly oprávnění.
- `manager` má nejširší sadu oprávnění `administer *` mezi neadministrátorskými rolemi a je jedinou rolí
  s oprávněním `access gdpr`, `administer application_statuses` a s pravomocí přidruženou k
  `enable and disable features` (přepínač funkcí je samostatné oprávnění `enable and disable features`,
  které není přiřazeno žádné konfigurované roli — viz Výjimky).
- Rozsah (scope) je `platform`.

Evidence: `config/user.role.administrator.yml`, `config/user.role.manager.yml`;
`gdpr/gdpr.routing.yml`, `patron_base/patron_base.routing.yml`; definice oprávnění
`gdpr/gdpr.permissions.yml`, `patron_base/patron_base.permissions.yml`.

## Zdroje

- GDPR oblast pošty/anonymizace `/admin/gdpr/*` — `access gdpr`
- Administrace stavů žádosti — `administer application_statuses`
- Přepínače funkcí `/admin/features` — `enable and disable features`
- Vytvoření uživatele `/admin/create_user` — `manager administer users`
- Administrace entit (`administer <entity> entities`) — omezená oprávnění
- Administrace webu/taxonomie/konfigurace — `administer taxonomy`, `administer content types`, `administer site configuration`

## Matice

| Aktér / role | Zdroj | Akce | Rozsah | Poznámky |
|---|---|---|---|---|
| `administrator` | * | * | platform | `is_admin: true`; obchází kontroly oprávnění; prázdná explicitní sada oprávnění. |
| `manager` | GDPR oblast `/admin/gdpr/*` | přístup | platform | `access gdpr`. Jediná role s tímto oprávněním. |
| `manager` | Stavy žádosti | administrace | platform | `administer application_statuses`. |
| `manager` | Vytvoření uživatele `/admin/create_user` | vytvoření | platform | `manager administer users`. |
| `manager` | Typy obsahu / uzly | administrace | platform | `administer content types`, `administer nodes`, `bypass node access`. |
| `manager` | TaxPayer (EN0015) | administrace | platform | `administer tax_payer entities`. |
| `content_admin` | Typy obsahu / uzly / taxonomie | administrace | platform | `administer content types`, `administer nodes`, `administer taxonomy`, `bypass node access`. |
| `content_admin` | TaxPayer (EN0015) | administrace | platform | `administer tax_payer entities`. |
| `content_admin` | Blokový obsah / typy bloků | administrace | platform | `administer block content`, `administer block types`, `administer blocks`. |
| `content_admin` | Campaign (EN0004) | administrace | platform | `administer campaign entities`. |
| `marketing` | Typy obsahu / uzly / styly obrázků / bloky | administrace | platform | `administer content types`, `administer nodes`, `administer image styles`, `administer blocks`, `bypass node access`. |
| `marketing` | Blog (EN0024) | administrace | platform | `administer blog entity entities`. |
| `risk_manager` | Taxonomie | administrace | platform | `administer taxonomy`. |
| role s `administer site configuration` (pouze `administrator`) | Konfigurace bankovní integrace | nastavení | platform | `/admin/config/bank-integration/*`. |
| (žádná konfigurovaná role) | Přepínače funkcí `/admin/features` | zapnutí/vypnutí | platform | `enable and disable features` — oprávnění je definováno, ale v konfiguraci není přiřazeno žádné roli (dosažitelné pouze přes `administrator` díky is_admin bypassu). Viz Výjimky. |

## Výjimky

- **`enable and disable features`** je definováno v `patron_base.permissions.yml` a chrání
  `/admin/features`, ale není přiřazeno žádné z 15 konfigurovaných rolí — dosažitelné pouze díky
  `is_admin` bypassu role `administrator`. Zaznamenáno jako current-state (`Confirmed`).
- Řada oprávnění `administer <entity> entities` má nastaveno `restrict access: true` (označeno jako
  citlivé), a přesto jsou přiřazena neadministrátorským rolím (např. `administer campaign entities` →
  content_admin, manager; `administer tax_payer entities` → content_admin, manager). Zaznamenáno jako
  pozorované oprávnění, nikoli jako doporučené.
- Sémantika GDPR anonymizace (jaká data se anonymizují, retence) je vlastněna
  BR-DataProtectionAndErasure; zde je zaznamenána pouze přístupová brána (`access gdpr`).
- Provozní alerting / audit kanály (Slack ES0015, Telegram ES0016) a workflow engine platformy
  (FN0025) běží jako systémoví/cron aktéři, nikoli jako uživatelské akce vázané na role — nemají
  žádné uživatelsky orientované řádky v ACL.

## Reference

- UC: UC0015 (anonymizace osobních údajů), UC0020 (odeslání provozních alertů/auditu), UC0022 (běh workflow engine platformy)
- FN: FN0021 (anonymizace osobních údajů), FN0023 (provozní alerting/audit), FN0025 (workflow engine / plánované publikování)
- EN: EN0008 (User)
- BR: BR-DataProtectionAndErasure, BR-OperationalAlerting
- ARCH: ARCH0011 (Identity and Access), ARCH0012 (Platform, Search and Operations)

## Otevřené body

- Zda je nepřiřazení oprávnění `enable and disable features` záměrné (vyhrazeno pouze pro admina) nebo
  jde o chybu v konfiguraci, nelze ze zdrojů rozhodnout; zaznamenáno k posouzení při rebuildu.
