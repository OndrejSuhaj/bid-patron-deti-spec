---
doc_id: EN0003
title: ApplicationSession
canonical_layer: EN
spec_type: entity
status: canonical
modules: []
references:
  - EN0001 (Application)
  - EN0026 (ApplicationReaction)
  - UC0001 (Submit Application)
  - UC0002 (Orchestrate Application Status Change)
---

# EN0003 — ApplicationSession

## Účel

ApplicationSession určuje *jak* a *kým* může být formulář dané žádosti (EN0001) přístupný během
vícekrokového vyplňování a jeho následných interakcí řízených stavem (např. podepisování, zpětná
vazba). Každá session páruje roli (fundraiser nebo patron) s variantou přístupového rozhraní a
definicí formuláře a je buď aktivní, nebo deaktivovaná. Jde o záznam řízení přístupu/rozhraní pro
editaci žádosti na front-endu.

---

## Životní cyklus

- Active
- Deactivated

---

## Přechody stavů

(create) → Active
trigger: UC0001 — Submit Application (při vytvoření žádosti vzniknou dvě session, jedna pro každou
roli — patron a fundraiser)

(create) → Active
trigger: UC0002.2 — Downstream reaction fan-out on status change (odpovídající ApplicationReaction,
EN0026, určuje rozhraní session pro nový stav/roli)

(create) → Active
trigger: UC0002.2 — Downstream reaction fan-out on status change (vstup do stavu čekání na podpis
nebo čekání na zpětnou vazbu vytvoří session nesoucí formulář pro podpis nebo zpětnou vazbu)

Active → Deactivated (všechny session dané žádosti)
trigger: UC0002.2 — Downstream reaction fan-out on status change (nový stav je nakonfigurován tak,
že zneplatňuje session)

Otevřeno — přechod re-aktivace (Deactivated → Active) není doložen; není potvrzen žádný trigger pro
změnu stavu `readonly`.

---

## Atributy

### Systémem spravované atributy

- identifikátor session (identifikátor; povinný; jednoznačně identifikuje session)
- status (booleovská hodnota; povinný; výchozí Active; nastaven na Deactivated reakcí rušící session
  — viz Přechody stavů)
- readonly (booleovská hodnota; volitelný; výchozí not-readonly; trigger pro změnu není doložen)
- reference na žádost (reference na EN0001 – Application; volitelná; identifikuje vlastnící žádost)

### Uživatelem zadávané atributy

- interface (výčtový typ; volitelný; pozorované hodnoty: invited, authenticated_invited, custom —
  není doloženo žádné kanonické pravidlo pro výběr; viz Otevřené otázky)
- role (výčtový typ; volitelný; hodnoty: fundraiser, patron)
- schema (strukturovaná definice formuláře; volitelná; obsah formuláře, ke kterému session poskytuje
  přístup, např. sekce formuláře pro vyplnění žádosti/podpis/zpětnou vazbu)

---

## Invarianty

- Deaktivovaná session NESMÍ poskytovat přístup k editaci žádosti (obsah role/oprávnění je ve
  vlastnictví BR-AccessControlAndRoles).

(Omezení „nejvýše jedna aktivní session na roli“ není uvedeno jako invariant — není doloženo; je
sledováno v Otevřených otázkách.)

---

## Vztahy

- EN0001 – Application (vlastnící žádost dané session)
- EN0026 – ApplicationReaction (konfigurace určující, kdy je vytvořena session s daným
  rozhraním/rolí)

---

## Otevřené otázky

- Co určuje `interface` = invited vs. authenticated_invited vs. custom při vytvoření? (Není doloženo
  žádné kanonické pravidlo.)
- Vzhledem k tomu, že reference na žádost není doložena jako vynucená relační vazba, jak jsou
  ošetřeny osiřelé session (smazaná žádost)?
- Může být deaktivovaná session znovu aktivována, nebo je vždy vytvořena nová?
- Je omezení jedné aktivní session na roli tvrdým invariantem, nebo emergentním efektem konfigurace
  reakcí? Žádný vlastnící doc_id BR toto v současnosti explicitně neuvádí.
