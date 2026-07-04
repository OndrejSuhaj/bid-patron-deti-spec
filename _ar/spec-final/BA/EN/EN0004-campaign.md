---
doc_id: EN0004
title: Campaign
canonical_layer: EN
spec_type: entity
status: canonical
modules: []
references:
  - EN0001
  - EN0005
  - EN0009
  - EN0021
  - EN0028
  - BR-CampaignStoryLifecycle
  - BR-PaymentAndMoneyIntegrity
  - BR-CampaignRecommendationDormant
  - UC0002
  - UC0011
---

# EN0004 — Příběh

## Účel

Příběh (Campaign / Příběh) je veřejně prezentovaný fundraisingový příběh vygenerovaný ze schválené
Žádosti (EN0001). Reprezentuje případ žadatele vůči veřejnosti: cílovou částku, průběžně vybranou
celkovou částku, termín (deadline) a veřejný profil Patrona (EN0005), a prochází fundraisingovým
životním cyklem od připravenosti přes publikaci až po výsledek naplnění nebo vypršení. Příběh se může
odkazovat sám na sebe jako na nadřazený Příběh, čímž vyjadřuje seskupení promo/skupinových příběhů
(varianta skupina/sběrný účet není plně doložena — `Partial`).

---

## Životní cyklus

- in-progress
- active
- completed
- campaign_uncompleted
- suspended
- canceled
- completed_partly

Byla pozorována i běhová hodnota `campaign_uncompleted_inprocess`, která však není součástí
deklarovaného výčtu statusů — `Uncertain`, původ nepotvrzen.

---

## Přechody stavů

in-progress → active
trigger: UC0011 (UC0011.1 — Admin publikuje / nastaví Příběh jako aktivní)

active → completed
trigger: UC0011 (UC0011.1 krok 7 — naplnění cílové částky je vyhodnoceno při uložení Příběhu); viz BR-CampaignStoryLifecycle (pravidlo naplnění)

active → campaign_uncompleted
trigger: UC0011 (UC0011.2 — naplánovaná kontrola životního cyklu při vypršení termínu); viz BR-CampaignStoryLifecycle (pravidlo nenaplnění)

(status je udržován v souladu s nadřazenou Žádostí)
trigger: UC0002 (UC0002.2 krok 10 — změna statusu Žádosti synchronizuje status/kategorii navázaného Příběhu)

active → suspended — Hypothesis, žádný potvrzený trigger nedoložen.
active → canceled — Hypothesis, žádný potvrzený trigger nedoložen.
active → completed_partly — Hypothesis, žádný potvrzený trigger nedoložen.

---

## Atributy

### Systémem spravované atributy

- campaign_raised (integer; systémem spravované; odvozená průběžná celková částka — viz BR-CampaignStoryLifecycle)
- campaign_percentual_raised (decimal; systémem spravované; odvozený postup vůči cílové částce — viz BR-CampaignStoryLifecycle)
- campaign_status (list; systémem spravované; povolené hodnoty: in-progress, active, suspended, completed, uncompleted, campaign_uncompleted, completed_partly, canceled)
- published / completed / uncompleted / canceled (timestamp; systémem spravované; data milníků životního cyklu)
- slug (string; systémem spravované; automaticky generovaný veřejný identifikátor; předchozí identifikátory se archivují při změně veřejného názvu)
- name / name_covid19 (string; systémem spravované; popisek entity)

### Uživatelem zadávané atributy

- gift_price (integer; povinné; cílová částka; platí minimální hodnota)
- campaign_deadline (datetime; povinné; musí být budoucí datum; pro rumunský trh je termín dále omezen na pracovní den — viz BR-CampaignStoryLifecycle)
- type (list; povinné; hodnoty: basic, promo, long_term, short_term; výchozí basic)
- button_text (string; povinné)
- patron_profile (reference na EN0005 — Patron; volitelné; veřejný profil patrona zobrazený u Příběhu)
- gift_category (reference na taxonomickou kategorii; volitelné; účel případu)
- single_parent, hide_campaign_raised (boolean; volitelné; příznaky zobrazení/chování)
- is_*_email_sent (boolean; systémem spravované; příznaky odeslání notifikace)
- požadovaná obrazová dokumentace (volitelně/podmíněně dle role; podmínka pro publikaci — viz BR-CampaignStoryLifecycle)

---

## Invarianty

- Odvozená vybraná celková částka a procento postupu vůči cíli — viz BR-CampaignStoryLifecycle.
- Podmínka připravenosti k publikaci (navázaný případ, veřejný profil Patrona, kladná cílová částka, budoucí termín, požadované obrázky) — viz BR-CampaignStoryLifecycle.
- Nejvýše jeden veřejný profil Patrona (EN0005) na Příběh — viz BR-CampaignStoryLifecycle.
- Automatické naplnění a nenaplnění řízené termínem, a jejich dopad (cascade) na navázanou Žádost — viz BR-CampaignStoryLifecycle.
- Pravidlo pracovního dne pro termín na rumunském trhu — viz BR-CampaignStoryLifecycle.
- Přípustnost daru vůči již naplněnému Příběhu — viz BR-PaymentAndMoneyIntegrity (přípustnost peněz).
- Zpracování přeplatku pro tento Příběh — viz BR-PaymentAndMoneyIntegrity (rozdělení přeplatku).
- Jakákoli vazba na doporučování Příběhů je neaktivní a nepředstavuje aktivní invariant současného stavu — viz BR-CampaignRecommendationDormant.

Conflict — Status Žádosti a status Příběhu mají zůstat vzájemně konzistentní, avšak přechod k publikaci
(na straně Příběhu i na straně Žádosti) není doložen jako atomický; částečné selhání mezi oběma uloženími
může vést k jejich nekonzistenci, a zjištěné rozsynchronizování se pouze loguje, nikoli opravuje
(mezera současného stavu; viz BR-CampaignStoryLifecycle).

---

## Vztahy

- EN0001 — Žádost (navázaný případ; 1:1; status udržován v zámku)
- EN0005 — Patron (veřejný profil patrona; nejvýše jeden na Příběh)
- EN0004 — Příběh (sebereference; nadřazený, pro promo/skupinové příběhy)
- EN0021 — Zpětná vazba (poděkování žadatele po skončení příběhu)
- EN0028 — Log příběhu (auditní stopa jednotlivého Příběhu; autor zápisu nedoložen — `Hypothesis`)
- EN0009 — Transakce (uhrazené Transakce určují odvozenou vybranou celkovou částku Příběhu)

---

## Otevřené otázky

- Co spouští stavy `suspended`, `canceled` a `completed_partly`?
- Jak se dosahuje nedeklarované hodnoty `campaign_uncompleted_inprocess` a jak se ruší?
- Jaká je sémantika naplnění nadřazeného (promo/skupinového) Příběhu ve vztahu k jeho podřízeným příběhům?
