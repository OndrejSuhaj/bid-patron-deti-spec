**Dokumentace procesu Low Risk**

**Verze dokumentu:** 1.0\
**Vlastník procesu:** Risk tým\
**Poslední aktualizace:** květen 2026\
**Schválil:**

**1. Účel**

Tento dokument popisuje proces vyhodnocení **Low Risk**, který slouží k
posouzení žádostí, jež mohou být schváleny přímo Koordinátorem bez
nutnosti standardního prověření Risk týmem.

Cílem procesu je automatizovat vyhodnocení nízkorizikových žádostí
pomocí předdefinovaných hodnoticích kritérií a jasně definovaných
schvalovacích kompetencí.

------------------------------------------------------------------------

**2. Rozsah**

Tento proces se vztahuje na všechny žádosti zpracovávané v rámci
workflow **Low Risk**.

Systém automaticky vyhodnocuje žádosti podle definovaných kritérií a
určuje, zda schválení spadá do kompetence Koordinátora nebo Risk týmu.

------------------------------------------------------------------------

**3. Proces vyhodnocení Low Risk**

Systém vyhodnocuje žádost pomocí pěti kritérií. Každému kritériu je
přiřazeno bodové hodnocení dle předem definovaných pravidel.

Součet bodů určuje, zda žádost spadá do kompetence Koordinátora, nebo
vyžaduje posouzení Risk týmem.

Hodnota **-1** představuje výsledek **KO (automatické zamítnutí /
neúspěšné vyhodnocení)**.

Pokud alespoň jedno kritérium získá hodnotu **-1**, výsledné hodnocení
je automaticky **KO (-1)** bez ohledu na ostatní získané body.

------------------------------------------------------------------------

**4. Hodnoticí kritéria**

**4.1 Patron ≠ Žadatel**

Toto kritérium ověřuje, zda žadatel a patron používají rozdílné
e-mailové adresy.

| **Podmínka** | **Body** | **Popis** |
|----|:--:|----|
| E-mailové adresy se neshodují | 0 | Patron a žadatel používají rozdílné e-mailové adresy |
| E-mailové adresy se shodují | -1 | Patron a žadatel používají stejnou e-mailovou adresu |

**4.2 Status patrona**

Toto kritérium hodnotí, zda patron již existuje v systému a jaký je jeho
status.

Kritérium nastavuje pracovník Risk týmu na **Scoring kartě patrona** a
zůstává navázáno na e-mail patrona.

Na Scoring kartě je vždy evidována naposledy nastavená hodnota. Při
každé další žádosti navázané na stejný e-mail může být hodnocení změněno
nebo ponecháno beze změny.

Pro nově založeného patrona je výchozí status:

**N – Neznámý**

| **Status** | **Body** | **Popis**                              |
|------------|:--------:|----------------------------------------|
| WL_Z       |    10    | Patron je známý                        |
| WL_ZD      |    10    | Patron je známý a prověřený            |
| WL_N       |    0     | Patron je neznámý                      |
| BL         |    -1    | Patron je veden na interním blacklistu |

**4.3 Status žadatele**

Toto kritérium hodnotí, zda žadatel již existuje v systému a jaký je
jeho status.

Kritérium nastavuje pracovník Risk týmu na **Scoring kartě žadatele** a
zůstává navázáno na e-mail žadatele.

Na Scoring kartě je vždy evidována naposledy nastavená hodnota. Při
každé další žádosti navázané na stejný e-mail může být hodnocení změněno
nebo ponecháno beze změny.

Pro nového žadatele je výchozí status:

**N – Neznámý**

| **Status** | **Body** | **Popis**                               |
|------------|:--------:|-----------------------------------------|
| WL_Z       |    10    | Žadatel je známý                        |
| WL_ZD      |    10    | Žadatel je známý a prověřený            |
| WL_N       |    0     | Žadatel je neznámý                      |
| BL         |    -1    | Žadatel je veden na interním blacklistu |

**4.4 Rizikovost předmětu pomoci**

Toto kritérium hodnotí míru rizika poskytované pomoci na základě hodnoty
nebo charakteru daru.

Nastavení kritéria je spravováno v sekci **Scoring Risks**.

| **Rizikovost** | **Body** |
|----------------|:--------:|
| Low            |    10    |
| Medium         |    0     |
| High           |    -1    |

**4.5 Způsob úhrady**

Toto kritérium hodnotí nastavený způsob výplaty.

| **Způsob úhrady** | **Body** | **Popis** |
|----|----|----|
| Faktura zprostředkovateli | 0 | Platba probíhá prostřednictvím zprostředkovatele |
| Výplata na bankovní účet žadatele | -1 | Platba je zaslána přímo na účet žadatele |

------------------------------------------------------------------------

**5. Pravidla vyhodnocení skóre**

Systém sčítá bodová hodnocení jednotlivých kritérií.

Speciální pravidlo:

- jakékoli kritérium s hodnotou **-1** automaticky generuje výsledek
  **KO**

- výsledek KO má vyšší prioritu než součet ostatních bodů

- další body již nemají vliv na finální výsledek

------------------------------------------------------------------------

**6. Matice schvalovacích kompetencí**

Na základě výsledného skóre systém určí schvalovací kompetenci:

| **Výsledné skóre** | **Schvalovací kompetence** |
|--------------------|----------------------------|
| 0–20               | Risk tým                   |
| 30                 | Koordinátor                |
| KO (-1)            | Risk tým                   |

**7. Odpovědnosti koordinátora**

Po převzetí žádosti Koordinátor zkontroluje záložku **Scoring-LR (Low
Risk Scoring)**.

Aby byla záložka aktivní, musí být nastaven **Způsob úhrady daru**.

Koordinátor provede následující kroky:

1.  Zkontroluje výsledky Low Risk hodnocení

2.  Ověří, zda schválení spadá do jeho kompetence

3.  Provede standardní kontrolu žádosti

4.  Zkontroluje úplnost dodaných dokumentů

5.  Vyhodnotí případné podezřelé nebo nekonzistentní informace

Pokud během kontroly zjistí rizikové informace nebo vznikne podezření na
nepravdivé údaje, předá žádost k posouzení Risk týmu.

Pokud jsou všechny údaje správné a dokumentace kompletní, může žádost
schválit.

------------------------------------------------------------------------

**8. Správa změn**

Změny následujících parametrů:

- hodnoticích kritérií

- bodových hodnot

- logiky vyhodnocení

- hranic výsledného skóre

je možné provádět pouze prostřednictvím schváleného IT požadavku.

------------------------------------------------------------------------

**9. Definice pojmů**

| **Pojem**     | **Definice**                                           |
|---------------|--------------------------------------------------------|
| Žadatel       | Osoba žádající o pomoc                                 |
| Patron        | Osoba podporující nebo zastřešující žádost             |
| Risk tým      | Tým odpovědný za posouzení rizik a schvalování         |
| Koordinátor   | Uživatel oprávněný schvalovat vybrané Low Risk žádosti |
| KO            | Automaticky neúspěšné vyhodnocení                      |
| Scoring karta | Místo, kde se spravují hodnoticí a rizikové parametry  |
