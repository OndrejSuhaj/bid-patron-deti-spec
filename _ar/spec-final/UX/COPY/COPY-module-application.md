---
doc_id: COPY-module-application
title: Application Intake — Role Choice, Contact/Consent Gate & 5-Step Wizard
layer: COPY
spec_type: copy
scope: module-application
modules: []
language: cs
status: imported
references:
  - WIRE0005
  - WIRE0006
  - WIRE0007
  - WIRE0008
  - WIRE0009
  - WIRE0010
  - WIRE0011
  - UC0001
  - EN0001
  - EN0002
  - EN0033
---

# COPY-module-application – Vstup žádosti — Volba role, brána kontakt/souhlas a 5-krokový wizard

## Účel

Tento dokument přepisuje uživatelsky viditelný český text pro veřejnou vstupní plochu Žádosti
(Application): landing s volbou role (`S006` / `WIRE0005`), bránu kontakt/souhlas "Údaje o žadateli"
(`S007` / `WIRE0006`) a pětikrokový veřejný wizard na `/zadost-formular` (`S008a`–`S008e` /
`WIRE0007`–`WIRE0011`). Všechny obrazovky realizují `UC0001` (Submit Application) pro roli
fundraisera (žadatele). Text je přepsán **verbatim** ze screenshotů `_ar/prtsc/**` a z
`_ar/evidence/ui/ui-observed-areas.md`; nic není parafrázováno ani domýšleno. Tón je v celém rozsahu
2. osoba formálně-neformální čeština (tvar "vy"), přímé oslovení ("vám", "vaše dítě", "váš Patron").

`S006` (`WIRE0005`) **nemá zachycený screenshot** — text jeho karet je Evidence Pending a není zde
přepsán jako potvrzený text (viz Otevřené otázky). Všechny ostatní obrazovky v tomto rozsahu mají
přímý screenshotový důkaz.

---

## Popisky

