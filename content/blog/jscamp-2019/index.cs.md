---
title: JSCamp 2019 v Barceloně
slug: jscamp-2019
date: 2019-08-21
keywords:
    - web
    - konference
menu:
    main:
        parent: 'blog'
photoDesc: Lanovka v Barceloně — Valdemaras D.
photoUrl: https://unsplash.com/photos/aktjetKBqzc
---

Hlavní město Katalánska neplní jen titulky novin, ale hostí i řadu skvělých konferencí — o jedné takové už jsem ostatně [psal](/full-stack-fest-2018) — a *JSCamp 2019* nebyl vyjímkou. Jak napovídá název, každoročním těžištěm konference je JavaScript ve všech svých podobách. Pro ty nejlepší přednášející však posloužil jen jako odrazový můstek k prozkoumání témat širšího záběru.

<!--more-->

Už první přednáška nastolila vysoký standard. Konferenci zahájil Kyle Simpson, autor skvělé učebnice *[You Don’t Know JavaScript](https://github.com/getify/You-Dont-Know-JS)* (po přečtení jsem uznal, že název je namístě). Ve svojí přednášce s provokativním názvem *„FOUC, and the Death of Progressive Enhancement“* si za cíl zvolil princip postupného vylepšení — kterému jsem se v minulosti [věnoval i zde](/princip-postupneho-vylepseni) — a snažil se publikum přesvědčit, že nejde o samospásné řešení. Argumentoval, že vývojáři mnohdy upřednostňují svůj zážitek a pohodlí před tím uživatelovým. Na ten popud odkazoval na více jak deset let starý [dokument](https://www.w3.org/TR/html-design-principles/#priority-of-constituencies) návrhových principů HTML, kde stojí „in case of conflict, consider users over authors over implementors over specifiers over theoretical purity,“ tedy „v případě konfliktu zájmů berte ohled v prvé řadě na uživatele, před autory, tvůrci implementací a specifikací, a teoretickou čistotou.“

## Lidé místo uživatelů

Dle jeho slov je problematické už jen to, jak na uživatele nahlížíme. V lepším případě je považujeme za konečnou **množinu segmentů** (rozdělených dle zařízení či prohlížeče), v tom horším za **jednolitou masu**. [Princip postupného vylepšení](/princip-postupneho-vylepseni) samozřejmě odpovídá prvnímu případu. Výsledná podoba aplikace totiž záleží na tom, do jaké podmnožiny uživatel patří. Kyle ovšem namítá, že uživatelé nejsou bezejmenné skupiny, jasně rozdělené na základě našich představ, ale **jednotliví lidé**, každý s jinými nároky a potřebami. Pro začátek pomůže, když je tak začneme označovat a přestaneme používat neosobní slovo uživatelé.

{{< figures/quote >}}
Lidé mnohdy netouží po nejnovější technologii či plnohodnotném zážitku. Občas, když je venku tma a prší, připojení vypadává, a v baterii zbývá jen pár procent, potřebují pouze rychle najít spojení domů.
{{< /figures/quote >}}

Ale co dál? Při návrhu webové aplikace spoléháme v prvé řadě na náš úsudek a myslíme si, že víme, co uživatel potřebuje nebo chce. Je to tak jednodušší. Zároveň je však zřejmé, že naše představy často neodpovídají skutečnosti a jednotlivým lidem zážitek naopak kazí. Samotný fakt, že konkrétní prohlížeč podporuje danou technologii (třeba WebGL) ještě neznamená, že o ní člověk, který prohlížeč používá, stojí. Ač to jako vývojáři či designeři nemusíme chápat, lidé mnohdy netouží po nejnovější technologii či plnohodnotném zážitku. Občas, když je venku tma a prší, připojení vypadává, a v baterii zbývá jen pár procent, potřebují pouze rychle najít spojení domů. Méně je pak více . Ve vyjímečných případech se proto neopíráme jen o naše mínění a bereme v potaz i další informace. Ptáme se na stav baterie, světelné podmínky nebo typ připojení k internetu. Ale snaha vyjít lidem vstříc zde — alespoň pro většinu z nás — zvolna mizí.

Kyle ovšem tvrdí, že to nestačí. Rozhodnutí bychom měli přenechat samotným lidem, a ne jen jejich prohlížečům. To obnáší dát jim **možnost ovlivnit** zážitek z naší aplikace a **ustoupit** jejich preferencím. Příkladem je využití novějších *media queries* v CSS, jako je `prefers-color-scheme: dark`, které značí, zdali daný člověk používá tmavý režim v MacOS, na základě čehož můžeme na našem webu příhodně upravit barvy. `prefers-reduced-motion` nám prozměnu vyjeví, že bychom měli snížit (nebo zcela odstanit) množství či intenzitu animací. Kyle dokonce ukázal příklad teoretické HTTP hlavičky — nazval ji `request-fidelity` — s bezrozměrnou hodnotu od nuly do jedné. Tu by člověk nastavil pomocí jednoduchého posuvníku buď pro jednotlivé weby nebo v rámci celého prohlížeče. My jako vývojáři bychom na toto číslo mohli **reagovat** v naší aplikaci a posílat zpátky například jinou sadu skriptů či stylů. Nic takového samozřejmě prohlížeče zatím nenabízí, ale nic nám nebrání vyvinout podobné prvky přímo v našich aplikacích už teď, což zvýší šanci na vznik standardizovaného, široce používaného, řešení.

Stejným způsobem uvažuje i Jason Pamental, který na *CSSCampu* (ten se koná spolu s *JSCampem*), mluvil o takzvaných **variabilních fontech**. Jde o nový formát fontů, který, stručně řečeno, umožňuje všechny různé řezy vložit do jediného souboru. Dle této specifikace font není definován **diskrétně**, tedy jako sada souborů, kde každý představuje jednu konkrétní tloušťku či variantu jako kurzíva, ale **spojitě**, s takřka nekonečným množstvím možných kombinací. To je skvělá zpráva ze dvou důvodů. Ten první souvisí s velikostí stažených dat a množstvím HTTP požadavků. Obou je v případě variabilních fontů přirozeně mnohem méně.

## Pište méně kódu

Rich Harris
