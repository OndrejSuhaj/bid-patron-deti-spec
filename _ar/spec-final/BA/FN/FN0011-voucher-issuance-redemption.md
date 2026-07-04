---
doc_id: FN0011
title: Voucher Issuance & Redemption
canonical_layer: FN
spec_type: functional-capability
status: canonical
modules: []
references:
  - UC0009
  - UC0006
  - EN0013
  - EN0009
  - EN0004
  - FN0007
  - FN0019
---

# FN0011 – Vystavení a uplatnění dárkového poukazu

## Účel

Spravuje instrument dárkového poukazu (Dobrošek) napříč jeho životním cyklem: dárkový poukaz je
vystaven a povýšen do stavu uhrazeno prostřednictvím nákupní transakce, poté je ověřen a uplatněn
příjemcem vůči zvolenému příběhu — čímž se z předplaceného, uhrazeného, ale dosud neuplatněného
dárkového poukazu stává uplatněný dar.

---

## Odpovědnosti

Tato schopnost odpovídá za:

- Ověření zadaného identifikátoru nebo kódu dárkového poukazu, vyžadující stav uhrazeno a dosud
  neuplatněný status, a vrácení kódu, expirace a hodnoty při úspěšném ověření.
- Uplatnění dárkového poukazu jeho navázáním na cílový příběh, jeho označením jako uplatněný
  s časovým razítkem uplatnění a volitelným zaznamenáním e-mailové adresy příjemce.
- Přesměrování původní nákupní transakce dárkového poukazu na cílový příběh uplatnění, díky čemuž
  je dar znovu přiřazen tomuto příběhu.
- Spuštění zprávy s potvrzením uplatnění (prostřednictvím FN0019) na e-mailovou adresu z nákupní
  transakce.
- Povýšení do stavu uhrazeno / připraveno k použití schopností zpracování plateb darů (FN0007), když
  jeho nákupní transakce dosáhne stavu PAID.

---

## Související případy užití

- UC0009 – Uplatnění / ověření dárkového poukazu
- UC0006 – Potvrzení platby (Callback platební brány) — zdroj vedlejšího efektu povýšení do stavu
  uhrazeno (UC0006.4)

---

## Související entity

- EN0013 – Dárkový poukaz
- EN0009 – Transakce
- EN0004 – Příběh

---

## Integrace

Žádná přímá integrace s externím systémem. E-mail s potvrzením uplatnění je odesílán prostřednictvím
schopnosti transakčního zasílání zpráv (FN0019), nikoli přímo touto schopností. (Viz
ARCH0002_ContextInteractionMap pro krajinu integrací platformy.)

---

## Omezení

- Kód dárkového poukazu nemá vynucené omezení jedinečnosti; uplatnění podle kódu se může přiřadit
  k libovolnému odpovídajícímu záznamu v případě duplicit — Partial / Hypothesis, doloženo jako riziko
  kvality dat, nikoli jako navržené chování (viz UC0009 AF3).
- Ověření i uplatnění jsou dostupné anonymním, neautentizovaným zákazníkům (viz zjištění FLW0018
  o anonymním přístupu); neúspěšné výsledky jsou komunikovány v rámci odpovědi (stav
  neplatný/neúspěšný v odpovědi), nikoli prostřednictvím odlišujících chybových odpovědí (viz UC0009
  AF1/AF2). Hypothesis — expozice vůči brute-force / omezení frekvence požadavků Not evidenced
  in current sources: v prověřených důkazech o toku nebyl nalezen žádný mechanismus omezování
  (throttling).
- Sekvence kontrola-poté-aktualizace při uplatnění není chráněna proti souběhu, takže dva téměř
  souběžné požadavky na uplatnění téhož kódu dárkového poukazu mohou oba projít kontrolou
  „dosud neuplatněno" dříve, než je uložena kterákoli z aktualizací — Partial / Hypothesis, doloženo
  jako riziko souběhu (race condition), nikoli jako potvrzené chráněné chování (viz UC0009 AF4).
- Povýšení dárkového poukazu do stavu uhrazeno / připraveno k použití je zcela řízeno dosažením
  stavu PAID jeho nákupní transakcí (FN0007 / UC0006.4); tato schopnost sama o sobě nerozhoduje
  o výsledcích plateb.
