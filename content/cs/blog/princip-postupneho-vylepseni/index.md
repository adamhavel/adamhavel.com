---
title: Princip postupného vylepšení
translationKey: progressive-enhancement
date: 2019-06-17
tags:
    - web
    - front-end
menu:
    main:
        parent: 'blog'
photoDesc: Debby Hudson
photoUrl: https://unsplash.com/photos/bAYP_kAtNWg
---

Od svého zrodu prošel JavaScript, spolu s celým internetem, obrovským vývojem a z neškodně působícího jazyka se stal moloch, na jehož bedrech spočívá nemalá tíha webů, které dnes používáme. Ostatně stačí provést malý pokus. JavaScript v prohlížeči na chvíli vypneme a záhy zjistíme, že se nám web před očima rozpadá rychleji než důvěra v dobré úmysly Facebooku.

<!--more-->

Samozřejmě se musíme ptát, kolik uživatelů má potřebu vypínat JavaScript, a správně tušíme, že malý zlomek. Skutečnost je ovšem složitější. Mezi uživatele bez JavaScriptu se totiž snadno zařadíme i jinak: stáhne se stránka, ale už ne skript, který web potřebuje pro svůj chod. Možných důvodů je spousta: chyba v požadavku, firewall, timeout („metro vjelo do tunelu”), manipulace na straně poskytovatele připojení či hostingu, nebo třeba rozšíření v prohlížeči typu AdBlock.

Druhý typ problémů je zákeřnější: skript se sice stáhne, ale nevykoná. Čím to? JavaScript je komplikovaný jazyk, navíc bez statické kontroly typů. Není tedy divu, že často narazíme na chyby, které se projeví až za běhu. S tím se dá žít — a pokud ne, nic nám nebrání využít řešení typu TypeScript. Horší je to s podporou prohlížečů.

JavaScript je v programátorských kruzích častým terčem posměchu. Málokdo však dokáže docenit, v jak nepřátelském prostředí — tím myslím prohlížeč — musí JavaScript konat svou práci. Pokud vyvíjíme v Pythonu, máme jistotu, že aplikace poběží na serveru s danou verzí jazyka. V případě JavaScriptu (s výjimkou Node.js) nemáme jistoty žádné. Hostitelské prostředí je kombinací zařízení, operačního systému a prohlížeče — z praktického pohledu tedy nekonečná množina. Je div, že naše aplikace vůbec někdy funguje!

## Odolné technologie

Ve světle posledních odstavců se JavaScript poprávu jeví jako křehká technologie, na níž ovšem — jak jsme si ověřili — závisí většina webů, jež dnes používáme. Tohle břímě ale samozřejmě nenese sama a sdílí ho s řadou dalších technologií. Jedna z nich je natolik jednoduchá, že už ji za technologii snad ani nepovažujeme: HTML.

Krom toho, že je jednoduché, je HTML deklarativní — popisujeme skrze něj, **co** se má zobrazit nebo stát a neřešíme, **jak** se to stane. Tím se snižuje prostor pro chyby. HTML má navíc další pozoruhodnou vlastnost: když už k chybě dojde, není následkem katastrofické selhání.

Narazí-li prohlížeč na chybu v HTML[^1], třeba neznámý nebo neuzavřený element, zcela ji ignoruje a pokusí se obsah přesto vykreslit. Pokud bychom místo toho zvolili XHTML, zlé dvojče HTML, dostaneme ve stejném případě za trest místo obsahu jen výpis chyby. O použití XHTML však nikdo soudný neuvažuje. K čemu je nám tedy HTML dobré? Vytvoříme v něm základy našeho webu. A to základy, na které se lze vždy spolehnout — ve světě front-endu nevídaná věc.

## Odkazy a formuláře

Z pohledu prohlížeče spočívá většina webů na dvou pilířích: navigaci a komunikaci. K navigaci slouží *hyperlinky*, deklarativní metoda pro propojení dvou dokumentů, které známe jako skromné — ale mocné — odkazy. Druhým pilířem je komunikace mezi prohlížečem a vzdáleným serverem. I tuto roli zčásti zastupují odkazy. Pokud však serveru chceme poslat více než jen jednoduchá data, uplatníme jinou metodu: formulář[^2].

Formulář má jednoduché, **deklarativní** rozhraní. Prvním bodem je atribut `action`, který určuje adresu, na které vzdálený server přijme naše data. Obsah patří do elementů `input` nebo `textarea`, pomocí jejichž atributů `type`, `required` nebo `pattern` omezíme, co je možné odeslat. Posledním nutným prvkem je element `button`, jehož `type` — není-li řečeno jinak — je `submit`. Slouží tedy k odeslání formuláře.

Funkci formuláře můžeme **nahradit** JavaScriptem a **vylepšit** o AJAX volání[^3]. Zlom nastane po odeslání formuláře kliknutím na `button`, kdy náš kód — pomocí `ev.preventDefault()` — zabrání běžnému chování prohlížeče. Následný postup je pak zcela v našich rukou, ale přinejmenším musíme z formuláře vytáhnout data, poslat je ručně na server a zpracovat odpověď. Jelikož jde o AJAX a ne běžný požadavek, odpověď čekáme ve formátu JSON, nikoliv HTML, což serveru naznačíme použitím HTTP hlavičky `Accept: 'application/json'`.

