---
​---
title: "Dokumentace"
​---
---

<div style="text-align:center; margin-top:300px; margin-bottom:300px">
    <hspace></hspace>
    <h1>
        IDS projekt: Videopůjčovna
    </h1>
        30. dubna 2020
    <p style="margin:100px"></p>
    <h3>
        Autoři:
    </h3>
    Iveta Strnadová (xstrna14)<br>
    Denis Lebó (xlebod00)
</div>

<div style="page-break-after: always; break-after: page;"></div>

# Obsah

1. [Zadání](#zadani)
2. [Use case diagram](#use-case)
3. [ER diagram](#er)
4. [Implementace](#implementace)
   1. [Triggery](#triggery)
   2. [Procedury](#procs)
   3. [Explain plan a index](#exp)
   4. [Materializovaný pohled](#mat)

<br>

# Zadání <a name="zadani"></a>

Navrhněte IS videopůjčovny. Videopůjčovna půjčuje kazety registrovaným zákazníkům. Systém bude využíván jednak pracovníky videopůjčovny, jednak samotnými zákazníky. Musí umožnit zákazníkům výběr požadovaného titulu podle vhodných kritérií a zjistit, zda je k dispozici (volné). Zaměstnanci potom realizují vlastní výpůjčku a vrácení zapůjčených titulů. Systém musí zajistit vystavení účtu. Cena je závislá na době zapůjčení a zvyšuje se progresivně s dobou. Ceník se může měnit.

<div style="page-break-after: always; break-after: page;"></div>

# Use case diagram <a name="use-case"></a>

<img src="C:\Users\ivkas\OneDrive\Dokumenty\GitHub\ids\part_5\IDS_uc.png" alt="use case" style="zoom:25%;" />

# ER diagram <a name="er"></a>

<img src="C:\Users\ivkas\OneDrive\Dokumenty\GitHub\ids\part_5\IDS_er.png" alt="er diagram" style="zoom:25%;" />

<div style="page-break-after: always; break-after: page;"></div>

# Implementace <a name="implementace"></a>

Specializace entitní množiny Osoba množinami Zákazník a Pracovník je naimplementována pomocí jedné tabulky s položkami `is_employee` a `is_customer`, které určují, jakou roli je Osoba schopná zastávat. Všechny ostatní entitní množiny z ERD byly převedeny do samostatných tabulek podle diagramu beze změny.

Skript vytvoří tabulky, nahraje do nich demonstrační data a vytvoří žádané procedury, triggery a další požadované struktury. Pro spustitelné procedury, materializovaný pohled i všechny tabulky jsou předány práva také druhému členovi týmu.

<br>

## Triggery <a name="triggery"></a>

Trigger `check_borrow_personel` zajišťuje integritu dat v tabulce `borrow`. U každého záznamu do této tabulky se uvádí dvě ID osoby, první zákazníka půjčujícího si kopii, druhé pracovníka, který výpůjčku zpracovává. Aby nedošlo k situaci, kdy je zadáno ID osoby s nedostatečným oprávněním na danou akci, vyhledá se ID osoby uvedené jako zákazník a zkontroluje se, zda se jedná skutečně o zákazníka. Stejná akce je provedena pro ID zaměstnance. V případě nekonzistence je vyvolána chyba.

Nasledující trigger `increment_borrow_id` se využívá pro ikrementaci primárního klíče elementů v tabulce `borrow`. Tento trigger je volán při každém vložení do tabulky. 

Poslední trigger `count_borrow_cost` spojuje obě funkcionality předchodzích triggeru do jednoho. Kokrétněji, nastavení hodnoty sloupce a načtení hodnot z dvou různých tabulek. Tento trigger je využíván při updatu tabulky `borrow` v okamžiku, kdy je položka `return_date` přepsána z hodnoty NULL na konktrétní datum. V tomto případe je načtena hodnota `price_per_day` pro daný titul z tabulky `title` a je vynásobena rozdílem dnů mezi vypůjčením a vrácením titulu, pro získání konečné ceny výpujčky. Tato hodnota je pak vložena do sloupce `price` v tabulce `borrow` pro danou výpujčku.  

<br>

## Procedury <a name="procs"></a>

Procedura `count_copies_state` slouží k výpisu stavu všech kopií. Zjistí, kolik kopií (kazet) obchod skutečně vlastní, kolik je jich zapůjčených a volných, a vypočítá procentuální podíl zapůjčených kopií. Na spočítání vypůjčených kopií využívá select všech výpůjček z tabulky `borrow`, které mají v sloupci data vrácení hodnotu Null. Protože při počítání procent zapůjčených kopií probíhá dělení proměnnou, která může být nulová, obsahuje procedura ošetření výjimky dělení nulou.

Procedura `count_genre_profit` má za úkol spočítat profity zadaného žánru a porovnat je s celkovými. Využívá k tomu kurzor, který prochází z tabulky `borrow` řádky, kde byla již vrácena kazeta, a vrací cenu zápůjčky a žánr vypůjčené kopie. Tento kurzor se volá ve smyčce, dokud neprojde všechny odpovídající řádky. Informace z něj se použijí pro uložení hodnot do patřičných proměnných na základě shody či neshody žánru kopie s hledaným žánrem. Po skončení smyčky je z proměnných vypočítána statistika.

<div style="page-break-after: always; break-after: page;"></div>

## Explain plan a index <a name="exp"></a>

Na demonstraci explain plan používáme dotaz z třetí úlohy. Jedná se o select nad tabulkou `genre`, který vybere pouze ty žánry, ke kterým existuje více než 1 kopie. Tyto žánry vyhledává zanořeným selectem nad tabulkou `copy`, který sjednotí kopie pomocí group by a vybere pouze ty s agregační funkcí count větší jak jedna. Protože kopie samotná nemá informaci o žánru, obsahuje dotaz navíc join s tabulkou `title` pro nalezení žánru k jednotlivým kopiím.

Právě ve spojení tabulek `copy` a `title` pro daný select vidíme možnost optimalizace indexem. V původním explain plan můžeme vidět vyhledání titulu ke každé kopii. Vytvořili jsme proto index na `copy` vázající každou kopii k odpovídajícímu `title_id`. Díky tomuto indexu odpadne nutnost opakovaného prohledávání tabulky title a celý dotaz se urychlí.

<br>

## Materializovaný pohled <a name="mat"></a>

Pro demonstraci materializovaného pohledu jsme vytvořili pohled `customer_borrow_count`. Tento pohled spojuje informace z tabulek `borrow` a `person`, přičemž tyto informace používa na vytvoření sourhnu všech zákazníku a zobrazení počtu výpůjček, které daní uživatelé uskutečnili. Tento pohled by se dal využít například na udělování věrnostních slev a sledování nejaktivnějších zákazníků. 