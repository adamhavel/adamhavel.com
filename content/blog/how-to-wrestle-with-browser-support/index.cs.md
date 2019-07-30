---
title: Jak vyzrát na podporu prohlížečů
slug: jak-vyzrat-na-podporu-prohlizecu
date: 2019-06-26
keywords:
    - web
    - front-end
menu:
    main:
        parent: 'blog'
photoDesc: Glenn Carstens-Peters
photoUrl: https://unsplash.com/photos/6rkJD0Uxois
---

Základem webové služby je HTML. To je závěr [předchozího článku](/blog/princip-postupneho-vylepseni/) a předpoklad, na kterém stavíme, když službu s pomocí JavaScriptu zlepšujeme. Jak ovšem zajistit, aby se JavaScript spustil jen tehdy, kdy máme jistotu, že to hostitelské prostředí — typicky prohlížeč — snese? A jak stanovit hranici, která uživatele jasně rozdělí na dva tábory: s JavaScriptem a bez?

<!--more-->

{{< figures/code >}}
```js
var UA = navigator.userAgent;

if (UA.indexOf('Chrome') !== -1) {
  var myMap = new Map();
  // ReferenceError: Map is not defined.
}
```
{{< /figures/code >}}

{{< figures/code >}}
```js
if ('fetch' in window) {
  fetch('https://example.com').then(response => {
    // No worries.
  });
}
```
{{< /figures/code >}}

Podstata obou otázek spočívá v problému detekce prostředí. Web není *binární* platforma jako iOS nebo Android, ale obrovská množina konfigurací. Z principu tedy není možné vytvořit jednotný zážitek a aplikace musí být **„responzivní“** i z pohledu *UX*. Jednou cestou, jak s problémem naložit, je tázat se prostředí na jeho **název** a **verzi**, a na základě odpovědi zvolit postup. Typicky se ptáme na HTTP hlavičku `User Agent`{{< figures/code-ref >}}. Ta nám ovšem nedává žádnou záruku o své pravdivosti a snadno se může stát, že narazíme na prostředí, které se tváří býti něčím, čím není. Takový postup tedy stojí na velmi vratkých nohách. Lepší se neptat, s jakým prostředím máme tu čest, ale jaké jsou jeho **vlastnosti**{{< figures/code-ref >}}. Splní-li tázaný naše požadavky, můžeme se na odpověď víceméně spolehnout.

## Skuteční uživatelé

Když už víme, jak správně ověřit prostředí, je třeba rozhodnout, kde udělat onu dělící čáru. Zvolíme sadu **vlastností**, přes které „nejede vlak“ — prohlížeče, které testem neprojdou, obdrží sice základní, ale stále užitečnou verzi bez JavaScriptu. V tuto chvíli je nutné použít nějakou formu **webové analytiky**, zhodnotit naše skutečné uživatele z pohledu prostředí (tedy prohlížeče, zařízení a operačního systému) a rozhodnout se na základě měřitelných dat. Pokud půlka našich uživatelů používá Internet Explorer 8, volíme přirozeně jiný postup, než pokud je takových uživatelů pár promile.

{{< figures/code >}}
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
{{< /figures/code >}}

Jaké vlastnosti zvolit? Nejlepší je vybrat ty, bez kterých se neobejdeme a jejichž absenci nechceme řešit pomocí jiných metod, jako jsou *polyfilly* (k těm později).

- `querySelector` (✝ *Internet Explorer 7*)
- `addEventListener` (✝ *Internet Explorer 8*)
- `classList` (✝ *Internet Explorer 9*)
- `Object.assign` (✝ *Internet Explorer 11*)
- `localStorage` (✝ *Opera Mini*)

Máme-li jasno v cílové skupině, v naší aplikaci (nazvěme ji `app.js`) navrch přidáme jednoduchou podmínku, která ověří potřebné vlastnosti. V případě selhání bez otálení ukončíme vykonávání skriptu{{< figures/code-ref >}}. Pokud ovšem prohlížeč testem projde, aplikaci necháme dělat svou práci. Samotnému HTML dokumentu navíc přidáme třídu `.js`. Díky ní pak i mimo skript víme, že aplikace běží, a tuto informaci hned využijeme při návrhu komponent z pohledu stylů.

{{< figures/code >}}
```html
<section class="accordion">
    <button class="accordion__button">
      <h3>Lorem ipsum</h3>
    </button>
    <p class="accordion__content">
      Consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
    </p>
</section>
```
{{< /figures/code >}}

{{< figures/code >}}
```scss
.accordion { … }

.accordion__content {
  display: none;

  .accordion.is-active & { display: block; }
}
```
{{< /figures/code >}}

{{< figures/code >}}
```scss
.accordion { … }

.accordion__content {

  .js & { display: none; }
  .js .accordion.is-active & { display: block; }
}
```
{{< /figures/code >}}

Navrhneme komponentu s třídou `.accordion` a následující strukturou: nadpis, který je zároveň `button`, a pod ním obsah, jež je z počátku schován a který se zobrazí až po kliknutí na tlačítko{{< figures/code-ref >}}. Běžný postup velí obsah skrýt, třeba pomocí `display: none`, a rozbalit jej až tehdy, kdy pomocí JavaScriptu přidáme komponentě třídu `.is-active`{{< figures/code-ref >}}. Ovšem v případě, že se potřebný skript z jakéhokoliv důvodu nenačte, je obsah najednou zcela nedostupný. Proto využijeme zmíněnou třídu `.js` a styly přepíšeme tak, že se logika obrátí: obsah je v základu rozbalený a skryje se pouze tehdy, kdy víme, že ovládací skript běží{{< figures/code-ref >}}. Jde o triviální změnu, ale se zásadním dopadem — tedy zcela v duchu [principu postupného vylepšení](/blog/princip-postupneho-vylepseni/).