| Klíč | Text | Použití (odkaz WIRE/COMP) |
|---|---|---|
| `module-application.contact-gate.heading` | `Začneme tím, že nám sdělíte váš telefon a e-mail` | `WIRE0006` (H1) |
| `module-application.contact-gate.panel-heading` | `Údaje o Vás` | `WIRE0006` (nadpis panelu formuláře) |
| `module-application.contact-gate.email-placeholder` | `E-mail` | `WIRE0006` (placeholder pole e-mail sloužící jako popisek) |
| `module-application.contact-gate.phone-prefix` | `+420` | `WIRE0006` (fixní předvolba pole telefon) |
| `module-application.contact-gate.phone-placeholder` | `Telefon` | `WIRE0006` (placeholder pole telefon sloužící jako popisek) |
| `module-application.contact-gate.faq-heading` | `Často kladené otázky` | `WIRE0006` (nadpis sekce FAQ) |
| `module-application.contact-gate.faq-question-1` | `Proč musí mít každé dítě svou vlastní žádost o dar?` | `WIRE0006` (položka akordeonu FAQ, sbaleno) |
| `module-application.contact-gate.faq-question-2` | `Proč musí mít každý příběh svého Patrona?` | `WIRE0006` (položka akordeonu FAQ, sbaleno) |
| `module-application.step1.stepper-1` | `Příběh` | `WIRE0007`/`WIRE0008`/`WIRE0009`/`WIRE0010`/`WIRE0011` (popisek stepperu, krok 1); `COMP0005` |
| `module-application.step1.stepper-2` | `Dar` | `WIRE0007`–`WIRE0011` (popisek stepperu, krok 2); `COMP0005` |
| `module-application.step1.stepper-3` | `O Vás` | `WIRE0007`–`WIRE0011` (popisek stepperu, krok 3); `COMP0005` |
| `module-application.step1.stepper-4` | `Patron` | `WIRE0007`–`WIRE0011` (popisek stepperu, krok 4); `COMP0005` |
| `module-application.step1.stepper-5` | `Přílohy` | `WIRE0007`–`WIRE0011` (popisek stepperu, krok 5); `COMP0005` |
| `module-application.step1.heading` | `Krok 1: Váš příběh` | `WIRE0007` (titulek stránky) |
| `module-application.step1.child-name-section-heading` | `Dovolte nám vaše dítě lépe poznat` | `WIRE0007` (nadpis sub-zóny B) |
| `module-application.step1.child-firstname-heading` | `Jméno a příjmení dítěte` | `WIRE0007` (popisek nad dvojicí Jméno/Příjmení; potvrzeno na obrazovce) |
| `module-application.step1.child-firstname-placeholder` | `Jméno` | `WIRE0007` (pole křestního jména dítěte) |
| `module-application.step1.child-lastname-placeholder` | `Příjmení` | `WIRE0007` (pole příjmení dítěte) |
| `module-application.step1.child-rc-heading` | `Rodné číslo dítěte (cizinec: číslo pojištěnce)` | `WIRE0007` (popisek pole, dvojí význam) |
| `module-application.step1.child-like-heading` | `Jaké je vaše dítě a co má rádo?` | `WIRE0007` (popisek pole) |
| `module-application.step1.health-checkbox-label` | `Je Vaše dítě zdravotně znevýhodněné?` | `WIRE0007` (popisek checkboxu) |
| `module-application.step1.health-problems-heading` | `S čím se vaše dítě potýká a jakou potřebuje pomoc?` | `WIRE0007` (nadpis sub-zóny D) |
| `module-application.step1.health-problems-subquestion` | `Má vaše dítě specifický zdravotní problém?` | `WIRE0007` (tučný úvod uvnitř sub-zóny D) |
| `module-application.step1.prior-collection-heading` | `Mate nebo měli jste sbírku u jiné nadace v posledních 6 měsících?` | `WIRE0007` (popisek radio skupiny; překlep "Mate" zachován verbatim) |
| `module-application.step1.prior-collection-option-yes` | `ANO` | `WIRE0007` (volba radio) |
| `module-application.step1.prior-collection-option-no` | `NE` | `WIRE0007` (volba radio, výchozí) |
| `module-application.step1.nationality-heading` | `Žádám o pomoc pro dítě, které nemá českou národnost` | `WIRE0007` (popisek radio skupiny) |
| `module-application.step1.nationality-option-yes` | `ANO` | `WIRE0007` (volba radio) |
| `module-application.step1.nationality-option-no` | `NE` | `WIRE0007` (volba radio, výchozí) |
| `module-application.step2.heading` | `Krok 2: Dar, kterým vám pomůžeme` | `WIRE0008` (titulek stránky) |
| `module-application.step2.category-picker-heading` | `Rychlá volba daru:` | `WIRE0008` (nadpis seznamu kategorií) |
| `module-application.step2.category-1` | `ŠVP, jazykový kurz, školní výlety` | `WIRE0008` (řádek kategorie daru) |
| `module-application.step2.category-2` | `Lyžařský kurz` | `WIRE0008` (řádek kategorie daru) |
| `module-application.step2.category-3` | `Kroužky, soustředění a vybavení pro ně` | `WIRE0008` (řádek kategorie daru) |
| `module-application.step2.category-4` | `Tábory – pobytové, příměstské` | `WIRE0008` (řádek kategorie daru) |
| `module-application.step2.category-5` | `Školné a internát` | `WIRE0008` (řádek kategorie daru) |
| `module-application.step2.category-6` | `Notebook` | `WIRE0008` (řádek kategorie daru) |
| `module-application.step2.category-7` | `Automobil jako zdravotní pomůcka` | `WIRE0008` (řádek kategorie daru) |
| `module-application.step2.category-8` | `Pomůcky a služby pro zdravotně znevýhodněné děti` | `WIRE0008` (řádek kategorie daru) |
| `module-application.step2.category-9` | `Balík školních potřeb` | `WIRE0008` (řádek kategorie daru) |
| `module-application.step2.org-name-heading-default` | `Název a adresa školy poskytující aktivity` | `WIRE0008` (obecný/výchozí popisek pole kategorie) |
| `module-application.step2.org-name-placeholder-default` | `Název a adresa školy` | `WIRE0008` (obecný placeholder pole) |
| `module-application.step2.org-name-heading-tabory` | `Název a adresa organizátora tábora` | `WIRE0008` (přeznačení podle kategorie, vybráno "Tábory"; přepis `EN0033`) |
| `module-application.step2.contact-person-heading` | `Kontaktní osoba` | `WIRE0008` (popisek pole) |
| `module-application.step2.contact-person-placeholder` | `Kontaktní osoba` | `WIRE0008` (placeholder pole) |
| `module-application.step2.contact-phone-heading` | `Telefonní číslo na kontaktní osobu` | `WIRE0008` (popisek pole) |
| `module-application.step2.contact-phone-placeholder` | `Telefonní číslo` | `WIRE0008` (placeholder pole) |
| `module-application.step2.contact-email-heading` | `E-mail na kontaktní osobu` | `WIRE0008` (popisek pole) |
| `module-application.step2.contact-email-placeholder` | `E-mail` | `WIRE0008` (placeholder pole) |
| `module-application.step2.gift-help-heading` | `Jak dar dítěti konkrétně pomůže?` | `WIRE0008` (popisek textarey) |
| `module-application.step2.attachment-heading-default` | `Zde přiložte přihlášku na školní akci nebo informační leták` | `WIRE0008` (obecný popisek dropzony pro přílohu) |
| `module-application.step2.attachment-heading-tabory` | `Zde přiložte přihlášku na tábor` | `WIRE0008` (přeznačení podle kategorie, vybráno "Tábory") |
| `module-application.step2.upload-dropzone-instruction` | `Sem přetáhněte soubory, které chcete do žádosti nahrát nebo je vyberte v počítači` | `WIRE0008`; `COMP0007` |
| `module-application.step2.tabory-term-heading` | `V jaké termínu se tábor uskuteční` | `WIRE0008` (extra pole podle kategorie, "Tábory"; překlep "termínu" zachován verbatim) |
| `module-application.step2.tabory-term-placeholder` | `Termín` | `WIRE0008` (placeholder extra pole) |
| `module-application.step2.total-cost-heading` | `Celková částka na pořízení daru` | `WIRE0008` (popisek měnového pole) |
| `module-application.step2.total-cost-suffix` | `Kč` | `WIRE0008` (měnová přípona) |
| `module-application.step2.category-expand-cta` | `Více informací` | `WIRE0008` (přepínač rozbalení u řádku) |
| `module-application.step2.category-collapse-cta` | `Zobrazit méně` | `WIRE0008` (přepínač sbalení u řádku) |
| `module-application.step2.category-select-cta` | `Vybrat` | `WIRE0008` (akce výběru u řádku) |
| `module-application.step2.faq-heading` | `Často kladené otázky` | `WIRE0008` (nadpis sekce FAQ) |
| `module-application.step2.faq-question-1` | `Proč vyžadujeme po všech obdarovaných důkaz o tom, jak dar využívají?` | `WIRE0008` (položka akordeonu FAQ, sbaleno) |
| `module-application.step3.heading` | `Krok 3: Údaje o vás` | `WIRE0009` (titulek stránky) |
| `module-application.step3.name-heading` | `Vaše jméno a příjmení` | `WIRE0009` (popisek dvojice polí) |
| `module-application.step3.firstname-placeholder` | `Jméno` | `WIRE0009` (placeholder pole) |
| `module-application.step3.lastname-placeholder` | `Příjmení` | `WIRE0009` (placeholder pole) |
| `module-application.step3.rc-heading` | `Rodné číslo rodiče (cizinec: číslo pojištěnce)` | `WIRE0009` (popisek pole) |
| `module-application.step3.address-heading` | `Adresa vašeho trvalého bydliště` | `WIRE0009` (nadpis blok adresy) |
| `module-application.step3.street-placeholder` | `Ulice a číslo popisné` | `WIRE0009` (placeholder pole) |
| `module-application.step3.city-placeholder` | `Město` | `WIRE0009` (placeholder pole) |
| `module-application.step3.zip-placeholder` | `PSČ` | `WIRE0009` (placeholder pole) |
| `module-application.step3.mailing-address-checkbox-label` | `Zastihnete mě na jiné než trvalé adrese.` | `WIRE0009` (popisek checkboxu) |
| `module-application.step3.single-parent-checkbox-label` | `Jsem samoživitel` | `WIRE0009` (popisek checkboxu) |
| `module-application.step3.contact-heading` | `Vaše kontaktní údaje` | `WIRE0009` (nadpis bloku kontaktu) |
| `module-application.step3.email-placeholder` | `E-mail` | `WIRE0009` (placeholder pole; pozorováno vyplněné testovacími daty `o.suhaj@gmail.com` — šum, nikoli text) |
| `module-application.step3.phone-prefix` | `+420` | `WIRE0009` (fixní předvolba telefonu) |
| `module-application.step3.employed-heading` | `Jste zaměstnán? (pokud nejste zaměstnán, doložte evidenci na ÚP v kroku 5.)` | `WIRE0009` (popisek radio skupiny s inline mezikrokovým důsledkem) |
| `module-application.step3.employed-option-yes` | `ANO` | `WIRE0009` (volba radio) |
| `module-application.step3.employed-option-no` | `NE` | `WIRE0009` (volba radio, výchozí) |
| `module-application.step4.heading` | `Krok 4: Údaje o vašem Patronovi` | `WIRE0010` (titulek stránky) |
| `module-application.step4.name-heading` | `Jméno a příjmení vašeho Patrona` | `WIRE0010` (popisek dvojice polí) |
| `module-application.step4.firstname-placeholder` | `Jméno` | `WIRE0010` (placeholder pole) |
| `module-application.step4.lastname-placeholder` | `Příjmení` | `WIRE0010` (placeholder pole) |
| `module-application.step4.relationship-heading` | `V jakém vztahu je k vám nebo k vaší rodině?` | `WIRE0010` (popisek rozevíracího seznamu) |
| `module-application.step4.relationship-option-familyfriend` | `Rodinný známý` | `WIRE0010` (jediná pozorovaná volba rozevíracího seznamu; úplný seznam voleb nedoložen) |
| `module-application.step4.contact-heading` | `Kontaktní údaje na Patrona` | `WIRE0010` (nadpis bloku kontaktu) |
| `module-application.step4.email-placeholder` | `E-mail` | `WIRE0010` (placeholder pole) |
| `module-application.step4.phone-prefix` | `+420` | `WIRE0010` (fixní předvolba telefonu) |
| `module-application.step4.phone-placeholder` | `Telefon` | `WIRE0010` (placeholder pole) |
| `module-application.step5.heading` | `Krok 5: Přílohy a fotografie` | `WIRE0011` (titulek stránky) |
| `module-application.step5.images-section-heading` | `Povinné obrazové přílohy` | `WIRE0011` (nadpis sekce uploadu 1) |
| `module-application.step5.id-section-heading` | `Fotka Vašeho dokladu totožnosti s fotkou (občanský průkaz, pas):` | `WIRE0011` (nadpis sekce uploadu 2) |
| `module-application.step5.birth-cert-section-heading` | `Fotka nebo kopie rodného listu dítěte, případně rozhodnutí soudu o svěření do péče.` | `WIRE0011` (nadpis sekce uploadu 3) |
| `module-application.step5.upload-dropzone-instruction` | `Sem přetáhněte soubory, které chcete do žádosti nahrát nebo je vyberte v počítači.` | `WIRE0011`; `COMP0007` |
| `module-application.step5.upload-example-badge` | `PŘÍKLAD` | `WIRE0011` (překryv ukázkové miniatury, všechny tři dropzony) |
| `module-application.step5.referral-heading` | `Odkud jste se dozvěděli o projektu Patron dětí?` | `WIRE0011` (popisek rozevíracího seznamu) |
| `module-application.step5.exit-modal-heading` | `Chystáte se opustit žádost.` | `WIRE0011` (nadpis modálu potvrzení odchodu) |

