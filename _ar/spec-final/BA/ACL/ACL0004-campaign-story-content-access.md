---
doc_id: ACL0004
title: Campaign, Story & Content Access
canonical_layer: ACL
spec_type: access-control
status: canonical
modules: []
references:
  - EN0004
  - EN0005
  - EN0013
  - EN0024
  - EN0021
  - UC0011
  - UC0023
  - FN0006
  - FN0011
  - BR-CampaignStoryLifecycle
  - BR-VoucherPolicy
  - ARCH0005
---

# ACL0004 – Přístup ke kampaním, příběhům a obsahu

## Účel

Přístup ke kampani/příběhu (EN0004 Campaign, EN0005 Patron/story), obsahu CMS (blog EN0024, stránky,
success stránky, bloky, taxonomie), poukazu (EN0013 Voucher), zpětné vazbě (EN0021 Feedback) a
veřejnému čtení publikovaných kampaní/médií. Model aktérů je ve vlastnictví ACL0001.

## Model aktérů

- `content_admin` a `marketing` jsou primární role pro obsah/kampaně. `marketing` má na starosti
  autorský obsah CMS (blog/page/success_page/blocks/gutenberg); `content_admin` má na starosti správu
  kampaní/patronů/taxonomie. `manager` má široká CRUD oprávnění pro kampaně/blog. `anonymous`/
  `authenticated` čtou publikované kampaně a média.
- Rozsah je `global`/`platform` pro back-office; `public` pro čtení.

Evidence: `config/user.role.content_admin.yml`, `config/user.role.marketing.yml`,
`config/user.role.manager.yml`, `config/user.role.anonymous.yml`; definice oprávnění
`campaign/campaign.permissions.yml`, `blog/blog.permissions.yml`, `voucher/voucher.permissions.yml`,
`feedback/feedback.permissions.yml`.

## Zdroje

- Kampaň (EN0004) — CRUD, `edit campaign state`, `view campaign content page`
- Entita patron/příběh (EN0005) — CRUD (`patron entity entities`)
- Poukaz (EN0013) — zobrazení (back-office); uplatnění/použití přes veřejné REST (ACL0009)
- Blog (EN0024) + typy uzlů (page, form_page, success_page) — autorský obsah
- Znovupoužitelné bloky / knihovna bloků — CRUD
- Taxonomie (category, city, blog_category, faq_categories, gift_confirmation atd.) — CRUD termínů
- Zpětná vazba (EN0021) — zápis/administrace
- Publikované kampaně + média — veřejné čtení

## Matice

| Aktér / role | Zdroj | Akce | Rozsah | Poznámky |
|---|---|---|---|---|
| `content_admin` | Kampaň (EN0004) | add, administer, edit, `edit campaign state`, zobrazení content page | global | `add/administer/edit campaign entities`, `edit campaign state`, `view campaign content page`. |
| `content_admin` | Patron/příběh (EN0005) | add, edit, zobrazení publikovaných/nepublikovaných | global | `add/edit patron entity entities`, `view (un)published patron entity entities`. |
| `content_admin` | Taxonomie | administrace; editace termínů (category/city/faq/housing/income/partners/gift_confirmation) | global | `administer taxonomy`, `edit terms in *`, `delete terms in gift_confirmation`. |
| `content_admin` | Uzly / bloky | administrace uzlů/typů obsahu/bloků; `bypass node access` | platform | `administer nodes`, `administer content types`, `administer blocks`, `bypass node access`. |
| `content_admin` | Poukaz (EN0013) | zobrazení publikovaných | global | `view published voucher entity entities`. |
| `marketing` | Blog (EN0024) | add, administer, edit, delete (vlastní+cizí), revize | global | `add/administer/edit/delete blog entity entities`, `create/edit/delete any/own blog content`. |
| `marketing` | Typy uzlů page/form_page/success_page | create/edit/delete (vlastní+cizí), revize | global | Plnohodnotná autorská správa vč. `bypass node access`. |
| `marketing` | Gutenberg content blocks | vytváření/editace vlastních bloků; použití gutenbergu | global | `create and edit custom gutenberg content blocks`, `use gutenberg`. |
| `marketing` | Znovupoužitelné bloky / knihovna bloků | create/edit/delete/revert | global | `create/edit/delete any reusable_block block content`, `manage blocks lock`. |
| `marketing` | Kampaň (EN0004) | edit | global | `edit campaign entities`. |
| `marketing` | Překlad rozhraní | překlad | platform | `translate interface`, `use text format gutenberg`. |
| `manager` | Kampaň (EN0004) | add, administer, edit, `edit campaign state`, zobrazení | global | Plnohodnotné CRUD pro kampaně; `view campaign content page`. |
| `manager` | Patron/příběh (EN0005) | add, edit, zobrazení | global | `add/edit patron entity entities`, `view (un)published patron entity entities`. |
| `manager` | Blog (EN0024) | add, administer, edit, delete, zobrazení | global | Plnohodnotné CRUD pro blog; `edit terms in blog_category`, `create/delete terms in category`. |
| `manager` | Poukaz (EN0013) | zobrazení publikovaných | global | `view published voucher entity entities`. |
| `front` | Kampaň (EN0004) | edit | global | `edit campaign entities`; `view published voucher entity entities`. |
| `coordinator` | Přechody kampaně | použití `canceled_campaign`,`suspended_campaign` | global | Přechody workflow týkající se kampaně v konfiguraci coordinatoru. |
| `content_admin`,`manager`,`marketing`,`risk_manager` | Zpětná vazba (EN0021) | add | global | `add feedback entities` (content_admin, manager, marketing). |
| `anonymous` | Publikovaná kampaň (EN0004) | zobrazení | public | `view published campaign entities`. |
| `anonymous` | Média / galerie médií | zobrazení | public | `view media`, `view published media gallery entities`. |
| `authenticated` | Publikovaná kampaň / média | zobrazení | public | Stejné jako anonymous + `rotate images`. |

## Výjimky

- `bypass node access` (content_admin, manager, marketing) obchází kontrolu přístupu na úrovni
  jednotlivého uzlu pro Drupal uzly — eskalace na úrovni platformy pro role zaměřené na obsah.
- Přechody kampaně (`canceled_campaign`, `suspended_campaign`) jsou součástí sady oprávnění pro
  workflow žádosti a dědí mezery v legalitě přechodů (ACL0001 G-02/G-06).
- Uplatnění/validace poukazu je veřejná REST akce, nikoli back-office oprávnění — viz ACL0009 a
  BR-VoucherPolicy.

## Reference

- UC: UC0011 (správa životního cyklu kampaně/příběhu), UC0023 (procházení/filtrování katalogu příběhů), UC0009 (uplatnění/validace poukazu)
- FN: FN0006 (životní cyklus kampaně/příběhu), FN0011 (uplatnění poukazu), FN0024 (doporučení kampaně)
- EN: EN0004 (Campaign), EN0005 (Patron), EN0013 (Voucher), EN0021 (Feedback), EN0024 (Blog)
- BR: BR-CampaignStoryLifecycle, BR-VoucherPolicy
- ARCH: ARCH0005 (Campaign and Story)

## Otevřené body

- Žádné nad rámec sdílených mezer v legalitě přechodů.
