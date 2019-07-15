---
title: How to wrestle with browser support
translationKey: how-to-wrestle-with-browser-support
date: 2019-06-26
tags:
    - web
    - front-end
menu:
    main:
        parent: 'blog'
photoDesc: Glenn Carstens-Peters
photoUrl: https://unsplash.com/photos/6rkJD0Uxois
---

HTML is the foundation of web services. That is the conclusion of the previous article and the prerequisite that we build on when we enhance a service with JavaScript. But how to make JavaScript run only when we know the host environment — typically a browser — will handle it? And where to set the boundary that clearly divides users into two camps: with and without JavaScript?

<!--more-->

The essence of both questions lies in environment detection. Web is not a *binary* platform like iOS or Android, but a huge set of configurations. In principle, it is not possible to create a unified experience — the application must be **"responsive"** even from the perspective of *UX*. One way to detect an environment is to ask for its **name** and **version**, and make a decision based on the answer. Typically, we would look at the HTTP header `User Agent`[^1]. The header, though, gives us no guarantees and is often false, which makes this method useless. So, rather than ask for an environment's name, it's better to query about its **properties**[^2]. If the response meets our requirements, we can a make a confident and informed decision.

## Real users

Now it's time to set the boundary, which is a small set of **properties** we deem neccessary. If a browser can't "cut the mustard", it will receive a basic — but still useful — version without JavaScript. It's a good idea to use some form of **web analytics** at this point. It allows you to evaluate real users' environment (their browser, device and operating system) and decide not on intuition but hard data. If half of the users use Internet Explorer 8, it makes sense to choose a different approach than if there is just a handful of those poor souls.

What properties to choose? It's best to pick those we can't live without and which, if missing, we don't to want handle by *polyfilling* (we'll cover that later).

- `querySelector` (✝ *Internet Explorer 7*)
- `addEventListener` (✝ *Internet Explorer 8*)
- `classList` (✝ *Internet Explorer 9*)
- `Object.assign` (✝ *Internet Explorer 11*)
- `localStorage` (✝ *Opera Mini*)

If we are clear about the target group, we'll add a simple condition in our application (let's call it `app.js`) to verify the chosen properties. In case of failure, we will immediately stop execution of the script[^3]. If, however, the browser passes the test, we let the application do its job, and also add a `.js` class to the HTML document. Thanks to this last detail, we can deduce whether the application is running, even outside the context of the script (line in stylesheets). That will be helpful when designing components.

For example, let's make a component with the class `.accordion` and the following structure: a heading, which is also a `button`, and under it, a content, which is hidden by default and shows only after clicking the button[^4]. A common method is to hide the content, perhaps with `display: none`, and reveal it when, using JavaScript, we add the class `.is-active` on the component[^5]. However, if the script fails to load for any reason, the content is lost forever (or until we fix the problem). That's why we use the `.js` class and rewrite the component's styles so that the logic is reversed: the content is visible and hides only if we are certain the script is running[^6]. It's a trivial change with a major impact, truly in the spirit of the [progressive enhancement](/blog/progressive-enhancement/).

## *Polyfilling*

Vrátíme-li se zpátky k `app.js`, narazíme na další problém. Prohlížečům, které nejsou schopny aplikaci spustit, sice pomocí `return false` umožníme zachránit si tvář, ale přesto je nutíme stáhnout celý skript. A jeho velikost se v dnešní době běžně počítá na stovky kilobytů, ne-li jednotky megabytů. Lepší řešení má podobu malého skriptu `scout.js`, který má jediný úkol: provést test prostředí a nahrát zbytek aplikace[^7]. Tak snadné to ale samozřejmě nebude. Na základě podmínky v příkladu můžeme usoudit, že aplikace mimo jiné poběží i v Internet Exploreru 10 a 11. Avšak `fetch` — rozhraní pro tvorbu AJAX požadavků založené na *Promise* — právě v těchto prohlížečích chybí, skript by tedy zcela selhal.

Řešením pro chybějící rozhraní jsou již zmíněné *polyfilly*, neboli knihovny, které v případě potřeby chybějící funkcionalitu dodají. Načteme-li *polyfill* pro `fetch` před naším `scout.js`, máme vyhráno. S tím nám pomůže atribut `defer`, který zaručí, že se skripty vykonají v pořadí, které určíme, a to i v případě více souborů[^8]. Obratem se nám však vrátil původní problém. Prohlížeče, které neprojdou zkouškou v `scout.js`, poslušně — a zcela zbytečně — stáhnou všechny *polyfilly*, jejichž velikost snadno dosáhne několika stovek kilobytů. Měli bychom tedy přijít s lepším řešením.