---

## Nápovědné texty (Helper Texts)

| Klíč | Text | Použití |
|---|---|---|
| `module-application.contact-gate.privacy-helper` | `Kontaktní údaje nikde nezveřejňujeme ani je neposkytujeme komukoli dalšímu.` | `WIRE0006` (pás ikony/nadpisu, řádek 1) |
| `module-application.contact-gate.documents-helper` | `Pokud žádáte o dar pro své dítě, budete k vyplnění žádosti potřebovat jeho rodný list a svůj občanský průkaz.` | `WIRE0006` (pás ikony/nadpisu, řádek 2) |
| `module-application.contact-gate.consent-manage-helper` | `Souhlasy můžete upravit/zrušit zasláním e-mailu na souhlas@patrondeti.cz.` | `WIRE0006` (pod checkboxem souhlasu) |
| `module-application.step1.intro-1` | `Jsme tu pro vás a chceme dopřát vašim dětem to, co skutečně potřebují. Vše začíná touto žádostí, ve které nám dovolte vás lépe poznat.` | `WIRE0007` (úvod stránky, řádek 1) |
| `module-application.step1.intro-2` | `Pokud žádáte pro více dětí, vyplňte prosím pro každé z nich vlastní žádost. Žádost musí být vyplněna česky.` | `WIRE0007` (úvod stránky, řádek 2) |
| `module-application.step1.story-textarea-helper` | `Řekněte nám více o sobě a o své rodině, o tom, kde žijete a proč potřebujete pomoci. Jednoduše, pomozte nám více porozumět vaší situaci.` | `WIRE0007` (nad narativní textareou) |
| `module-application.step1.story-textarea-placeholder` | `Např.: Jsem rozvedená a žiji s dětmi sama. Kromě Honzíka, kterému zde žádám o dar, mám ještě dceru Natálku. Honzík má vrozenou vadu mozku a trpí epilepsií. Kvůli tomu bohužel nechodí a umí se jen převrátit na bříško a zpátky. Aby se mu ulevilo, potřebuje pravidelné rehabilitace, které si nemůžu dovolit. Rehabilitace nám dávají šanci, že se jednou postaví na vlastní nohy.` | `WIRE0007` (ukázkový placeholder narativní textarey) |
| `module-application.step1.child-like-placeholder` | `Např.: Honzík rád kreslí a miluje modrou barvu.` | `WIRE0007` (ukázkový placeholder pole "jaké je dítě") |
| `module-application.step1.health-problems-helper` | `Pokud ano, pomozte nám pochopit, co ho trápí a jak se mu může ulevit. Nebojte se rozepsat, informace mohou u příběhu na webu pomoci dárcům v rozhodování, zda na příběh přispějí či ne.` | `WIRE0007` (šedý nápovědný text vedle tučné podotázky) |
| `module-application.step1.health-problems-placeholder` | `Např.: Honzík má vrozenou vadu mozku. To znamená, že je oproti svým vrstevníkům opožděný ve vývoji. Ve svých dvou letech se zvládne pouze přetočit na bříško a zpátky. Jinak vyžaduje celodenní péči. Honzíkovi hodně prospívají speciální neurorehabilitace. Jsou finančně velmi nákladné, ale výsledky se dostavují. Proto bychom je rádi opakovali, co nejvíce to půjde. V dnešní době je bohužel většina terapií a rehabilitací pro takové děti brána jako jakýsi nadstandard, za který si rodiče musí připlatit... atd.` | `WIRE0007` (ukázkový placeholder textarey zdravotních problémů) |
| `module-application.step1.duplicate-collection-warning` | `Pokud založíte v průběhu sbírky novou, duplicitní sbírku u jiného charitativního subjektu, informujte neprodleně Nadaci Sirius.` | `WIRE0007` (tučný varovný řádek pod radio "předchozí sbírka") |
| `module-application.step2.gift-help-helper` | `Tato informace může pomoci dárcům v rozhodování, zda přispějí či ne, buďte proto konkrétní a nebojte se popsat detaily tak, aby je každý pochopil.` | `WIRE0008` (pod nadpisem "Jak dar dítěti konkrétně pomůže?") |
| `module-application.step2.gift-help-placeholder` | `Např.: Honzík házenou miluje a chodí na ni už několik let; rehabilitace jsou pro Markétku jedinou nadějí, že někdy bude sama chodit…` | `WIRE0008` (ukázkový placeholder textarey pomoci s darem) |
| `module-application.step2.total-cost-helper` | `Pokud je součástí daru více předmětů nebo služeb, sečtěte je.` | `WIRE0008` (pod nadpisem "Celková částka na pořízení daru") |
| `module-application.step2.tabory-description` | `Požádat můžete o jakékoli tábory anebo soustředění v kterékoli roční době. Pokud je dodavatel stejný, můžete požádat o více aktivit najednou. Např. sportovní soustředění v červenci a srpnu, nebo příměstský tábor na jaře a pobytový tábor v létě apod. V žádosti je nutné uvést celkovou cenu a kontakt na poskytovatele služby.` | `WIRE0008` (rozbalený popis kategorie "Tábory") |
| `module-application.step3.intro` | `Abychom vám mohli pomoci, potřebujeme o vás bližší informace.` | `WIRE0009` (úvod stránky, pod H1) |
| `module-application.step3.single-parent-definition` | `Samoživitel = Zákonný zástupce dítěte, který vede samostatnou domácnost, ve které je jedinou dospělou osobou, žijící s nezaopatřenými dětmi` | `WIRE0009` (statický definiční text pod checkboxem "Jsem samoživitel") |
| `module-application.step3.contact-helper` | `Na těchto údajích vás musíme zastihnout, zkontrolujte prosím jejich správnost.` | `WIRE0009` (pod nadpisem "Vaše kontaktní údaje") |
| `module-application.step3.info-banner-lead` | `V případě změny údajů` | `WIRE0009` (tučný úvod uvnitř červeného informačního banneru) |
| `module-application.step3.info-banner-body` | `nám nezapomeňte dát hned vědět. Ať se k vám pomoc dostane co nejrychleji.` | `WIRE0009` (červený informační banner, zbytek věty) |
| `module-application.step4.intro-1` | `Každý dětský příběh u nás na webu potřebuje mít svého Patrona. Pro dárce je Patron zárukou důvěryhodnosti vašeho příběhu.` | `WIRE0010` (úvod stránky, věta 1) |
| `module-application.step4.intro-2` | `Patronem se může stát kdokoliv, kdo má k dítěti blízký vztah, s jedinou výjimkou a tou je rodinný příslušník. Patronem nesmí být: matka, otec, babička, strýc, teta atd.` | `WIRE0010` (úvod stránky, věta 2 — pravidlo vyloučení rodinných příslušníků) |
| `module-application.step4.intro-3` | `Může to být například učitel, vedoucí zájmového kroužku, pracovník OSPOD atd.` | `WIRE0010` (úvod stránky, věta 3 — příklady nerodinných rolí) |
| `module-application.step4.contact-helper` | `Informujte svého Patrona o tom, že uvádíte jeho údaje, budeme ho ihned kontaktovat emailem.` | `WIRE0010` (pod nadpisem "Kontaktní údaje na Patrona") |
| `module-application.step5.intro` | `Pro zveřejnění příběhu na našich stránkách potřebujeme, abyste nahráli fotografii vašeho dítěte a dvě povinné přílohy: občanský průkaz a rodný list dítěte.` | `WIRE0011` (úvod stránky, pod H1) |
| `module-application.step5.images-instructions-lead` | `Každý příběh musí obsahovat alespoň jeden obrázek, který příběh lépe přiblíží dárcům. Na výběr máte:` | `WIRE0011` (instrukční úvod nad třemi číslovanými volbami) |
| `module-application.step5.images-instructions-option-1` | `Fotografii dítěte – preferovaná varianta. Fotografie může být anonymní (např. dítě zezadu, z dálky apod.), aby byla chráněna identita dítěte.` | `WIRE0011` (číslovaná volba 1) |
| `module-application.step5.images-instructions-option-2` | `Obrázek namalovaný dítětem – například z letního tábora, kroužku, nebo ilustrace předmětu, který souvisí s potřebou (např. hudební nástroj, sportovní vybavení).` | `WIRE0011` (číslovaná volba 2) |
| `module-application.step5.images-instructions-option-3` | `Krátký text „vzkaz/dopis pro dárce", který dítě napíše nebo nadiktuje (ručně psaný nebo vyfocený).` | `WIRE0011` (číslovaná volba 3) |
| `module-application.step5.exit-modal-body` | `Pokud žádost nyní opustíte, můžete se k ní v příštích dnech vrátit a dokončit ji. Vyplněný obsah vám uschováme s výjimkou příloh, které budete muset v případě návratu do žádosti nahrát znovu.` | `WIRE0011` (tělo modálu potvrzení odchodu) |
| `module-application.step5.exit-modal-delete-prompt` | `Přejete si žádost o pomoc zcela zrušit?` | `WIRE0011` (modál potvrzení odchodu, sekundární destruktivní výzva) |

