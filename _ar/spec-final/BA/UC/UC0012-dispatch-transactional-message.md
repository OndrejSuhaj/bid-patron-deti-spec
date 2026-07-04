---
doc_id: UC0012
title: Dispatch Transactional Message
canonical_layer: UC
spec_type: use-case
status: canonical
modules: []
---

# UC0012 — Odeslání transakční zprávy

## Hlavička

| Pole | Hodnota |
|---|---|
| UC ID | UC0012 |
| Název | Dispatch Transactional Message |
| Bounded Context | C8 |
| Primární aktér(ři) | System |
| Typ spouštění | Interní (volá jej mnoho kontextů) |

## Aktéři a odpovědnosti

- **System** — orchestrátor zasílání zpráv: validuje příjemce, dohledává šablonu specifickou pro danou zemi, archivuje každý pokus o odeslání, aplikuje bránu odesílání podle prostředí (environment send-gate) a předává zprávu odchozímu transportu.
- **Integration(Mautic)** — skutečný odchozí transport pro šablonované transakční zprávy: vytvoří nebo aktualizuje CRM kontakt pro příjemce a doručí mu šablonovanou zprávu. (Ačkoliv je volán jako schopnost „SmartMailing“, nepoužívá se přímý SMTP transport — transportem je Mautic.)
- **External(WhoisXML)** — volitelná kontrola platnosti domény zmiňovaná na úrovni skladby služeb (service-composition); nebyl nalezen žádný důkaz o zapojení do flow odesílání (viz Alternative Flows / Evidence Level).

## Záměr

Doručit jednu šablonovanou transakční zprávu příjemci jménem libovolného volajícího business kontextu (životní cyklus žádosti, dary, kampaně, smlouvy, účty, GDPR atd.), přičemž je vždy zachován trvalý záznam o pokusu o odeslání bez ohledu na to, zda byla zpráva skutečně odeslána.

## Předpoklady

- Volající kontext rozhodl, že musí být odeslána transakční zpráva, a dodává: adresu(y) příjemce, název šablony, parametry/argumenty zprávy a volitelně adresu pro odpověď (reply-to) a přílohy.
- Poštovní transport je nakonfigurován (přihlašovací údaje pro transport postavený na Mauticu); pokud nakonfigurován není, samotné odeslání později selže, ale archivace i tak proběhne.
- Očekává se, že Žádost (EN0001), ke které se tato zpráva vztahuje, je součástí argumentů volání, protože záznam EmailArchive (EN0022) vyžaduje odkaz na žádost.

## Hlavní tok

### UC0012.1 — Dohledání šablony a validace příjemců
1. System: Přijme požadavek na odeslání od volajícího kontextu s příjemcem(i), názvem šablony, argumenty, volitelnou adresou pro odpověď (reply-to) a přílohami.
2. System: Normalizuje vstup příjemců do seznamu adres.
3. System: Validuje adresu příjemce zadanou jako jeden řetězec z hlediska základní platnosti e-mailu; příjemci zadaní jako seznam touto validací neprocházejí.
4. System: Dohledá název šablony v mapě šablon pro aktuálně nakonfigurovanou zemi (pro každou zemi existuje samostatná mapa).
5. System: Pokud název šablony není v mapě dohledané země nalezen, zaznamená chybu a zastaví odesílání pro daný požadavek, bez odeslání či archivace.

### UC0012.2 — Archivace a odeslání pro každého příjemce
1. System: Sestaví hodnoty pro nahrazení tokenů/zástupných symbolů z dodaných argumentů zprávy.
2. System: Rozdělí seznam příjemců do dávek ke zpracování.
3. System: Pro každého příjemce vytvoří a uloží záznam EmailArchive (EN0022) zachycující předmět, výslednou adresu příjemce/odesílatele, vykreslený obsah, název šablony, serializované argumenty a propojenou Žádost (EN0001) a kampaň, nezávisle na tom, zda byla zpráva skutečně odeslána.
4. System: Vyhodnotí bránu odesílání (send gate) — k samotnému odeslání přistoupí pouze pokud je prostředí produkční, nebo pokud adresa příjemce odpovídá internímu povolovacímu seznamu (allow-list); jinak odeslání pro tohoto příjemce přeskočí, ale záznam archivu zachová.
5. Integration(Mautic): Vytvoří nebo aktualizuje CRM kontakt pro adresu příjemce.
6. Integration(Mautic): Odešle danému kontaktu vyřešenou šablonu se sestavenými tokeny a případnými přílohami.
7. System: Pokud se nepodařilo CRM kontakt dohledat, zaznamená selhání do logu zasílání zpráv.

