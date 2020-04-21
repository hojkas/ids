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

Specializace entitní množiny Osoba množinami Zákazník a Pracovník je naimplementována pomocí jedné tabulky s položkami `is_employee` a `is_customer`, které určují jakou roli je Osoba schopná zastávat. Všechny ostatní entitní množiny z ER diagramu byly převedeny do samostatných tabulek beze změny.

Pro spustitelné procedury, materializovaný pohled i všechny tabulky jsou předány práva také druhému členovi týmu.

## Triggery <a name="triggery"></a>

Trigger `check_borrow_personel` zajišťuje integritu dat v tabulce `borrow`. U každého záznamu do této tabulky se uvádí dvě ID osoby, první zákazníka půjčujícího si kopii, druhé pracovníka, který výpůjčku zpracovává. Aby nedošlo k situaci, kdy je zadáno ID osoby s nedostatečným oprávněním na danou akci, vyhledá se ID osoby uvedené jako zákazník a zkontroluje se, zda se jedná skutečně o zákazníka. Stejná akce je provedena pro ID zaměstnance. V případě nekonzistence je vyvolána chyba.

TODO Denis: Druhý trigger

## Procedury <a name="procs"></a>

## Explain plan a index <a name="exp"></a>

## Materializovaný pohled <a name="mat"></a>

TODO Denis