---

## Prázdné stavy (Empty States)

| Klíč | Text | Zobrazeno když |
|---|---|---|
| — | — | Pro žádnou obrazovku v tomto rozsahu není doložen dedikovaný text prázdného stavu. Prázdné/nevyplněné vykreslení formuláře každé obrazovky (placeholdery + výchozí volby radio) je `default` stav, nikoli samostatný stav prázdné kolekce — viz `WIRE0005`–`WIRE0011` §States. Tato sekce je záměrně vynechána podle šablony (není zde žádný placeholder obsah k zaznamenání). |

---

## Loading texty

Pro žádnou obrazovku v tomto rozsahu není doložen text loading stavu — `WIRE0005`–`WIRE0011`
všechny zaznamenávají loading jako `Evidence Pending — not captured`. Sekce vynechána (neexistuje
žádný potvrzený ani předpokládaný text k výpisu).

---

## Chybové / validační zprávy

Každá zpráva odkazuje na pravidlo nebo invariant, který ji vyvolává. Podle `WIRE0006`–`WIRE0011`
**žádný dokument `BRxxxx` nevlastní validaci na úrovni pole pro tento rozsah** — všechny řádky níže
jsou `validationsWithoutTrigger` s výjimkou jedné přímo pozorované chyby na úrovni pole.