## Alternativní toky

### AF1 — Neznámý název šablony
1. System: Vyhledá název šablony v mapě šablon dohledané země a nenajde shodu.
2. System: Zaloguje selhání a zastaví se, aniž by vytvořil záznam EmailArchive (EN0022) a aniž by kontaktoval Integration(Mautic).

Výsledek: Zpráva nebyla odeslána, archiv nebyl zapsán; pro tento pokus o odeslání existuje pouze záznam v logu.

### AF2 — Neprodukční / nepovolený příjemce (potlačené odeslání)
1. System: Dokončí validaci příjemce a dohledání šablony jako v UC0012.1.
2. System: Archivuje záznam EmailArchive (EN0022) pro příjemce jako v kroku 3 UC0012.2.
3. System: Vyhodnotí bránu odesílání a zjistí, že prostředí není produkční a příjemce není na povolovacím seznamu (allow-list).
4. System: Přeskočí volání Integration(Mautic) pro tohoto příjemce.

Výsledek: Záznam EmailArchive (EN0022) existuje, ale zpráva nebyla skutečně odeslána; záznam archivu nerozlišuje tento potlačený stav od skutečně doručené zprávy.

### AF3 — Kontrola platnosti domény (nepotvrzeno)

> Evidence Level pro tento dílčí tok: Hypothesis — Not evidenced in the assigned flow dossier (FLW0019). Uvedeno pouze jako součást cílové služby (WhoisXML-DomainCheck-Adapter) v inventáři skladby služeb (service-composition); v natěženém evidenčním materiálu nebyl nalezen žádný krok odesílání, spouštěcí podmínka ani výsledek pro kontrolu platnosti domény.

1. External(WhoisXML): (Nepotvrzeno) Validace domény v adrese příjemce nebo odesílatele před odesláním nebo v jeho průběhu.

Výsledek: Nepotvrzeno — v dostupných dossierech se nepodařilo doložit žádný vliv na hlavní tok.

## Postpodmínky

- Pro každého příjemce a každý pokus o odeslání, který prošel dohledáním šablony, existuje právě jeden záznam EmailArchive (EN0022), bez ohledu na to, zda byla zpráva skutečně odeslána.
- U produkčních nebo povolených (allow-listed) příjemců existuje (vytvořený nebo aktualizovaný) CRM kontakt v Integration(Mautic) a šablonovaná zpráva byla předána tomuto transportu.
- U potlačených nebo neúspěšných odeslání záznam EmailArchive (EN0022) přetrvává, aniž by obsahoval rozlišující příznak výsledku doručení — stav odesláno/chyba se po vytvoření dále nesleduje.
- Pokusy o odeslání s nedohledatelným názvem šablony nezanechávají žádný záznam EmailArchive (EN0022), pouze záznam v logu.

## Trasovatelnost (Traceability)

Cílové SRV:
- Transactional-Messaging-Orchestrator
- Email-Adapter
- WhoisXML-DomainCheck-Adapter
- Mautic-CRM-Adapter

EN entity:
- EN0022 EmailArchive — záznam pro každého příjemce a každý pokus o odeslání, vytvářený v UC0012.2; centrální datová stopa tohoto UC

Integrační hranice:
- Integration(Mautic) — vytvoření/aktualizace CRM kontaktu + odeslání šablonované zprávy (transport pro všechna odeslání v tomto UC)
- External(WhoisXML) — uveden pouze na úrovni skladby služeb (service-composition); v toku tohoto UC nemá potvrzenou roli (viz AF3)

Evidence Flow (doklad flow):
- FLW0019 (Transactional email dispatch)

## Úroveň evidence (Evidence Level)

Confirmed pro UC0012.1/.2 a AF1/AF2 — přímo podloženo FLW0019 (dossier s úrovní jistoty Confirmed) a EN0022 (evidence životního cyklu a polí EmailArchive); mapování na SRV odpovídá řádkům UC-srv-traceability.md a SRV-target-list.md pro UC0012. Hypothesis pro AF3 (kontrola domény WhoisXML) — adaptér je u tohoto UC uveden v SRV-target-list.md, ale žádný odpovídající krok, spouštěč ani výsledek se neobjevuje ve FLW0019 ani v žádném jiném přiřazeném dossieru.
