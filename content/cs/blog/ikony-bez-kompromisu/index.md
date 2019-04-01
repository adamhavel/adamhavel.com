---
title: Ikony bez kompromisů?
translationKey: the-perils-of-icon-systems
date: 2018-11-22
tags:
    - web
menu:
    main:
        parent: 'blog'
photoDesc: Starbucks — Khadeeja Yasser
photoUrl: https://unsplash.com/photos/3U9L9Chc3is
---

Ikony nepatří mezi nejpalčivější problémy, se kterými se při vývoji na webu musíme potýkat, ale přesto lze najít pár zajímavých problémů. Jak ikony spravovat a jakým způsobem je zobrazit uživateli? Jeden přístup střídá další — každý o trochu lepší než ten předchozí, každý svým způsobem nedokonalý.

<!--more-->

Vrcholem této snahy je takzvaný SVG *sprite*. Ten vznikne tak, že jednotlivé ikony, respektive jejich SVG, vložíme do elementů typu `symbol` v rámci jednoho souboru[^1]. Důvodem pro použití symbolů je fakt, že se nevykreslí v místě definice, ale až tam, kde je skutečně použijeme. Pokud *sprite* nechceme vytvářet ručně, lze si pomoct nástrojem typu [*grunt-svgstore*](https://github.com/FWeinb/grunt-svgstore) nebo [*gulp-svgsprite*](https://github.com/jkphl/gulp-svg-sprite).

Pro vykreslení konkrétní ikonky stačí přímo do HTML šablony napsat jeden řádek SVG kódu obsahující element `use`, jehož atributem `xlink:href` odkážeme na `id` dané ikony[^2]. Všimněte si, že narozdíl od předchozího příkladu, kdy šlo o samostatný SVG soubor, nemusíme v případě SVG uvnitř HTML nastavit atribut `xmlns`.

Samotné použití *spritu* je o trochu složitější, protože žádná verze *Internet Exploreru* (narozdíl od *Edge*) nedokáže nahrát externí soubor přes `xlink:href`. Řešení jsou dvě: buď *sprite* vložíme přímo do všech šablon, nebo použijeme AJAX. První případ lze řešit automaticky na straně serveru, ale z hlediska *cachování* nejde o ideální způsob. Druhá možnost spočívá v použití skriptu[^3], který dáme do elementu `head` v šabloně. Výhodou je, že se krom ikon dá použít i na další soubory jako třeba fonty.

Skript načte zadaný soubor v pozadí, jeho obsah uloží do `localStorage` a zároveň vloží do šablony: styly pomocí `style` elementu, SVG soubory přímo do hlavičky. V druhém případě by jistě bylo lepší cílit na tělo dokumentu, ale to v momentu zavolání funkce ještě neexistuje. SVG sice není standardní součastí `head`, ale podstatné je, že předchozí metoda funguje.

Výhoda skriptu spočívá v tom, že jím načtené soubory neblokují vykreslení dokumentu. Má to ovšem jeden háček: ikony se nenačtou, pokud je JavaScript vyplý, a bohužel nevím o žádném řešení (jako je `noscript` v případě stylů), které nevyžaduje, aby byl sprite dopředu součástí dokumentu. Závěrem je, že na ikony není spoleh a vždy by u nich měl být textový popisek.

Pokud se nic nepokazí, ikony se vykreslí v podstatě okamžitě — samozřejmě s ohledem na rychlost sítě. Při druhém načtení dokumentu by prodleva měla být ještě kratší, jelikož se ikony nahrávají přímo z `localStorage`. To sice pro čtení a zápis vyžaduje synchronní — tedy blokující — operaci, ale přesto by mělo být dostatečně rychlé a zároveň spolehlivější než klasická cache v prohlížeči.

Nejhorší máme za sebou a konečně se můžeme pustit do kladných aspektů. V momentě, kdy SVG vložíme přímo do dokumentu, stane se součastí DOMu — včetně vnitřní struktury. To znamená, že můžeme upravovat všechny jeho součásti, například měnit barvu podle kontextu pomocí CSS proměnné `currentColor`. Ale to umí i ikony zabalené do podoby fontu. Podstatné je, že v případě SVG lze měnit jakoukoliv vlastnost, nejen barvu.

Existuje několik způsobů, jak ikony nastylovat. První z nich předpokládá použití atributů — jako třeba `fill="currentColor"` — přímo na samotné ikoně (nebo jejích částech). Jelikož se však většina ikon bude chovat podobně, vyplatí se jejich vzhled nastavit globálně. Možností je CSS vložit přímo do spritu a tím zacílit všechny symboly. Ale s ohledem na to, jak se sprite vytváří, může jít o zbytečnou komplikaci. Schůdnější je vydat se cestou globálních stylů a vlastnosti jako `fill` nebo `stroke` nastavit přímo v nich. Nesmíme ale zapomenout na dva důležité faktory: kaskádu a specificitu.

Předpokládáme-li ve všech případech stejný selektor, pak CSS nastavené přes atribut `style` přímo na původních elementech `symbol` přebíjí vše ostatní. Následují styly vložené navrch samotného spritu a hned za nimi atributy typu `fill` nebo `stroke` (znovu použité na úrovni samotných ikon). Jako poslední se bere ohled na globální styly ve vnějším dokumentu.

Zmíněná kaskáda pravidel ukazuje, že můžeme zvolit řadu způsobů, jak ovlivnit vzhled ikon. Podle mě je nejlepší držet se globálních stylů a při tvorbě spritu z ikon odstranit veškeré atributy. Pokud zjistíme, že potřebujeme ikonku, která by neměla měnit barvu v závislosti na kontextu (např. loga sociálních sítí), můžeme využít atribut `style` a ten neodstraňovat. Další trik spoléhá na proměnnou `currentColor`: část ikony obarvíme pomocí vlastnosti `fill` s konkrétní hodnotou, jinou pak s hodnotou nastavenou právě na `currentColor`. Tím získáme způsob, jak dynamicky ovlivnit dvě různé části ikony změnou barvy buď ve `fill` nebo v `color`.

Pro správné vykreslení je třeba, aby každý symbol obsahoval atribut `viewbox`. Krom toho ovšem není od věci nastavit i základní rozměry na úrovni SVG elementu v šabloně[^4]. Pokud SVG žádné nemá — ať už ze strany atributů `width` a `height` nebo v rámci CSS — zobrazí se o velikosti 300 na 150 pixelů. To se může stát relativně snadno: když se styly nepodaří nahrát, anebo předtím, než se projeví (v případě, kdy se načítají asynchronním způsobem).

Dalším zajímavým atributem je `role`. Pokud chcete, aby čtečky obsahu považovaly ikonku za obrázek, nastavte jej na `image`. Ale vzhledem k tomu, že by se ikony vždy měly vyskytovat v páru s textovým popiskem, je lepší skrýt je před zraky čteček úplně. Toho snadno dosáhneme pomocí atributu `aria-hidden` s hodnotou `true`[^5]. Pokud chcete za každou cenu použít ikonku bez popisku, popište její význam alespoň pomocí atributu `aria-label`[^6].

V případě, že vyžadujete, aby se ikonky zobrazovaly i v prohlížečích, které nepodporují SVG, je nutné provést několik dalších kroků. Zaprvé je třeba vytvořit PNG verze všech ikonek. Druhým krokem je ověřit podporu SVG — toho lze docílit buď pomocí knihovny [*Modernizr*](https://modernizr.com) nebo dotazem na objekt `document.implementation`. Další postup spočívá v jednoduchém nahrazení SVG elementů klasickým `img` s odkazem na PNG verzi dané ikonky.

Pro začátek je třeba získat `id` ikonky, abychom mohli vytvořit URL rastrové verze. Jelikož však prohlížeč nepodporuje SVG, nerozumí ani jeho struktuře, což znamená, že neumí přímo přečíst atribut `xlink:href`, kde se `id` nachází. Řešením je použít regulární výraz, který spustíme nad rodičem ikonky, respektive jeho `innerHTML`[^7]. Další problém se týká *Internet Exploreru 8*, který této náhradní ikoně přisuzuje nulové rozměry. Pomůžeme mu tím, že vedle ikony vložíme další prvek (třeba `div`) o stejné velikosti[^8].

Poslední příklad se týká situace, kdy chceme ikonku použít v seznamu položek místo klasické odrážky. Zároveň předpokládáme, že je odrážka graficky natolik složitá, že se nedá vytvořit jen pomocí CSS nebo Unicode symbolů. Možným řešením je vložit ikonku (pomocí elementu `use`) do každé položky zvlášť. Pokud se však chceme vyvarovat zbytečného opakování, nezbyde nám, než se obrátit na CSS. Ale i kdybychom SVG vložili přímo do globálních stylů (přes `data-uri`), ikonky svou barvu — v závislosti na tom, kde se seznam vyskytuje — nezmění. Pro tyto případy by se daly použít ikony zabalené do podoby fontu, stačila by pak jednoduchá změna barvy textu. To by ovšem vyžadovalo dva nezávislé systémy.

Ve snaze vyřešit tento problém jsem vyzkoušel přístup, který využívá CSS filtry, konkrétně `drop-shadow`. Narozdíl od vlastnosti `box-shadow`, která vytváří obdélníkové stíny (včetně zakulacených rohů a případných transformací), bere `drop-shadow` v potaz přesný tvar prvku. Pokud skryjeme odrážku, která stín vytváří, stačí správně nastavit barvu samotného stínu. To nám umožňuje na základě jedné ikony vytvořit různě barevné verze.

Nechat odrážku zmizet ovšem není tak jednoduché, jak se zdá. Pokud ji skryjeme pomocí průhlednosti nebo vlastnosti `background-position`, zmizí spolu s ní i stín. Zbývá nám ještě jeden způsob: posunout ikonu pomocí `position` a nastavit rodičovskému prvku `overflow` na `hidden`. Relevantní posun v `drop-shadow` filtru nastavíme na zápornou hodnotu posunu samotné odrážky a výsledkem je, že zůstane vidět právě jen stín[^9]. Heuréka!

O elegantní řešení však nejde ani zdaleka. Zaprvé, podpora CSS filtrů chybí ve všech verzích *Internet Exploreru*. Zadruhé, používat filtry v podobném rozsahu může (ale nemusí) zpomalit vykreslení stránky. A to nejhorší na konec: ač funkční v předchozích verzích *Chrome*, v té poslední nefunguje ani metoda s posunem odrážku mimo rodičovský element — stín se jednoduše nezobrazí.

Takže nám zbývá jen jedno rozumné řešení, a to vkládání ikon přímo do stylů v podobě *data URI*. Tato technika nám ušetří síťový požadavek a umožní upravovat vlastnosti ikon přímo v CSS. V případě, že použijeme preprocesor jako *LESS* nebo *Sass*, a máme v plánu ikonku použít na více než jednom místě, můžeme vytvořit funkci (neboli *mixin*), jejímž vstupem bude barva[^10]. To nám sice nepomůže s repeticí ve výsledném CSS, ale zachováme jediný zdroj pro případnou úpravu ikonky. Navíc, čím častěji ji použijeme, tím menší podíl pak bude mít na velikosti výsledného komprimovaného CSS souboru.



[^1]:
    ```xml
    <svg xmlns="http://www.w3.org/2000/svg">
        <symbol viewBox="0 0 32 32" id="close">
            <path d="..." />
        </symbol>
        <symbol viewBox="0 0 32 32" id="search">
            <path d="..." />
        </symbol>
        ...
    </svg>
    ```

[^2]:
    ```xml
    <svg>
        <use xlink:href="sprite.svg#search"></use>
    </svg>
    ```

[^3]:
    ```js
    (function(w) {
        'use strict';

        function getType(src) {
            return src.match(/\.([^\.\?]+)(?:\?.*)?$/)[1];
        }

        function injectContent(content, type) {
            if (type === 'css') {
                var style = document.createElement('style');
                document.head.appendChild(style);
                style.textContent = content;
            } else {
                document.head.insertAdjacentHTML('beforeend', content);
            }
        }

        w.loadFile = function(src) {
            if (!w.localStorage || !w.addEventListener) {
                return false;
            }

            var content = localStorage[src];

            if (content) {
                injectContent(content, getType(src));
            } else {
                var xhr = new XMLHttpRequest();

                xhr.addEventListener('load', function() {
                    localStorage[src] = xhr.responseText;
                    injectContent(xhr.responseText, getType(src));
                });

                xhr.open('GET', src);
                xhr.send();
            }
        };

    })(window);
    ```

[^4]:
    ```xml
    <svg width="32" height="32" class="e-icon">
        <use xlink:href="#search"></use>
    </svg>
    ```

[^5]:
    ```html
    <button>
        <svg aria-hidden="true">
            <use xlink:href="#search"></use>
        </svg>
        <span>Search</span>
    </button>
    ```

[^6]:
    ```html
    <button>
        <svg role="image" aria-label="Search">
            <use xlink:href="#search"></use>
        </svg>
    </button>
    ```

[^7]:
    ```js
    if (!document.implementation.hasFeature('http://www.w3.org/TR/SVG11/feature#Image', '1.1')) {
        [].forEach.call(document.querySelectorAll('svg.e-icon'), function(icon) {
            var fallbackIcon = document.createElement('img');
            var placeholder = document.createElement('div');
            var parent = icon.parentNode;
            var type = parent.innerHTML.match(/xlink:href=["']?#([^"'>\s]+)["']?/i)[1];

            fallbackIcon.classList.add('icon');
            placeholder.classList.add('j-icon-placeholder');
            fallbackIcon.src = 'img/' + type + '.png';

            parent.insertBefore(placeholder, icon.nextSibling);
            parent.replaceChild(fallbackIcon, icon);
        });
    }
    ```

[^8]:
    ```css
    .e-icon,
    .j-icon-placeholder {
        width: 1em;
        height: 1em;
        display: inline-block;
        vertical-align: middle;
        position: relative;
        top: -.075em;
    }

    .e-icon {
        fill: currentColor;
    }
    ```

[^9]:
    ```scss
    .c-bullet-list {

        > li {
            position: relative;
            padding-left: 1.5em;
            overflow: hidden;

            &:before {
                $size: 1em;

                width: $size;
                height: $size;
                content: '';
                position: absolute;
                top: ($lineHeight * .5em) - ($size / 2);
                left: -$size;
                background: url('img/icon/arrow.svg') center no-repeat;
                background-size: auto 100%;
                color: cyan;
                filter: drop-shadow($size 0 0 currentColor);
            }

            .no-cssfilters & {
                overflow: visible;

                &:before {
                    left: 0;
                }
            }
        }
    }
    ```

[^10]:
    ```scss
    @function bullet($color) {
        @return url('data:image/svg+xml;charset=utf-8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10.7 16"><path fill="#{$color}" d="M.7 2.7L6.4 8 .6 13.3 2.4 15 10 8 2.4 1 .7 2.7z"/></svg>');
    }
    ```