| Klíč | Text | Spouštěč |
|---|---|---|
| `module-application.step4.telefon-mismatch-error` | `Telefonní číslo nemůže být stejné jako to Vaše.` | Nenalezen žádný `BRxxxx`/`ENxxxx` — otevřená otázka. Přímo pozorováno (`WIRE0010` States → error; screenshot `screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_22_59.png`) jako inline chyba na úrovni pole u telefonního pole Patrona, pokud se shoduje s telefonním číslem samotného žadatele. `UC0001` toto pravidlo nevyjmenovává; žádný dokument BR v `_ar/spec-draft/BR/` je neupravuje. |

**validationsWithoutTrigger** (pozorované nebo implikované validační plochy bez vlastnícího
`BRxxxx`/`ENxxxx`, podle sekce Validation Surfaces každého WIRE — pro žádnou z nich neexistuje
chybový text, pouze je implikováno podkladové pravidlo/požadavek):

- Brána kontakt (`WIRE0006`): formát/povinnost E-mailu, formát/povinnost Telefonu, checkbox souhlasu povinný pro pokračování — pro žádný z nich nebyl zachycen text chyby na obrazovce.
- Krok 1 (`WIRE0007`): počítadla 0/500 u narativu/zdravotních problémů (nepotvrzeno, zda tvrdý nebo měkký limit), povinnost Jméno/Příjmení dítěte, formát Rodného čísla dítěte, povinnost radio pro předchozí sbírku a národnost — nebyl zachycen žádný chybový text.
- Krok 2 (`WIRE0008`): počítadlo 0/500 u pomoci s darem, počítadlo 0/3 u přílohy, místo vynucení minimální ceny u "Celková částka" (`EN0002` uvádí, že spodní hranice minimální ceny existuje, ale nikoli kde/jak je zobrazena), podmínka výběru kategorie, formát kontaktního pole — nebyl zachycen žádný chybový text.
- Krok 3 (`WIRE0009`): všechna pole osobních údajů (jméno, rodné číslo, adresa, e-mail, telefon, příznak zaměstnání, příznak samoživitele, příznak odlišné korespondenční adresy) — nebyl zachycen žádný chybový text.
- Krok 4 (`WIRE0010`): povinnost Jméno/Příjmení Patrona/rozevíracího seznamu vztahu/e-mailu — nebyl zachycen žádný chybový text (pozorována je pouze výše uvedená chyba neshody telefonu).
- Krok 5 (`WIRE0011`): povinnost tří upload dropzon, povinnost rozevíracího seznamu zdroje doporučení, individuální povinnost tří checkboxů souhlasu — instrukční text uvádí, že dvě kategorie přílohy jsou povinné ("dvě povinné přílohy"), ale nebyl zachycen žádný text vynucení/chyby.