## Polyfilling

{{< figures/code >}}
```js
if (
  !document.querySelector
  || !window.localStorage
  || !('classList' in document.createElement('_'))
) {
  return false;
}

fetch('app.js');
```
{{< /figures/code >}}

Vrátíme-li se zpátky k `app.js`, narazíme na další problém. Prohlížečům, které nejsou schopny aplikaci spustit, sice pomocí `return false` umožníme zachránit si tvář, ale přesto je nutíme stáhnout celý skript. A jeho velikost se v dnešní době běžně počítá na stovky kilobytů, ne-li jednotky megabytů. Lepší řešení má podobu malého skriptu `scout.js`, který má jediný úkol: provést test prostředí a nahrát zbytek aplikace{{< figures/code-ref >}}. Tak snadné to ale samozřejmě nebude. Na základě podmínky v příkladu můžeme usoudit, že aplikace mimo jiné poběží i v Internet Exploreru 10 a 11. Avšak `fetch` — rozhraní pro tvorbu AJAX požadavků založené na *Promise* — právě v těchto prohlížečích chybí, skript by tedy zcela selhal.

{{< figures/code >}}
```html
<script src="js/lib/promise.js" defer></script>
<script src="js/lib/whatwg-fetch.js" defer></script>
<script src="js/lib/pep.js" defer></script>
<script src="js/scout.js" defer></script>
```
{{< /figures/code >}}

Řešením pro chybějící rozhraní jsou již zmíněné *polyfilly*, neboli knihovny, které v případě potřeby chybějící funkcionalitu dodají. Načteme-li *polyfill* pro `fetch` před naším `scout.js`, máme vyhráno. S tím nám pomůže atribut `defer`, který zaručí, že se skripty vykonají v pořadí, které určíme, a to i v případě více souborů{{< figures/code-ref >}}. Obratem se nám však vrátil původní problém. Prohlížeče, které neprojdou zkouškou v `scout.js`, poslušně — a zcela zbytečně — stáhnou všechny *polyfilly*, jejichž velikost snadno dosáhne několika stovek kilobytů. Měli bychom tedy přijít s lepším řešením.

{{< figures/code >}}
```js
if (
  !document.querySelector
  || !window.localStorage
  || !('classList' in document.createElement('_'))
) {
  return false;
}

function loadScript(src, callback) {
  let el = document.createElement('script');

  el.addEventListener('load', callback);
  el.src = src;
  document.head.appendChild(el);
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
{{< /figures/code >}}

Jedno z možných spočívá v rozšíření `scout.js` o logiku nahrávání *polyfillů*. U každého z nich se zeptáme, zdali je potřeba, a pokud ano, pak jej stáhneme. Když máme jistotu, že jsou všechny nutné knihovny načteny, stáhneme i zbytek aplikace{{< figures/code-ref >}}. Jelikož v tomto příkladě jeden z *polyfillů* předpokládá chybějící podporu pro *Promise*, nemůžeme pro kontrolu načtení knihoven použít příhodné `Promise.all`, ale musíme implementovat vlastní (velmi naivní) řešení postavené na proměnné `counter`. V momentě, kdy dojde ke splnění podmínky `counter === 0`, víme s jistotou, že lze použít `fetch`.

## Transpilace

{{< figures/code >}}
```js
var reqPolyfills = polyfills.filter(function(_ref) {
  var test = _ref.test;
  return !test;
});
```
{{< /figures/code >}}

Stále však není dobojováno. Pozorní najdou v předchozím příkladu další problémy: Internet Explorer ve verzi 10 nerozumí klíčovému slovu `let`, verze 11 zase nechápe *arrow* funkce (`(...) => { ... }`), natož *destructuring* (`({ test })`).

S potížemi tohoto typu nám *polyfilly* nepomohou, neboť se nejedná o chybějící API, ale o konflikt na úrovni samotné syntaxe jazyka. Ten lze řešit dvěma způsoby. První je zřejmý: použít pouze syntax, jejímž sítem projdou všechny vybrané prohlížeče. Pokud však nechceme slevit a toužíme využít všech možností jazyka, nezbývá nám, než zvolit metodu zvanou *transpilace*, která zdrojový kód převede do podoby stravitelné pro **specifikovanou** sadu prohlížečů. Nejlepším nástrojem pro tento účel je [Babel](https://babeljs.io/). Když jím proženeme náš příklad, je výstupem kód, který snesou i poslední dvě verze Internet Exploreru{{< figures/code-ref >}}.

Výsledkem celého snažení je tedy kombinace dvou skriptů, `scout.js` a `app.js`, které zajistí, že naše služba s jistotou poběží v jasně určené množině prohlížečů, ale zároveň zbytečně nezatíží ty uživatele, v jejichž prohlížečích nemá smysl stahovat a spouštět JavaScript. O to důležitejší je pak **správný návrh aplikace** a dodržení [principu postupného vylepšení](/blog/princip-postupneho-vylepseni/). V dalších článcích prozkoumáme, jak podobný přístup použít v i případě *frameworků* jako je React.
