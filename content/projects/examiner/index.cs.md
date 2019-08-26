---
title: Examiner
date: 2014-05-21
menu:
    main:
        parent: 'projects'
keywords:
    - app
    - website
thumbCrop: right
---

Examiner je webová aplikace pro učitelé i studenty. Jejím smyslem je první skupině ulehčit práci při nudném úkolu vytváření a hodnocení písemných testů. Zároveň umožňuje studentům tyto testy absolvovat přímo ve webovém prohlížeči. Výsledkem by měl být o trochu lepší zážitek pro obě zúčastněné skupiny.


<!--more-->

{{< peristyle title="Inspirace" img1="img/notebooks.jpg" img1-caption="Sešity Vanguard" img2="img/bookmark.jpg" img2-caption="Záložka sešitu Confidant" saturation="saturated" >}}
Grafický návrh nese stopy inspirace sešity od společnosti [Baron Fig](https://www.baronfig.com/), které jsem používal během studia. Zaujaly mě díky svým výrazným barvám a detailům jako je svítivě žlutá látková záložka. Aplikaci jsem si představoval tak, aby působila co nejvíc fyzicky, ale zároveň aby design zůstal čistý a jednoduchý. Proto jsem se chtěl vyhnout přehnanému skeumorfismu a navrhl aplikaci tak, aby vypadala jako list papíru, s rozhraním připomínajícím barevné záložky.
{{< /peristyle >}}

{{< asymmetric-with-grid title="Proces" img1="img/process1.png" img2="img/process2.png" img3="img/process3.png" img4="img/process4.png" >}}
Učitel, který se rozhodne vytvořit nový test, v první moment uvidí prázdný list papíru. Pomocí ovládacích prvků jej ale rychle zaplní všelijakými sekcemi a otázkami. Otázku tvoří kombinace různých typů obsahu, jako třeba jednoduchý text, ukázka kódu, obrázek, nebo schéma, které lze nakreslit přímo v aplikaci. Odpověď vznikne obdobně, s tím rozdílem, že navíc může nabýt podoby výběru z několika možnosti. Po dokončení je test uložen a přiřazen ke konkrétnímu předmětu. Zbývá jen rozhodnout o čase zkoušky a test je připraven.
{{< /asymmetric-with-grid >}}

{{< stack "Podvádění" "img/cheating1.png" "img/cheating2.png" >}}
Než jej aplikace pustí dále, musí student odsouhlasit, že si je vědom Etického kodexu ČVUT a míní se jím řídit. Ač se na první pohled může zdát, že jde jen o formalitu, je za tímto krokem hlubší význam. Je postaven na výzkumech týkajících se podvádění, které vedl Dan Ariely. Ten své experimenty uzavřel slovy: „připomenout morální hodnoty v momentu pokušení dělá, co se týče podvodného jednání, divy a dokonce mu mnohdy zcela zabrání.”

Pokud však ani to nepomůže, využívá aplikace dvou technik, které by měly studentům bránit, respektive odradit od podvádění. Když student přepne do jiné záložky v prohlížeči nebo otevře jinou aplikaci, dostane přísedící učitel okamžitě upozornění. Šikovného studenta by však mohl napadnout způsob, jak omezení obejít. Mohl by si například dopředu připravit soubor s poznámkami a nastavit velikost okna prohlížeče tak, aby byly vidět. Proto aplikace sleduje, jak velkou část obrazovky prohlížeč zabírá, a pokud to není 100&nbsp;%, je student prozrazen.
{{< /stack >}}