---

## CTA

Každé CTA odkazuje na use case, který realizuje.

| Klíč | Text | Akce |
|---|---|---|
| `module-application.contact-gate.submit-cta` | `Pokračovat` | `UC0001` (UC0001.1 kroky 3–11: odeslání kontaktu/souhlasu → vznik Application/Contact/User) |
| `module-application.contact-gate.back-cta` | `← Zpět na výběr` | Návrat na landing s volbou role (`S006`); žádný vlastní krok UC — pouze navigace, nikoli přechod stavu žádosti |
| `module-application.step1.submit-cta` | `Pokračovat` | `UC0001` (pokračování zachycení dat Application/profilu; žádné vlastní UC id per krok — viz Otevřené otázky) |
| `module-application.step1.back-cta` | `← Krok zpět` | Navigace o krok zpět (cíl Uncertain — viz Otevřené otázky `WIRE0007`); žádné vlastní UC id |
| `module-application.step2.submit-cta` | `Pokračovat` | `UC0001` (pokračování; žádné vlastní UC id per krok) |
| `module-application.step2.back-cta` | `← Krok zpět` | Navigace zpět na krok 1 (`S008a`); žádné vlastní UC id |
| `module-application.step2.file-picker-cta` | `vyberte v počítači` | `UC0001` (zachycení přílohy, žádné vlastní UC id); inline odkaz uvnitř instrukčního textu dropzony |
| `module-application.step3.submit-cta` | `Pokračovat` | `UC0001` (pokračování; žádné vlastní UC id per krok) |
| `module-application.step3.back-cta` | `← Krok zpět` | Navigace zpět na krok 2 (`S008b`); žádné vlastní UC id |
| `module-application.step4.submit-cta` | `Pokračovat` | `UC0001` (pokračování; žádné vlastní UC id per krok) |
| `module-application.step4.back-cta` | `← Krok zpět` | Navigace zpět na krok 3 (`S008c`); žádné vlastní UC id |
| `module-application.step5.submit-cta` | `Odeslat` | `UC0001` (finální odeslání wizardu — Application dosáhne svého odeslaného/kompletního stavu; přesná hodnota statusu je vlastněna `UC0001`/`EN0001`) |
| `module-application.step5.back-cta` | `← Krok zpět` | Navigace zpět na krok 4 (`S008d`); žádné vlastní UC id |
| `module-application.step5.file-picker-cta` | `vyberte v počítači` | `UC0001` (zachycení přílohy, žádné vlastní UC id); inline odkaz, opakuje se ve všech třech dropzonách |
| `module-application.step5.exit-modal-back-cta` | `Zpět do žádosti` | Zavře modál potvrzení odchodu, návrat do `default` stavu kroku 5; žádné vlastní UC id — otevřená otázka, co modál spouští (`WIRE0011` Interactions §7) |
| `module-application.step5.exit-modal-leave-cta` | `Opustit žádost` | Opuštění wizardu; koncept je zachován "s výjimkou příloh" podle textu modálu; žádné vlastní UC id — `UC0025`/`EN0003` `ApplicationSession` odkazovaný z `WIRE0011`, zde není opakován |
| `module-application.step5.exit-modal-delete-cta` | `Smazat žádost` | Destruktivní vedlejší cesta (smaže žádost); cíl/potvrzovací tok nezachycen — otevřená otázka, žádné UC id nenalezeno |
| `module-application.step5.exit-modal-close-cta` | `×` | Zavře modál (stejný efekt jako "Zpět do žádosti", Assumed podle `WIRE0011`) |