Pokud ovšem kód z příkladu nerozšíříme, přijdeme o validaci dat, kterou za nás v čistém HTML obstará prohlížeč na základě našich deklarací v podobě atributů na `input` elementech. Zdali jsou data ve správném formátu, musíme kontrolovat sami a v případě chyby ručně zobrazit i hlášení. Rychle si pak vzpomeneme na kouzlo jednoduchého a deklarativního kódu, protože najednou řešíme nejen **co** se má stát, ale i **jak** k tomu dojde.

## „Minimum Viable Experience”

Zpátky v bezpečí HTML: tušíme, že pomocí zmíněných metod — odkazů a formulářů — lze vytvořit základy webové služby. A právě z tohoto výchozího bodu se vydáme ve směru onoho tajemného principu postupného vylepšení (*progressive enhancement*) z nadpisu. Určíme takzvané „Minimum Viable Experience”: jaké metody musí služba **v každém případě** nabídnout, aby naplnila důvod své existence? Metody vytvoříme pomocí té nejjednodušší (tedy nejodolnější) možné technologie. Jedině pak máme **jistotu**, že služba — bez ohledu na hostitelské prostředí — zajistí svou základní funkci. A teprve tehdy si můžeme dovolit použít JavaScript, službu dál **vylepšovat** dle libosti, a přesto mít klidné spaní.

Postup vyzkoušíme na aplikaci typu Google Docs. Základy postavíme na kombinaci elementů `textarea`, `input` a `form`, pomocí kterých odešleme data vzdálenému serveru, aby je uložil v databázi a zpřístupnil odkudkoliv. Máme-li tak základní funkci pojištěnou, nic nám nebrání zážitek vylepšovat. Ušetříme uživateli ruční schvalování formuláře a obsah při změně odešleme automaticky skrze AJAX. V dalším kole vylepšení obsah uložíme do `localStorage`, čímž zajistíme, že se neztratí v případě, kdy je server nedostupný, a odešle se, až když je server znovu k dispozici. Nakonec použijeme třeba *WebSocket* a umožníme více uživatelům spolupracovat v jeden moment nad jedním dokumentem.

Pokud kterékoliv z vylepšení selže, ať už z důvodu nedostatečné podpory na straně prohlížeče, špatnému připojení nebo chybě v JavaScriptu, víme s jistotou, že **uživatelé nepřijdou o základní funkce služby**. Tou je v našem příkladu uložení obsahu v cloudu, vylepšení je pak tím, co službu odlišuje od konkurence. Ta je ostatně dobrou motivací pro princip postupného vylepšení. Byť se totiž zdá, že jde o jednoduchou, ba triviální, metodu, málokterá webová služba naplňuje jeho podstatu. Pokud tedy využijeme příležitost a navrhneme odolnější aplikaci, získáme přirozenou výhodu. Další motivace tkví v tom, že všem uživatelům — bez ohledu na to, zdali mají staré zařízení nebo prohlížeč — nabídneme funkční službu. Běžný postup naopak velí, abychom vyšli z opačného konce, kterým je web závislý na JavaScriptu nebo konkrétním frameworku, a až v závěsu řešili, jak aplikaci přiblížit co největšímu počtu uživatelů — pomocí *fallbacků*, *polyfillů* a podobně. Z praktických důvodu však tímto směrem dřív nebo později dojdeme do bodu, kdy podpora přestane dávat smysl. Uživatelé, kteří jsou za hranicí této bubliny, mají smůlu.

Princip postupného vylepšení je jednoduchá metoda, která spíše než na konkrétním technologickém řešení spočívá ve **změně přístupu** při návrhu aplikace. A ač se zdá, že jde o více práce, opak je ve výsledku pravdou. Na oplátku totiž získáme v podstatě univerzální podporu v prohlížečích a jistotu, že se aplikace nerozpadne pod nejmenším tlakem. Princip lze shrnout do jednoho doporučení: používat JavaScript, ale **nespoléhat** na něj, a využít deklarativní prostředky, které nabízí HTML. V praxi to znamená **strukturovaný** a **sémanticky správný** dokument, a ne „guláš” `div` elementů, které jsou ze své podstaty bez významu a funkce.

V dalších článcích se zaměříme na praktický a strategický přístup k podpoře JavaScriptu v prohlížečích, a na to, jak zachovat princip postupného vylepšení při použití nástrojů jako je React a jemu podobných.



[^1]:
    ```html
    <html>
        <head>
            <title>HTML is resilient</title>
            <meta name="author" value="Tim Berners-Lee">
        </head>
        <body>
            <section>
                <p>Lorem ipsum dolor sit emet.
            </Section>
        </body>
    </html>
    ```

[^2]:
    ```html
    <form action="/search" class="js-form">
        <label for="search">Term</label>
        <input
            type="text"
            id="search"
            name="q"
            required
            pattern=".{3,}"
        />
        <label>
            I'm feeling lucky
            <input type="checkbox" name="lucky" />
        </label>
        <button>Search</button>
    </form>
    ```

[^3]:
    ```js
    let formEl = document.querySelector('.js-form');

    formEl.addEventListener('submit', function(ev) {
        ev.preventDefault();

        let body = new FormData(this);
        let isLucky = body.get('lucky');

        fetch(this.getAttribute('action'), {
            method: 'POST', body,
            headers: { Accept: 'application/json' }
        })
            .then(res => res.json())
            .then(res => {
                if (isLucky) return window.location(res[0].url);
                ...
            });
    });
    ```