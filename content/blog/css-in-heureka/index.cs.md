---
title: Jak jsem se naučil nedělat si starosti a mít rád kaskádu
slug: css-v-heurece
date: 2019-11-19
keywords:
    - web
    - front-end
menu:
    main:
        parent: 'blog'
photoDesc: Tim Johnson
photoUrl: https://unsplash.com/photos/VkuWpYCV2MU
---

V Heurece máme CSS rádi. Pokud ne všichni, tak alespoň ti, co s ním běžně přijdou do styku. CSS je totiž — stejně jako HTML — deklarativní a jednoduchý jazyk a s HTML sdílí i podobně laxní validátor, který přijme ledacos a taktně přeskočí, co nezná. Na rozdíl od HTML, které asi většinu z nás ze spánku nebudí, však CSS v lidech vyvolává mnohem silnější emoce.

<!--more-->

Vlastní zkušenost mi říká, že častým viníkem je takzvaná kaskáda. A jelikož se o zkrocení kaskády pokoušíme i v Heurece, ukážeme si, jak může vypadat jeden z možných přístupů.

## Kaskáda a specificita

Na první pohled je princip kaskády jednoduchý: pozdější deklarace přebíjí předchozí. V první řadě tedy záleží na jejich pořadí. To dává CSS jasný řád, kdy obecné deklarace — jako třeba barva a velikost písma — předcházejí ty konkrétní, například barvu pozadí specifické komponenty.

{{< figures/quote >}}
Problém CSS nespočívá v kaskádě, která je jednoduchá a vede k logickému řazení deklarací, ale ve *specificitě*, jež dává vzniknout komplexním interakcím.
{{< /figures/quote >}}

Ve světě CSS nicméně vládne ještě jeden zákon, zvaný *specificita*, který toto jednoduché pravidlo komplikuje. Říká, že nezáleží jen na pořadí, ale i na typu deklarace. Různé typy deklarací mají totiž větší či menší *specificitu* a tím pádem potenciál přebít deklarace, které je sice následují, ale jejichž *specificita* je menší.

Rozhodujícím je v tomto ohledu *selektor*, kterým cílíme na HTML elementy, jichž se deklarace týká. Příkladem je `[data-foo="bar"]`, který najde všechny prvky s HTML atributem `data-foo` o hodnotě `bar`, nebo `.foo` a `#foo`, s jejichž pomocí vybereme ty elementy, jejichž `class`, respektive `id`, je rovno `foo`. Podstatné je, že jde o různé typy deklarací s různou *specificitou*.

*Selektory* lze navíc řetězit, čímž získáme deklarace jako `.foo p` nebo `.bar div p`. Důležité je, že *selektor* o větší hloubce — zde ten druhý — má větší *specificitu* a že oba přebijí jakoukoliv jednoduchou deklaraci typu `p` nebo `div`, byť by se ve zdrojovém souboru objevila až později.

V závěru na parket vstupuje magické klíčové slovo `!important`. Zoufalý vývojář, zahnán do kouta marným bojem se *specificitou*, jej použije jako zbraň hromadného ničení v momentě, kdy vyčerpal všechny ostatní možnosti. Výsledkem je většinou krátce trvající vítězství, které se obratem vrátí v podobě špatně udržitelného kódu. Použiju-li deklaraci `p { color: red !important; }`, mám sice takřka jistotu, že všechny odstavce nabydou kýžené barvy textu, ale pokud se záhy objeví konfliktní deklarace, taktéž využívající `!important`, vrátí se *specificita* v plné síle, neb je třeba rozhodnout, která zvítězí.

Problém CSS tedy nespočívá v kaskádě, která je jednoduchá a vede k logickému řazení deklarací, ale ve *specificitě*, jež dává vzniknout komplexním — tedy těžko předvídatelným — interakcím. Pokud si předem nerozmyslíme, jak tomu předejít, snadno nám pod rukama vznikne dlouhodobě neudržitelný kód.

## Technologie a metodika

