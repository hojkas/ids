# IDS dokumentace draft

(titulní strana placeholder)

# Obsah
1. [Zadání](#zadani)
2. [Use case diagram](#use-case)
3. [ER diagram](#er)
4. [Implementace](#implementace)
   1. [Triggery](#triggery)
   2. [Procedury](#procs)
   3. [Explain plan a index](#exp)
   4. [Materializovaný pohled](#mat)

# Zadání <a name="zadani"></a>

# Use case diagram <a name="use-case"></a>

![use case](https://github.com/hojkas/ids/blob/master/part_5/IDS_uc.png)

# ER diagram <a name="er"></a>

![er diagram](https://github.com/hojkas/ids/blob/master/part_5/IDS_er.png)

# Implementace <a name="implementace"></a>

Specializace entitní množiny Osoba množinami Zákazník a Pracovník je naimplementována pomocí jedné tabulky s položkami `is_employee` a `is_customer`, které určují, jakou roli je Osoba schopná zastávat. Všechny ostatní entitní množiny z ERD byly převedeny do samostatných tabulek podle diagramu beze změny.

Skript vytvoří tabulky, nahraje do nich demonstrační data a vytvoří žádané procedury, triggery a další požadované struktury. Pro spustitelné procedury, materializovaný pohled i všechny tabulky jsou předány práva také druhému členovi týmu.

## Triggery <a name="triggery"></a>

Trigger `check_borrow_personel` zajišťuje integritu dat v tabulce `borrow`. U každého záznamu do této tabulky se uvádí dvě ID osoby, první zákazníka půjčujícího si kopii, druhé pracovníka, který výpůjčku zpracovává. Aby nedošlo k situaci, kdy je zadáno ID osoby s nedostatečným oprávněním na danou akci, vyhledá se ID osoby uvedené jako zákazník a zkontroluje se, zda se jedná skutečně o zákazníka. Stejná akce je provedena pro ID zaměstnance. V případě nekonzistence je vyvolána chyba.

Nasledující trigger `increment_borrow_id` se využívá pro ikrementaci primárního klíče elementů v tabulce `borrow`. Tento trigger je volán při každém vložení do tabulky. 

Poslední trigger `count_borrow_cost` spáji obě funkcionality předchodzích triggeru do jednoho. Kokrétněji, nastavení hodnoty sloupce a načtení hodnot z dvou různých tabulek. Tenhle trigger je využíván při updatu tabulky `borrow`, konkkrétne když je položka `return_date` přestavena z hodnoty NULL na konktrétní datum. V tomhle případe je načtena hodnota `price_per_day` pro daným titul z tabulky `title` a je vynásobena rozdílem dnů mezi vypůjčením a vrácením titulu, pro získání konečné ceny výpujčky. Tato hodnota je pak vložena do sloupce `price` v tabulce `borrow` pro respektivní výpujčku.  

## Procedury <a name="procs"></a>

Procedura `count_copies_state` slouží k výpisu stavu všech kopií. Zjistí, kolik kopií (kazet) obchod skutečně vlastní, kolik je jich zapůjčených a volných, a vypočítá procentuální podíl zapůjčených kopií. Na spočítání vypůjčených kopií využívá select všech výpůjček z tabulky `borrow`, které mají v sloupci data vrácení hodnotu Null. Protože při počítání procent zapůjčených kopií probíhá dělení proměnnou, která může být nulová, obsahuje procedura ošetření výjimky dělení nulou.

Procedura `count_genre_profit` má za úkol spočítat profity zadaného žánru a porovnat je s celkovými. Využívá k tomu kurzor, který prochází z tabulky `borrow` řádky, kde byla již vrácena kazeta, a vrací cenu zápůjčky a žánr vypůjčené kopie. Tento kurzor se volá ve smyčce, dokud neprojde všechny odpovídající řádky. Informace z něj se použijí pro uložení hodnot do patřičných proměnných na základě shody či neshody žánru kopie s hledaným žánrem. Po skončení smyčky je z proměnných vypočítána statistika.

## Explain plan a index <a name="exp"></a>

Na demonstraci explain plan používáme dotaz z třetí úlohy. Jedná se o select nad tabulkou `genre`, který vybere pouze ty žánry, ke kterým existuje více než 1 kopie. Tyto žánry vyhledává zanořeným selectem nad tabulkou `copy`, který sjednotí kopie pomocí group by a vybere pouze ty s agregační funkcí count větší jak jedna. Protože kopie samotná nemá informaci o žánru, obsahuje dotaz navíc join s tabulkou `title` pro nalezení žánru k jednotlivým kopiím.

Právě ve spojení tabulek `copy` a `title` pro daný select vidíme možnost optimalizace indexem. V původním explain plan můžeme vidět vyhledání titulu ke každé kopii. Vytvořili jsme proto index na `copy` vázající každou kopii k odpovídajícímu `title_id`. Díky tomuto indexu odpadne nutnost opakovaného prohledávání tabulky title a celý dotaz se urychlí.

## Materializovaný pohled <a name="mat"></a>

Pro demonstraci materializovaného pohledu sme vytvořili pohled `customer_borrow_count`. Tento pohled spojuje informace z tabulek `borrow` a `person` přičemž tyto informace používa na vytvoření sourhnu všech zákazníku a zobrazení počtu výpůjček, které respektivní uživatelé uskutečnili. Tento pohled by se dal využít například na udelovaní věrnostnických slev a sledování nejaktivnějších zákazníků. 
