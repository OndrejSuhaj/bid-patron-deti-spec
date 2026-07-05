---
doc_id: MSG0024
title: Voucher Purchase Confirmation
layer: MSG
spec_type: transactional-message
status: imported
modules: []
trigger:
  - UC0006
references:
  - EN0013
  - EN0009
  - EN0022
  - ES0006
  - UC0009  # contrast only — redemption-confirmation intent, does NOT trigger this message
---

# MSG0024 – Potvrzení nákupu dárkového poukazu

## Účel

Potvrdit, že nákup dárkového poukazu (Dobrošek) byl uhrazen, a doručit samotný poukaz — jeho kód a
informace potřebné k jeho uplatnění — příjemci poukazu (UC0006.4 krok 6). Jde o protějšek poukazu na
straně nákupu; tato zpráva se liší od pozdější zprávy potvrzující uplatnění poukazu, která se odesílá
ve chvíli, kdy je poukaz skutečně uplatněn na příběh (UC0009) — jde o samostatný záměr zprávy, který
tento dokument nepokrývá.

---

## Spouštěč

UC0006 (Potvrzení platby — callback platební brány), sdílený krok s vedlejším efektem UC0006.4 —
spouští se, když transakce (EN0009) financující nákup poukazu (EN0013) dosáhne svého prvního
potvrzení PAID a systém povýší odpovídající neuhrazený poukaz na stav uhrazeno/připraveno k použití
(UC0006.4 kroky 5–6). SC-10F (kroky 2–3) potvrzuje výsledek: poté, co patron uhradí poukaz
prostřednictvím webového nákupního procesu, je poukaz nastaven na PAID a potvrzení nákupu je odesláno
(příjemci poukazu, dle UC0006.4 krok 6).

Evidence: UC0006 krok UC0006.4.5–6; SC-10F kroky 2.0–3.0 (`intake/test-scenarios/test-scenarios.md`).

---

## Příjemci

- **Příjemce poukazu** — e-mail, přes ES0006 (Mautic). Dle UC0006.4 krok 6 se potvrzení nákupu
  poukazu odesílá příjemci poukazu — tedy na `recipient_email` / `recipient_name` zaznamenané na
  poukazu (EN0013), odlišnému od patrona, který nákup provedl a je vlastníkem financující transakce
  (EN0009). Tohoto adresáta potvrzuje i sesterský dokument MSG0019, který uvádí potvrzení nákupu
  poukazu jako adresované příjemci poukazu. Následné uplatnění poukazu na příběh je samostatný,
  pozdější krok (UC0009), mimo rozsah této zprávy.
- Nákup poukazu a jeho stav jsou dále viditelné nakupujícímu patronovi v zóně patrona (v rámci
  aplikace; SC-10F krok 10), což není součástí této transakční zprávy.
- Pro tuto zprávu není doložena žádná obsahová variance mezi CZ/RO/MD; samotný nákup poukazu je
  doložen pouze pro cestu CZ/ComGate.

---

## Obsah zprávy

Koncepčně každá instance této zprávy nese:

- Potvrzení, že nákup poukazu byl uhrazen (poukaz, EN0013, povýšen na stav uhrazeno/připraveno
  k použití).
- Kód poukazu potřebný k jeho darování nebo uplatnění.
- Hodnotu poukazu ("Hodnota") a jeho platnost.
- Informaci, jak lze poukaz předat příjemci a následně jej uplatnit/ověřit (tedy že jej lze uplatnit
  na vybraný příběh prostřednictvím procesu uplatnění, UC0009).
- Pokud byl v rámci jedné transakce vygenerován více než jeden poukaz, může být ke zprávě přiložen
  příslušný doklad (doklady) k poukazu (poukazům) jako příloha.
- Zpráva neobsahuje žádné údaje o kartě, bankovním účtu ani jiném platebním nástroji.

Tento kanonický dokument nestanovuje pevný text předmětu, formátování těla zprávy ani strukturu
šablony — konkrétní znění je instanční/konfigurační data a je mimo rozsah vrstvy MSG (viz omezení
v rules-MSG.md). Každé odeslání je archivováno jako záznam EmailArchive (EN0022).

---

## Poznámky

- Liší se od zprávy potvrzující uplatnění poukazu, která se odesílá na e-mailovou adresu nákupní
  transakce ve chvíli, kdy příjemce uplatní poukaz na příběh (UC0009.2 krok 8) — jde o samostatný
  záměr zprávy, který zde není dokumentován.
- Liší se od obecného poděkovacího potvrzení o uhrazení daru (MSG0019), které je adresováno patronům
  u nevoucherových způsobů darování.
- Liší se od interní, pouze provozní notifikace o události poukazu na ES0015 (Slack): jde o
  samostatný kanál, který není určen uživatelům, ale provoznímu personálu, a je mimo rozsah této MSG.
- Zpráva s upomínkou na vypršení platnosti poukazu **není doložena** jako aktivní, v současnosti
  spouštěné chování — entita poukazu (EN0013) obsahuje časové pole `reminded`, které naznačuje
  existenci úlohy pro upomínku, avšak žádný mechanismus odeslání pro ni nebyl v analyzovaných
  procesech nalezen. Uncertain — vyloučeno z tohoto dokumentu do doby, než bude dostupný další důkaz
  (viz EN0013 Open Questions).
- Evidence Level: Confirmed pro mechanismus spouštění (povýšení navázaného poukazu na PAID) a pro
  adresáta jako příjemce poukazu (UC0006.4 krok 6; potvrzeno MSG0019; EN0013 `recipient_email` /
  `recipient_name`). Partial pro přesné rozdělení koncepčního obsahu v případě, že jedna transakce
  vyprodukuje více poukazů, protože chování přílohy s dokladem u více poukazů je doloženo na úrovni
  schopnosti, ale jeho přesná prezentace v této zprávě není z citovaných zdrojů plně zřejmá.
