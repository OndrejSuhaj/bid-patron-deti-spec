---
doc_id: ES0007
title: Facebook
canonical_layer: ES
spec_type: external-system
status: canonical
modules: []
references:
  - ARCH0001
  - ARCH0002
  - FN0016
  - UC0013
---

# ES0007 – Facebook

## Účel

Facebook je integrován za účelem příjmu signálů o marketingových konverzích, aby bylo možné dokončené
dary zpětně přiřadit k reklamním kampaním, a — samostatně — měl sloužit jako zdroj příchozích
marketingových leadů pro vstup do platformy. Odchozí (outbound) cesta pro atribuci je funkční; příchozí
(inbound) cesta pro leady představuje potvrzenou mezeru v současném stavu (`ARCH0001` §5 řádek 8;
`FN0016`; `UC0013`).

---

## Přehled systému

Facebook je externí marketingová/reklamní platforma. Pro tuto integraci vystavuje tři odlišná rozhraní,
která jsou pro účely syntézy sloučena a považována za jeden externí systém (stejný dodavatel, sloučené
aliasy dle rozsahu syntézy):

- **Conversions API** — server-side endpoint, který přijímá signály o konverzích/událostech pro
  atribuci reklam;
- **Pixel** — mechanismus signálů o událostech na straně klienta, vložený do prohlížeče a vykreslovaný
  při načtení stránky;
- **Lead Ads webhook** — odběr (subscription) na straně inzerenta, který Facebook používá k odesílání
  zachycených odeslání leadů na přijímající platformu.

---

## Model integrace

Převážně **outbound (relay)**, s jedním neaktivním (dormant) inbound rozhraním:

- **Odchozí server-side relay** — Patronus přeposílá signály o konverzích/událostech do Facebook
  Conversions API z relay endpointu, který je spouštěn kvalifikující aktivitou na platformě (`UC0013`,
  dílčí tok odchozí konverzní události).
- **Odchozí client-side signál** — Facebook Pixel odesílá signály o událostech přímo z prohlížeče při
  vykreslení stránky, nezávisle na server-side relay (`UC0013`; seskupeno s Google Tag Manager pod
  stejnou analytickou hranicí, `ARCH0001` §5 řádek 9).
- **Příchozí webhook (pouze handshake odběru)** — Facebook může volat webhook endpoint Patronusu za
  účelem ověření odběru (subscription verification) pro Lead Ads (porovnání tokenu + echo výzvy
  challenge). Stejný endpoint je zároveň zamýšleným cílem pro příchozí volání doručující leady, avšak
  tato cesta neprovádí žádné ověření ani žádné zpracování — `Status: Planned / Not Implemented`
  (`ARCH0001` §5 řádek 8, HS16; `UC0013` AF2).

---

## Výměna dat

- **Odchozí:** signály o konverzních/atribučních událostech popisující kvalifikující aktivitu darování
  (např. třídy událostí dokončeného daru a související) spolu s identifikačními údaji potřebnými pro
  zpětné přiřazení (match-back attribution), odesílané do Conversions API; obdobné signály o událostech
  odesílané na straně klienta pomocí Pixelu při vykreslení stránky.
- **Příchozí (pouze handshake odběru):** ověřovací token a hodnota challenge vyměňované během
  nastavení odběru Lead Ads webhooku.
- **Příchozí (neimplementováno):** data odeslání leadu, která by Facebook doručoval přes Lead Ads
  webhook, jsou na endpointu přijata, ale nejsou načtena do žádného doménového záznamu — koncepčně by
  tato data, pokud by zpracování existovalo, naplnila Kontakt a/nebo Žádost (viz `EN0006`, `EN0009` pro
  entity na straně Patronusu; zde se neopakuje).

---

## Omezení

- **Bez dopadu na doménu při selhání outbound:** odchozí cesty relay a Pixel přenášejí pouze
  marketingové/analytické signály; jejich selhání způsobí ztrátu atribučního signálu bez jakéhokoli
  vlivu na doménový stav Patronusu (`ARCH0001` §5 řádky 8–9).
- **Příchozí zpracování leadů — potvrzeně neimplementováno:** každé příchozí volání doručující lead
  přes Lead Ads obdrží odpověď vypadající jako úspěšná, zatímco odeslaná data jsou tiše zahozena;
  Facebook není o selhání informován. `Status: Planned / Not Implemented` (`ARCH0001` §5 řádek 8, HS16;
  `UC0013` AF2).
- **Funkční je pouze rozhraní handshake odběru:** ze dvou odpovědností příchozího webhooku (ověřovací
  handshake, zpracování leadu) je jako funkční potvrzen pouze ověřovací handshake (`UC0013` AF1).
- **Hloubka evidence:** podmínky spouštění a obsah payloadu odchozího relay Conversions API nad rámec
  "kvalifikující konverzní události" jsou `Partial` — doloženo na úrovni indexu toků, nikoli hloubkovou
  analýzou (`FN0016`).
- Platí pouze pro současný stav; zde není uveden žádný cílový/budoucí návrh integrace.
