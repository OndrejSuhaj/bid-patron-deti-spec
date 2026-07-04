---
doc_id: MSG0026
title: Contract Manager-Check Notice
canonical_layer: MSG
spec_type: transactional-message
status: canonical
modules: []
trigger:
  - UC0004
references:
  - EN0011
  - EN0012
  - EN0001
  - EN0022
  - ES0006
---

# MSG0026 – Notifikace o kontrole smlouvy manažerem

## Účel

Informovat interního příjemce provádějícího kontrolu smlouvy o tom, že pro žádost (EN0001) byla právě
vygenerována smlouva (EN0011) a je připravena k jeho kontrole, a poskytnout mu vše potřebné k otevření
dokumentu a k jeho následnému předání fundraiserovi k podpisu, pokud je s obsahem spokojen. Na rozdíl
od ostatních zpráv v této vrstvě není příjemcem strana typu Rodič/Patron/Dárce, ale interní provozní
role — přesto se jedná o skutečně uživatelsky adresovaný transakční e-mail (na rozdíl od provozních
upozornění na kanálech Slack/Telegram), určený konkrétní kontrolní funkci, nikoli straně případu.

---

## Spouštěč (Trigger)

UC0004 (Správa smlouvy a podpisu) — UC0004.2, krok 2 ("odeslat smlouvu manažerovi"): jakmile Admin
spustí krok kontroly manažerem u nově vytvořené smlouvy, systém odešle tuto notifikaci konfigurovanému
příjemci provádějícímu kontrolu smlouvy a posune stav žádosti tak, aby odrážel, že smlouva je
v manažerské kontrole (list Notification Matrix SC-8A, krok 5: "Ops Mgr vytvoří darovací smlouvu
v systému pro naplněný příběh" → stav `contract` / "Smlouva ke schválení").

Úroveň důkazu: Confirmed — spouštěcí krok, jeho pozice v dílčím toku smlouvy i přechod stavu jsou
doloženy v UC0004.2 a v podkladovém dokumentu toku FLW0008.

---

## Příjemci

- **Příjemce provádějící kontrolu smlouvy** — jedna konfigurovaná interní adresa reprezentující
  manažerskou/kontrolní funkci pro kontrolu smlouvy (nikoli role Rodiče, Patrona či Dárce vázaná na
  konkrétní případ) — pouze e-mail, prostřednictvím ES0006 (Mautic).
- Pro tohoto příjemce není doložena žádná varianta notifikace v zóně — kontrolní funkce působí mimo
  samoobslužné zóny Rodiče/Patrona, takže tato zpráva je pouze e-mailová.
- Kromě obecného rozlišení šablon podle země zaznamenaného na úrovni capability (FN0019) není doložena
  žádná odchylka obsahu pro RO/MD — samotný příjemce je jedna konfigurovaná adresa bez ohledu na
  zemi/tenanta.

---

## Obsah zprávy

Z koncepčního hlediska každé odeslání této zprávy obsahuje:

- Sdělení, že pro konkrétní žádost (EN0001) byla vygenerována smlouva (EN0011) a je připravena ke
  kontrole příjemcem.
- Identifikační údaje pro smlouvu/žádost/podkladový příběh, aby příjemce mohl dohledat správný případ.
- Odkaz ke stažení/zobrazení vygenerovaného dokumentu smlouvy pro účely kontroly.
- Odkaz nebo akci umožňující příjemci po dokončení kontroly odeslat smlouvu dále fundraiserovi
  (protistranná akce zdokumentovaná jako UC0004.2, krok 4).

Zde není uveden žádný pevný text předmětu, formátování těla zprávy ani struktura šablony — konkrétní
znění je instanční data (viz omezení v rules-MSG.md).

Každé odeslání je archivováno jako záznam EmailArchive (EN0022), a to bez ohledu na to, zda k
samotnému odeslání skutečně došlo, v souladu s obecným chováním platformy pro archivaci e-mailů (viz
sdílená výhrada k archivaci v MSG0005).

---

## Poznámky

- Doručení probíhá na bázi best-effort: pokud v okamžiku odeslání není k dispozici adresa příjemce
  provádějícího kontrolu nebo vygenerované PDF smlouvy, stav žádosti se přesto posune do stavu
  manažerské kontroly, aniž by byla odeslána notifikace — jde o tichou mezeru (UC0004 AF2; FN0009).
  Tento dokument zprávy popisuje zamýšlený stav pro případ, že jsou k dispozici obě položky; chybová
  cesta je chování náležející do UC/FN a je zde pouze citováno, nikoli znovu popisováno.
- Odlišné od legacy větve notifikace fundraisera ve stejném dílčím toku (UC0004.2, krok 7 / UC0004
  AF1), kde je u tenantů bez zapnutého elektronického podpisu vygenerovaná smlouva místo toho odeslána
  přímo fundraiserovi, aniž by nejprve prošla tímto krokem manažerské kontroly; jde o samostatnou
  problematiku zprávy, kterou tento dokument nepokrývá.
- Úroveň důkazu: Confirmed pro spouštěč, roli příjemce a prvky obsahu (UC0004, FLW0008, Notification
  Matrix SC-8A). Partial pro to, zda existují nějací sekundární/záložní příjemci kontroly nad rámec
  jedné konfigurované adresy — nedoloženo.