Jedno z možných spočívá v rozšíření `scout.js` o logiku nahrávání *polyfillů*. U každého z nich se zeptáme, zdali je potřeba, a pokud ano, pak jej stáhneme. Když máme jistotu, že jsou všechny nutné knihovny načteny, stáhneme i zbytek aplikace[^9]. Jelikož v tomto příkladě jeden z *polyfillů* předpokládá chybějící podporu pro *Promise*, nemůžeme pro kontrolu načtení knihoven použít příhodné `Promise.all`, ale musíme implementovat vlastní (velmi naivní) řešení postavené na proměnné `counter`. V momentě, kdy dojde ke splnění podmínky `counter === 0`, víme s jistotou, že lze použít `fetch`.

## *Transpilace*

Stále však není dobojováno. Pozorní najdou v předchozím příkladu další problémy: Internet Explorer ve verzi 10 nerozumí klíčovému slovu `let`, verze 11 zase nechápe *arrow* funkce (`(...) => { ... }`), natož *destructuring* (`({ test })`). S potížemi tohoto typu nám *polyfilly* nepomohou, neboť se nejedná o chybějící API, ale o konflikt na úrovni samotné syntaxe jazyka. Ten lze řešit dvěma způsoby. První je zřejmý: použít pouze syntax, jejímž sítem projdou všechny vybrané prohlížeče. Pokud však nechceme slevit a toužíme využít všech možností jazyka, nezbývá nám, než zvolit metodu zvanou *transpilace*, která zdrojový kód převede do podoby stravitelné pro **specifikovanou** sadu prohlížečů. Nejlepším nástrojem pro tento účel je [Babel](https://babeljs.io/). Když jím proženeme náš příklad, je výstupem kód, který snesou i poslední dvě verze Internet Exploreru[^10].

Výsledkem celého snažení je tedy kombinace dvou skriptů, `scout.js` a `app.js`, které zajistí, že naše služba s jistotou poběží v jasně určené množině prohlížečů, ale zároveň zbytečně nezatíží ty uživatele, v jejichž prohlížečích nemá smysl stahovat a spouštět JavaScript. O to důležitejší je pak **správný návrh aplikace** a dodržení [principu postupného vylepšení](/blog/princip-postupneho-vylepseni/). V dalších článcích prozkoumáme, jak podobný přístup použít v i případě *frameworků* jako je React.

[^1]:
    ```js
    if (navigator.userAgent.indexOf('Chrome') !== -1) {
        var myMap = new Map();
        // ReferenceError: Map is not defined.
    }
    ```

[^2]:
    ```js
    if ('fetch' in window) {
        fetch('https://example.com').then(response => {
            // No worries.
        });
    }
    ```

[^3]:
    ```js
    if (
        !document.querySelector
        || !window.localStorage
        || !('classList' in document.createElement('_'))
    ) {
        return false;
    }

    document.documentElement.classList.add('js');
    …
    ```

[^4]:
    ```html
    <section class="accordion">
        <button class="accordion__button"><h3>Lorem ipsum</h3></button>
        <p class="accordion__content">Consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
    </section>
    ```

[^5]:
    ```scss
    .accordion { … }

        .accordion__content {
            display: none;
            …

            .accordion.is-active & { display: block; }
        }
    ```

[^6]:
    ```scss
    .accordion { … }

        .accordion__content {
            …

            .js & { display: none; }
            .js .accordion.is-active & { display: block; }
        }
    ```

[^7]:
    ```js
    if (
        !document.querySelector
        || !window.localStorage
        || !('classList' in document.createElement('_'))
    ) {
        return false;
    }

        fetch('app.js');
    }
    ```

[^8]:
    ```html
    <script src="js/lib/promise.js" defer></script>
    <script src="js/lib/whatwg-fetch.js" defer></script>
    <script src="js/lib/pep.js" defer></script>
    <script src="js/scout.js" defer></script>
    ```

[^9]:
    ```js
    if (
        !document.querySelector
        || !window.localStorage
        || !('classList' in document.createElement('_'))
    ) {
        return false;
    }

    function loadScript(src, callback) {
        let scriptEl = document.createElement('script');

        scriptEl.addEventListener('load', callback.bind(window));
        scriptEl.src = src;
        document.head.appendChild(scriptEl);
    };

    let polyfills = [
        {
            src: 'js/lib/promise.js',
            test: 'Promise' in window
        },
        {
            src: 'js/lib/whatwg-fetch.js',
            test: 'fetch' in window
        },
        {
            src: 'js/lib/pep.js',
            test: 'PointerEvent' in window
        }
    ];

    let reqPolyfills = polyfills.filter(({ test }) => !test);
    let counter = reqPolyfills.length;

    reqPolyfills.forEach(({ src }) => {
        loadScript(src, function() {
            counter--;

            if (counter === 0) { // All polyfills loaded.
                fetch('app.js').then(() => {
                    document.documentElement.classList.add('js');
                });
            }
        });
    });
    ```

[^10]:
    ```js
    var reqPolyfills = polyfills.filter(function(_ref) {
        var test = _ref.test;
        return !test;
    });
    ```
