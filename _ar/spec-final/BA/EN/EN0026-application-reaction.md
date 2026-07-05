---
doc_id: EN0026
title: ApplicationReaction
layer: EN
spec_type: entity
status: imported
modules: []
references:
  - EN0001  # Application (matched by status)
  - EN0003  # ApplicationSession (created by a matching reaction)
  - EN0008  # User (owner)
  - EN0025  # ApplicationLog (log entry appended by a matching reaction)
  - BR-ApplicationStatusGovernance  # reaction fan-out / matching is part of status-change governance
  - UC0002  # Orchestrate Application Status Change (fan-out that reads and executes reactions)
---

# EN0026 — ApplicationReaction (reakce na stav)

## Účel

ApplicationReaction je konfigurační záznam popisující, co má platforma udělat, když žádost
(Application, EN0001) dosáhne daného stavu, pro danou roli příjemce. Administrátoři vytvářejí
záznamy ApplicationReaction předem; každý z nich je za běhu porovnáván s aktuálním stavem a rolí
žádosti a — pokud dojde ke shodě a záznam je povolen — může vygenerovat status zprávu v zóně,
zobrazit tlačítko uživatelské akce, vytvořit ApplicationSession (EN0003) a odeslat notifikaci
při změně stavu. ApplicationReaction je konfigurace řídící chování: nevytváří se pro každou
žádost zvlášť a žádná konkrétní instance žádosti záznam reakce nevlastní ani jej nemění.

---

## Životní cyklus

- Disabled (výchozí)
- Enabled

Životní cyklus vyjadřuje pouze to, zda je reakce publikovaná/aktivní pro účely porovnávání; sám
o sobě nenese žádný doménový workflow. Vlastní záznam reakce je jinak pouze vytvářen a upravován,
nikoli přecházen mezi obchodními stavy — viz Přechody stavů.

---

## Přechody stavů

(vytvoření) → Disabled
trigger: administrativní vytvoření (vytvoří administrátor; žádný potvrzený UC vytvoření neřídí)

Disabled → Enabled / Enabled → Disabled
trigger: administrativní úprava (administrátor přepíná příznak publikace; žádný potvrzený UC tuto
úpravu nepokrývá)

Poznámka: ApplicationReaction je během UC0002.2 — Downstream reaction fan-out on status change
pouze *čtena*, nikoli převáděna mezi stavy. Porovnání reakce s novým stavem a rolí žádosti je
doloženým, potvrzeným chováním (viz BR-ApplicationStatusGovernance), avšak vytváření/úprava
samotných záznamů reakcí je administrativní konfigurace mimo jakýkoli rekonstruovaný use case.

---

## Atributy

### Systémem spravované atributy

- owner (odkaz na EN0008 – User; uživatel, který tento záznam reakce vlastní/vytvořil)
- created (časové razítko; povinné; čas vytvoření záznamu)
- changed (časové razítko; povinné; čas poslední úpravy záznamu)

### Uživatelem zadávané atributy

- role (výčtový typ; povinné; role příjemce/cíle, na kterou se tato reakce vztahuje — např. patron,
  fundraiser, podporovatel, pracovník organizace, anonymní uživatel)
- application status (výčtový typ; povinné; stav žádosti (Application, EN0001), proti kterému je
  tato reakce porovnávána; povolené hodnoty tvoří aktuální slovník stavů žádosti)
- initiator (výčtový typ; volitelné; omezuje porovnávání na reakce vyvolané konkrétní rolí — např.
  patron, fundraiser, pracovník organizace; nenastaveno znamená, že vyhovuje jakýkoli iniciátor)
- status message / status message detail (text; volitelné; text status zprávy v zóně zobrazený při
  shodě reakce)
- action button configuration (strukturované; volitelné; zda se zobrazí tlačítko uživatelské akce,
  jaká je jeho akce, popisek a případná potvrzovací výzva)
- session interface (výčtový typ; volitelné; varianta rozhraní použitá, když tato reakce vytváří
  ApplicationSession, EN0003)
- display styling (strukturované; volitelné; barva/ikona použitá při zobrazení reakce v zóně)
- notification email content (text; volitelné; předmět a tělo e-mailu odeslaného, když je u této
  reakce povolena e-mailová notifikace)
- notification zone content (text; volitelné; text a ikona notifikace v účtu/zóně vygenerované, když
  je u této reakce povolena notifikace v zóně)
- visibility toggles (booleovské hodnoty; volitelné; řídí, zda jsou fundraiserovi nebo patronovi v
  rámci této reakce zobrazeny související informace o žádosti/kampani)
- enabled (booleovská hodnota; povinné; výchozí Disabled; příznak publikace/povolení — viz Životní
  cyklus)

---

## Invarianty

- Reakce se pro žádost (Application, EN0001) provede pouze tehdy, pokud její nakonfigurovaný stav a
  role (a případně i iniciátor) odpovídají aktuálnímu kontextu změny stavu žádosti, a pouze pokud je
  povolena — řídící pravidlo pro fan-out reakcí při změně stavu viz BR-ApplicationStatusGovernance.
- Každá entita musí mít vždy platný stav životního cyklu (Disabled nebo Enabled).

Otevřeno — žádný dedikovaný dokument business rule v současnosti nestanovuje omezení jedinečnosti
pro kombinaci status/role/initiator (tj. zda se na stejnou změnu stavu žádosti může shodovat více
než jedna povolená reakce); viz Otevřené otázky.

---

## Vztahy

- EN0008 – User (vlastník záznamu reakce)
- EN0001 – Application (porovnávána podle stavu během fan-outu při změně stavu)
- EN0003 – ApplicationSession (vytvořena, pokud odpovídající reakce specifikuje session interface)
- EN0025 – ApplicationLog (odpovídající reakce vygeneruje záznam v logu během fan-outu)

---

## Otevřené otázky

1. Je porovnávání stavu pro jednu reakci jednohodnotové (jeden stav na záznam), takže pokrytí více
   stavů vyžaduje jeden řádek reakce na stav? Nepotvrzeno.
2. Vedle aktuálně používané konfigurace tlačítka akce (action button configuration) bylo pozorováno
   legacy/alternativní pole pro konfiguraci akce; které z nich řídí chování tlačítka, není zcela
   potvrzeno — legacy pole je do potvrzení třeba považovat za mrtvé/nepoužívané.
3. Některá pole týkající se notifikací se chovají odlišně od zbytku záznamu, pokud jde o historii
   revizí; zda je to záměrné, není potvrzeno.
4. Zda se na stejnou kombinaci status/role/initiator žádosti může legálně shodovat současně více než
   jedna povolená reakce, nepokrývá žádné doložené business rule.
