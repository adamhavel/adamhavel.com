---
title: Progressive enhancement
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

Since its inception, JavaScript, along with the whole internet, has come a long way. The harmless little scripting language became a moloch, on whose shoulders rests the weight of many of the websites we use everyday. And it takes just a little experiment to validate this statement. Turn off the JavaScript support in your browser and you will quickly find that the internet is falling apart before your eyes, maybe as fast as your trust in Facebook's good intentions.

<!--more-->

Of course, there is the question of how many users actually turn off JavaScript in their browsers. We would be right if we guessed that only an insignificant fraction. But the reality is more complicated. Unfortunately, it's easy to turn into a user sans JavaScript: a page has downloaded, but not the script the website needs to run. There are many reasons this could happen: request error, firewall, timeout, content manipulation on the side of your connection or hosting provider, or a browser extension like the AdBlock.

There is a second class of problems: a script downloads, but does not execute. How so? JavaScript is a complicated language and on top of that, it has no static type check. So, it's no surprise that we often make mistakes that will show up only at runtime. But we can live with that. If not, there is nothing holding us from using solution like TypeScript. The other, the worse, reason this happens is because of browser support.

JavaScript is an easy and frequent target for mockery. Few, however, can appreciate the hostility of the hosting environment — the browser. When we work with language like Python, we are usually sure the application will execute on a server with some, but exact, version of the language. In the case of JavaScript (with the exemption of Node.js), there are no certainties. The environment is a combination of a device, operating system, and browser. From a practical point of view, an infinite set. It's a wonder that our application ever works!

## Resilient technologies

In light of the previous paragraphs, JavaScript is a fragile technology, on which, however, most of the internet depends. Of course, it shares this burden with many other technologies. One of them is so simple that we forget to consider it a technology at all: HTML.

Apart from being simple, HTML is declarative: we describe **what** we want to see or happen, and not **how** that happens. That reduces the chance of making an error. On top of that, HTML has another remarkable feature: when an error does occur, it is not followed by catastrophic failure.

When browser comes upon an error in HTML[^1], for example an unknown element, it will ignore it and render the document anyway. If we instead chose XHTML, the evil twin of HTML, we would only get an error message. That’s why nobody sane uses it. But why is HTML relevant? Because we can use it to build the foundation of our web service, one that is resilient and reliable. In the world of front-end development, that is a remarkable thing.

## Links and forms

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