Přístupy jsou dva. První je technologický a souvisí s frameworky typu React či Vue, ale i W3C specifikací [Web Components](https://github.com/w3c/webcomponents). Ty všechny nabádají k tvorbě malých samostatných komponent, které v rámci jednoho balíčku dodají nejen JavaScript a související HTML šablonu, ale případně i CSS. Výhodou je, že tyto styly platí jen na úrovni komponenty a neovlivňují globální CSS kontext, podobně jako nativní moduly v JavaScriptu. Zároveň nám nic nebrání nastavit obecné hodnoty v globálním kontextu, který se do komponent stále propíše. Výsledkem je samozřejmě menší riziko kolizí a lepší udržitelnost v podobě modulárního kódu. Nevýhodou je, že tímto způsobem vzniká závislost stylů na JavaScriptu, který je — jak jsem [popisoval dříve](/blog/princip-postupneho-vylepseni/) — narozdíl od CSS a HTML křehký.

Z toho důvodu jsme v Heurece zvolili druhou možnost, kterou je metodika. To znamená, že vybereme principy, které nám dávají smysl, pevně se jich držíme a necháme se vést, a odměnou nám je přehledný a předvídatelný kód. Zjevnou výhodou oproti předchozímu přístupu je absence komplikované technologie. Někdo se ovšem může zhrozit, že se najednou potýkáme s “měkkými” problémy jako je disciplína, komunikace a porozumění napříč týmy. Tíha zodpovědnosti pak padá na poctivé *code review* a neuškodí ani dobře spravovaná *styleguide* (ta naše je k vidění na [heureka.cz/ui](https://heureka.cz/ui)).

## Block, Element, Modifier

{{< figures/code >}}
```html
<nav class="breadcrumbs breadcrumbs--small">
    <ul class="breadcrumbs__list">
        <li class="breadcrumbs__item">
            <a class="breadcrumbs__link" href="…">Heureka.cz</a>
        </li>
        <li class="breadcrumbs__item">
            <a class="breadcrumbs__link" href="…">Internetové obchody</a>
        </li>
        <li class="breadcrumbs__item">
            <span class="breadcrumbs__link">Notino</span>
        </li>
    </ul>
</nav>
```
{{< /figures/code >}}

Obecně známých metodologií je více. Základem té naší je sada doporučení jménem *BEM*, neboli *Block, Element, Modifier*, která je založená na jednoduchém, ale nekompromisním pravidle, jenž velí nepoužívat jiné selektory než typu `.foo` a (až na konkrétní výjimky) zakazuje řetězení. Odměnou nám je, že předejdeme těm největším potížím se *specificitou*.

V samotném názvu *BEM* se skrývá další princip. Každá komponenta totiž představuje takzvaný *block*, který se může skládat z jednotlivých *elementů* a pomocí *modifikátorů* nabývat různých variant. Abychom je od sebe rozeznali, *BEM* každému z těchto prvků přisuzuje jinou syntax. Pokud vytvoříme komponentu (neboli *block*) s třídou `block`, pak její vnitřní *element* musí mít třídu `block__element` a případný *modifikátor* třídu `block--modifier`. I *elementy* mohou mít svůj *modifikátor*, který má podobu `block__element--modifier`. Pro příklad si ukážeme komponentu pro drobečkovou navigaci{{< figures/code-ref >}}.

Častou chybou je použití více `__` v názvu třídy pro určení stupně zanoření daného *elementu*. V předchozím příkladě bychom tedy místo třídy `breadcrumbs__link` mohli objevit něco na způsob `breadcrumbs__list__item__link`. To je zaprvé zbytečné — a zbytečně ošklivé — a zadruhé nám to přidá práci v případě, že se změní HTML struktura komponenty.

## Struktura

{{< figures/code >}}
```less
.breadcrumbs {
    …

    &--small { … }
    &--large { … }
}

    .breadcrumbs__list {
        …

        .breadcrumbs--small & { … }
    }

        .breadcrumbs__item {
            …

            @media (max-width: @lteLayout) {
                …
            }
        }

            .breadcrumbs__link {
                …

                &:not([href]) { … }
            }
```
{{< /figures/code >}}

V Heurece používáme CSS [*preprocesor Less*](http://lesscss.org/). Alternativou je o trochu známější [*Sass*](https://sass-lang.com/), který je oproti *Less* výrazně mocnější, ovšem za cenu toho, že se vzdaluje jednoduchému a deklarativnímu duchu CSS. Pro běžné použití *Less* stačí a záleží tedy spíše na osobních preferencích. Jedním z bonusů preprocesorů nicméně je, že každá komponenta sídlí ve vlastním souboru, třeba `breadcrumbs.less`{{< figures/code-ref >}}.

Na příkladu lze vypozorovat několik zajímavostí. *Elementy* se neřetězí s *blockem* a jsou to tedy jednoduché selektory. Zároveň jsou odsazené, aby reflektovaly HTML strukturu komponenty. To je pomůcka pro vývojáře, která je — narozdíl od zmíněného vícenásobného použití `__` — jednoduchá na údržbu.

Oproti tomu, *modifikátory* vkládáme pro přehlednost pomocí `&` (*parent selektoru*) přímo do deklarace *blocku*. *Modifikátory*  upravují vlastnosti *blocku*, ale většinou je třeba na jejich základě upravit i konkrétní *elementy*. Z toho důvodu jsme v případě *elementu* `breadcrumbs__list` (výjimečně) použili řetězení v podobě `.breadcrumbs--small & { … }`. Podobně se zachováme v případě `@media` bloku, kdy všechny relevantní změny vložíme přímo do deklarace *elementu*.

Poslední zajímavost spočívá v použití *selektoru* `&:not([href]) { … }`. Ten odporuje základnímu principu *BEM* a purista by namítl, že správný postup je použít *modifikátor*, třeba `breadcrumbs__link--current`. V Heurece se však snažíme ctít to, čemu staří Řekové říkali *fronésis* a co my nazýváme zdravý rozum, a nehnat se zbytečně do extrému. Může se dokonce stát, že v Heurece narazíte na komponentu, která popírá vše, co jsem dosud popsal{{< figures/code-ref >}}.

{{< figures/code >}}
```less
.breadcrumbs {
    …

    ul { … }
    li { … }
    a { … }
}
```
{{< /figures/code >}}

*BEM* to sice není, ale s jistým odstupem a při shovívavé náladě by i takový kód mohl projít skrze *review*. Jelikož jde o jednoduchou komponentu, lze tento prohřešek odpustit, protože daný HTML prvek jasně určuje konkrétní *element*. Jen o trochu složitější komponenta by nás o tento luxus připravila a museli bychom striktně trvat na použití tříd.

## Kompozice

Problém snadno vznikne v případech, kdy je třeba upravit vzhled či chování komponenty v závislosti na kontextu, neboli jejím umístění v HTML dokumentu. Kontextem můžou být například komponenty s názvy `article` a `category`, které reprezentují různé sekce webu a definují rozložení jejich základních stavebních prvků. Řekněme, že jedním z nich je i komponenta `breadcrumbs`, která má v každé sekci vypadat trochu jinak.

Nejspíš nás napadne vytvořit *selektor* `.article .breadcrumbs { … }`, respektive `.category .breadcrumbs { … }`. To však není moudrá volba. Záhy totiž zjistíme, že není jasné, kam takový *selektor* zařadit: do `breadcrumbs.less` nebo `article.less`? Tak či tak si zaděláme na problém, protože mezi komponentami zbytečně vytvoříme vazbu, která zkomplikuje budoucí úpravy, a otevřeme dveře *specificitě*.

Správné řešení závisí na míře a typu úprav. Jedná-li se o spíše povrchní změny, jako je barva pozadí či velikost textu, postačí vytvořit nové *modifikátory*. Ty můžeme nazvat obecně, třeba `breadcrumbs--small` či `breadcrumbs--large`, nebo — pokud nás nenapadne lepší označení a víme, že jde o specifické změny, které se nebudou opakovat — můžeme použít názvy typu `breadcrumbs--article` a `breadcrumbs--category`.

Když jde o větší změny — většinou na úrovni struktury či rozložení — je třeba přemýšlet o něco více. Naším zájmem je, aby komponenta byla dobře spravovatelná a zároveň co nejvíce znovupoužitelná. Komponentu (*block*) definuje její struktura, má tedy logicky kontrolu nad svým **vnitřním** uspořádáním a ví, zdali jsou její *elementy* řazené jako `block` nebo `inline` prvky, případně jestli je sama `flex` či `grid` kontejner. O svém **vnějším** rozložení a umístění by však neměla předjímat nic. Pokud v rámci komponenty `breadcrumbs` deklarujeme třeba `position: absolute`, zbytečně tím omezíme její znovupoužitelnost. Proto je lepší podobné deklarace přenechat komponentám, jejichž účelem je celkové rozložení stránky.

V našem případě jsou to komponenty `article` a `category`, vytvoříme proto dva nové *elementy* `article__breadcrumbs` a `category__breadcrumbs`. Jejich úkolem je umístit komponentu `breadcrumbs` v rámci dané sekce. Vzhled a vnitřní strukturu nadále obstarává třída `breadcrumbs`, z pohledu HTML má tedy výsledná komponenta podobu například `<nav class="breadcrumbs category__breadcrumbs">`. Toto skládání tříd, které nazýváme *kompozice*, nevytváří narozdíl od řešení typu `.category .breadcrumbs { … }` pevnou vazbu mezi jednotlivými komponentami a vyhýbá se *specificitě*, proto ho upřednostňujeme.

## Namespacing

*BEM* vznikl s úmyslem ulehčit vývojářům práci, a to nejen ve správě stylů, ale i v orientaci v kódu. Z toho důvodu předepisuje jasnou syntax pro názvy HTML tříd. Díky tomu okamžitě poznáme, s čím máme co do činění, ale proč zůstat jen u `__` a `--`? V Heurece jsme proto metodologii rozšířili o *namespacing*.

Na předchozím příkladu s třídami `breadcrumbs` a `category` jasně vidíme, že je mezi nimi rozdíl. První z nich představuje znovupoužitelnou komponentu, ta druhá udává celkové rozložení konkrétní sekce. Jde o kvalitativní rozdíl, který ze samotného názvu nemusí být zřejmý, proto čtenáři ulehčíme práci a na začátek třídy přidáme *namespace*. Z `breadcrumbs` se tak stane `c-breadcrumbs`, z `category` pak `l-category`. *Namespace* `c` (*component*) má jasný význam, který říká, že daná třída reprezentuje komponentu, tedy uzavřený modul s jasným, konkrétním použitím, které je vždy stejné. Oproti tomu `l` (*layout*) napovídá, že jde o třídu obstarávající rozložení stránky.

{{< figures/quote >}}
Ať už zvolíte jakékoliv řešení — nemusí to být nutně BEM — není důvod kaskádu zatracovat. Pokud ji (respektive sobě) nastavíte jasná a pevná pravidla, bude vám sloužit ku prospěchu.
{{< /figures/quote >}}

V Heurece používáme ještě tři takové *namespace*. První, který se jmenuje `e` (*element*), je významem shodný s `c`, ale s tím rozdílem, že nemá vnitřní strukturu, tedy žádné *BEM elementy*. Typickým příkladem je `e-button`, který má v HTML podobu například `<button class=“e-button”>Odeslat</button>`. Jedná se tedy o komponenty toho nejjednoduššího typu.

Další *namespace* je sice komplikovanější, ale významově hodnotnější. Označuje se `o` (*object*) a určuje třídy, které mají na starost lokální strukturu a rozložení prvků. Dobrým příkladem je dvojice `o-block-list` a `o-inline-list`. Právě `o` nám napoví, že jde o obecnější strukturu a ne konkrétní komponentu, jako například seznam s odrážkami, který má třídu `c-bullet-list`. V případě `o-block-list` se prvky (nazvané `o-block-list__item`) řadí pod sebe, v druhém případě vedle sebe. Oba *objekty* mají také řadu *modifikátorů* (třeba `o-block-list--loose`), pomocí kterých jednoduše ovlivníme třeba rozestupy mezi prvky. Podstatné je, že se *objekty* můžou vyskytnout ledaskde a za různým účelem, nelze tedy předjímat jejich použití. To je podstatná informace. Jako vývojář totiž vím, že *objekty* nemůžu ledabyle upravovat, protože jakákoliv změna může mít dalekosáhlé důsledky. Lepší (a bezpečnější) je proto přidávat nové *modifikátory*.

Poslední *namespace* představují takzvané *utility* třídy s předponou `u`. Mají vždy jeden konkrétní účel, který by měl být jasný z jejich názvu, typické jsou proto třídy typu `u-align-left` nebo `u-visually-hide`. Použít by se nicméně měly pouze ve chvíli, kdy nedává smysl vytvářet novou komponentu či *modifikátor*, třeba z důvodu, že se daná změna vyskytuje jen na jednom místě.

A přestože nejde o *namespace* v pravém slova smyslu, používáme i takzvané JavaScript *hooky*, které poznáme podle předpony `js`. S jejich pomocí můžeme v JavaScriptu cílit na konkrétní elementy, aniž bychom vytvořili pevnou vazbu mezi názvem komponenty a skriptem. Pokud chceme, aby komponenta `c-accordion` byla interaktivní, přidáme jí navíc třídu `js-accordion`. V případě, že se komponenta či její název z nějakého důvodu změní, *hook* může zůstat a skript nemusíme měnit. S JavaScriptem souvisí i speciální stavové třídy, jenž začínají na `is-` nebo `has-`, jako například `is-active`. Ty udávají aktuální stav komponenty, proto je spravujeme skrze JavaScript a používáme pro cílení stylů.

## Kaskáda: dobrý sluha, zlý pán

Ať už zvolíte jakékoliv řešení — nemusí to být nutně *BEM* — není důvod kaskádu zatracovat. Pokud ji (respektive sobě) nastavíte jasná a pevná pravidla, bude vám sloužit ku prospěchu. Důležité je v globálním měřítku dodržet trend rostoucí *specificity*, který zajistíme vhodným poskládáním souboru se styly za pomocí klíčového slova `@import`. První na řadu přijdou nejobecnější deklarace a normalizace — cílící na selektory typu `*`, `html` nebo `a` — které nastaví třeba základní typografická pravidla. Po nich následují jednotlivé komponenty. Přítomnost *namespacingu* situaci trochu komplikuje, protože je třeba určit, v jakém pořadí (tedy s jakou *specificitou*) je načteme. V našem případě začneme s *object*, neboť jde o nejobecnější prvky, pokračujeme s *layout*, *element* a *component*, které jsou víceméně na stejné úrovni, a končíme s *utility*, které musí mít nejvyšší *specificitu*. I v případě, že vymyslíte úplně jiný systém, měli byste stejnou úvahou dojít k řešení, které bude dávat smysl a, co je nejdůležitější, bude dlouhodobě udržitelné.