---

## Konvence mikrotextů (Microcopy Conventions)

- **Tón:** neutrálně-vřelý, přímý, empatický (např. "Jsme tu pro vás a chceme dopřát vašim dětem
  to, co skutečně potřebují.", "Řekněte nám více o sobě a o své rodině…").
- **Osoba:** v celém rozsahu 2. osoba množného čísla/formální ("vy" forma) — "vám", "vaše dítě",
  "vašeho Patrona", "sdělíte", "žádáte".
- **Velká písmena:** běžná věta pro textový obsah a většinu popisků polí; "Vy"/"Vás"/"Váš" jsou na
  několika místech uprostřed věty psány s velkým počátečním písmenem jako konvence formálního
  oslovení (např. "Začneme tím, že nám sdělíte váš telefon a e-mail" — malé "váš" — vs. "Údaje o Vás",
  "Krok 4: Údaje o vašem Patronovi" — velké "Vás"/smíšené u "vašem"); velká písmena formálního
  zájmena jsou **v pozorovaném zdroji nekonzistentní** (vyskytují se obě formy) — přepsáno verbatim
  podle obrazovky, nenormalizováno.
- **Interpunkce:** nadpisy kroků používají vzor s dvojtečkou ("Krok N: <title>"); popisky polí jsou
  typicky nepunktované jmenné fráze; nápovědné/instrukční věty končí tečkou; volby radio jsou holé
  "ANO"/"NE" velkými písmeny.
- **Známé verbatim odchylky (zachovány, neopraveny):** "Mate nebo měli jste sbírku…" (chybějící
  diakritika u "Máte"); "V jaké termínu se tábor uskuteční" (gramaticky nestandardní "jaké
  termínu"); obě reprodukovány přesně tak, jak byly pozorovány, v souladu s konvencí evidence-first.

---

## Otevřené otázky

- `S006` (landing s volbou role, `WIRE0005`) nemá screenshotový důkaz — jeho dva popisky karet rolí
  nejsou přepsatelné jako potvrzený text. `WIRE0005` zaznamenává pouze anglický glos odvozený z twig
  šablony ("I want to help my child" / "I want to help a child I know"); skutečné české texty na
  obrazovce jsou `Evidence Pending`. Zde není vytvořen žádný klíč, aby se předešlo vymýšlení textu.
- Druhá obrazovka pozorovaná na `/zadost/zadatel` (`screencapture-…13_18_04.png`, mezikrok se
  checklistem "Co budete k vyplnění žádosti potřebovat?" s vlastním CTA "Pokračovat") je označena
  `WIRE0006` jako nevyřešená alternativní/předcházející obrazovka, není součástí doloženého stavu
  `S007`. Její text není v tomto dokumentu přepsán — mimo rozsah do vyřešení na úrovni WIRE.
  `WIRE0006` také zaznamenává odkaz "Jste patron? Vaše žádost je ZDE" pozorovaný pouze na stejném
  snímku `13_18_04`, nikoli na potvrzeném stavu `S007` — rovněž zde nepřepsán.
  Poznámka (uzávěrka BA, nikoli vlastněná COPY): stejná obrazovka `13_18_04` může odpovídat vlastnímu
  pásu nadpisu `S007` "Kontaktní údaje nikde nezveřejňujeme…" / "Pokud žádáte o dar pro své dítě…"
  zaznamenanému výše pod `module-application.contact-gate.*`, který se zobrazuje bezprostředně nad
  formulářovým panelem "Údaje o Vás" na potvrzeném snímku `13_18_12` — obě snímky mohou být
  scroll-stavy jedné obrazovky, nikoli dvě odlišné obrazovky; tato nejasnost na úrovni WIRE není
  řešena vrstvou COPY.
- Úplný seznam voleb pro rozevírací seznam vztahu v kroku 4 "V jakém vztahu je k vám nebo k vaší
  rodině?" není doložen — zachycena byla pouze hodnota "Rodinný známý" (hodnota vybraná testerem).
  Ostatní texty voleb jsou Uncertain a nejsou uvedeny.
- Úplný seznam voleb pro rozevírací seznam zdroje doporučení v kroku 5 "Odkud jste se dozvěděli o
  projektu Patron dětí?" není doložen — zachycen pouze v zavřeném/nevybraném stavu. Žádné texty
  voleb nejsou uvedeny.
- Cíle odkazů v checkboxu souhlasu na `S007` ("zpracováním osobních údajů") a `S008e` ("přesné,
  pravdivé a úplné údaje", "pravidly poskytování pomoci", "zpracováním osobních údajů") jsou
  potvrzeny jako text odkazu, ale obsah jejich cíle není doložen — mimo rozsah COPY (právní obsah,
  nikoli text této obrazovky).
- Zda počítadla znaků 0/500 v krocích 1 a 2 představují tvrdý `maxlength` nebo měkký/informační
  limit, je Uncertain podle `WIRE0007`/`WIRE0008` — pro žádnou variantu neexistuje odpovídající
  chybový text, proto žádný není zaznamenán.
- Přesný spouštěč modálu potvrzení odchodu v kroku 5 ("Chystáte se opustit žádost.") není doložen
  (`WIRE0011` Interactions §7) — vlastní text modálu je přesto výše přepsán, protože vykreslený stav
  samotného modálu je přímo potvrzen screenshotem.

---

## Evidence

| Oblast | Jistota | Evidence |
|---|---|---|
| Popisky brány kontakt/souhlas, nápovědy, FAQ, CTA (`S007`) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-zadatel-2026-07-04-13_18_12.png`; `_ar/evidence/ui/ui-observed-areas.md` §6 |
| Popisky, nápovědy, placeholdery, CTA kroku 1 "Váš příběh" (`S008a`) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png`, `…13_20_29.png`; `ui-observed-areas.md` §3 |
| Seznam kategorií, popisky polí, kategoriálně závislé přeznačení, CTA kroku 2 "Dar" (`S008b`) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_39.png`, `…13_20_57.png`; `ui-observed-areas.md` §4 |
| Popisky, nápovědy, informační banner, CTA kroku 3 "O Vás" (`S008c`) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_21_26.png`, `…13_21_59.png`; `ui-observed-areas.md` §5 |
| Popisky, nápovědy, chyba neshody telefonu, CTA kroku 4 "Patron" (`S008d`) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_22_08.png`, `…13_22_59.png` |
| Nadpisy sekcí, instrukce, exit modál, CTA kroku 5 "Přílohy" (`S008e`) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_23_13.png`, `…13_23_21.png` |
| Popisky stepperu (Příběh/Dar/O Vás/Patron/Přílohy) | Confirmed | všechny výše uvedené screenshoty kroků; `COMP0005_WizardStepper.md` |
| Text karet `S006` landing s volbou role | Uncertain — Evidence Pending | `_ar/spec-draft/WIRE/WIRE0005_RoleChoiceLanding.md` Purpose/Layout Zones; screenshot neexistuje |
| Úplné seznamy voleb rozevíracích seznamů vztahu / zdroje doporučení | Uncertain — not fully observed | Otevřené otázky `WIRE0010`, `WIRE0011` |
| Text a mechanismus spouštění validační chyby neshody telefonu | Confirmed text / Uncertain mechanism | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_22_59.png`; `WIRE0010` Validation Surfaces (bez vlastníka BR) |
