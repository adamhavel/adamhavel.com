---
title: "JSCamp a CSSCamp 2019: Pište méně kódu"
slug: jscamp-a-csscamp-2019
date: 2019-08-26
keywords:
    - web
    - konference
menu:
    main:
        parent: 'blog'
photoDesc: Lanovka v Barceloně — Valdemaras D.
photoUrl: https://unsplash.com/photos/aktjetKBqzc
---

Barcelona plní nejen titulky novin, ale hostí i řadu skvělých konferencí — o jedné takové už jsem ostatně [psal](/blog/full-stack-fest-2018) — a kombinace *JSCamp* a *CSSCamp 2019* nebyla výjimkou. Jak napovídají názvy, každoročním těžištěm konferencí jsou JavaScript a CSS ve všech svých podobách. Pro ty nejlepší přednášející však posloužily jen jako odrazový můstek k prozkoumání témat širšího záběru.

<!--more-->

Už první přednáška na *JSCamp* nastolila vysoký standard. Konferenci zahájil Kyle Simpson, autor skvělé učebnice *[You Don’t Know JavaScript](https://github.com/getify/You-Dont-Know-JS)* (po přečtení jsem uznal, že název je namístě). Ve svojí přednášce s provokativním názvem *„FOUC, and the Death of Progressive Enhancement“* si za cíl zvolil princip postupného vylepšení — kterému jsem se v minulosti [věnoval i zde](/blog/princip-postupneho-vylepseni) — a snažil se publikum přesvědčit, že nejde o samospásné řešení. Argumentoval, že vývojáři mnohdy upřednostňují svůj zážitek a pohodlí před tím uživatelovým. Na ten popud odkazoval na více jak deset let starý [dokument](https://www.w3.org/TR/html-design-principles/#priority-of-constituencies) návrhových principů HTML, kde stojí „in case of conflict, consider users over authors over implementors over specifiers over theoretical purity,“ tedy „v případě konfliktu zájmů berte ohled v prvé řadě na uživatele, před autory, tvůrci implementací a specifikací, a teoretickou čistotou.“

{{< figures/quote >}}
Lidé mnohdy netouží po nejnovější technologii či plnohodnotném zážitku. Občas, když je venku tma a prší, připojení vypadává, a v baterii zbývá jen pár procent, potřebují pouze rychle najít spojení domů.
{{< /figures/quote >}}

## Lidé místo uživatelů

Dle jeho slov je problematické už jen to, jak na uživatele nahlížíme. V lepším případě je považujeme za konečnou **množinu segmentů** (rozdělených dle zařízení či prohlížeče), v tom horším za **jednolitou masu**. [Princip postupného vylepšení](/blog/princip-postupneho-vylepseni) samozřejmě odpovídá prvnímu případu. Výsledná podoba aplikace totiž záleží na tom, do jaké podmnožiny uživatel patří. Kyle ovšem namítá, že uživatelé nejsou bezejmenné skupiny, jasně rozdělené na základě našich představ, ale **jednotliví lidé**, každý s jinými nároky a potřebami. Pro začátek pomůže, když je tak začneme označovat a přestaneme používat neosobní slovo uživatelé.

Ale co dál? Při návrhu webové aplikace spoléháme v prvé řadě na náš úsudek a myslíme si, že víme, co uživatel potřebuje nebo chce. Je to tak jednodušší. Zároveň je však zřejmé, že naše představy často neodpovídají skutečnosti a jednotlivým lidem zážitek naopak kazí. Samotný fakt, že konkrétní prohlížeč podporuje danou technologii (třeba WebGL) ještě neznamená, že o ní člověk, který prohlížeč používá, stojí. Ač to jako vývojáři či designeři nemusíme chápat, lidé mnohdy netouží po nejnovější technologii či plnohodnotném zážitku. Občas, když je venku tma a prší, připojení vypadává, a v baterii zbývá jen pár procent, potřebují pouze rychle najít spojení domů. Méně je pak více. Ve výjimečných případech se proto neopíráme jen o naše mínění a bereme v potaz i další informace. Ptáme se prohlížeče na stav baterie, světelné podmínky nebo typ připojení k internetu. Ale snaha vyjít lidem vstříc zde — alespoň pro většinu z nás — zvolna mizí.

Kyle ovšem tvrdí, že to nestačí. Podobná rozhodnutí bychom měli přenechat samotným lidem, a nejenom jejich prohlížečům. Ano, znamená to dát jim **možnost ovlivnit** zážitek z naší aplikace a **ustoupit** jejich preferencím. Příkladem jsou novější *media queries* v CSS, jako je `prefers-color-scheme: dark`, které značí, zdali daný člověk používá tmavý režim v MacOS, na základě čehož můžeme na našem webu příhodně upravit barvy, nebo `prefers-reduced-motion`, jež nám prozměnu vyjeví, že bychom měli snížit (nebo zcela odstranit) množství či intenzitu animací. Kyle dokonce ukázal příklad teoretické HTTP hlavičky — nazval ji `request-fidelity` — s bezrozměrnou hodnotou od nuly do jedné. Tu by člověk nastavil pomocí jednoduchého posuvníku buď pro jednotlivé weby nebo v rámci celého prohlížeče. My jako vývojáři bychom na toto číslo mohli **reagovat** v naší aplikaci a posílat zpátky například jinou sadu skriptů či stylů. Nic takového samozřejmě prohlížeče zatím nenabízí, ale nic nám nebrání vyvinout podobné prvky přímo v našich aplikacích už teď, což zvýší šanci na vznik standardizovaného, široce používaného, řešení.

{{< figures/image "ibm-plex-sans.png" "Volně dostupný font *IBM Plex Sans* je — spolu se svými sourozenci *Serif* a *Mono* — jedním z představitelů rychle rostoucí rodiny variabilních fontů. Text, který právě čtete, jej ostatně používá." >}}

## Budoucnost typografie

Stejným způsobem uvažuje i Jason Pamental, který [představil](https://noti.st/jpamental/4tpci9) takzvané **variabilní fonty**. Jde o nový formát fontů, který, stručně řečeno, umožňuje všechny různé řezy vložit do jediného souboru. To je možné díky tomu, že font není definován **diskrétně**, tedy jako sada souborů, kde každý představuje jednu konkrétní tloušťku či variantu jako kurzíva, ale **spojitě**, s takřka nekonečným množstvím možných kombinací.

To je skvělá zpráva ze dvou důvodů. Ten první souvisí s množstvím stažených dat a počtem HTTP požadavků: variabilní fonty mají přirozeně menší velikost než kompletní sada běžných fontů, a požadavek je jen jeden. Druhý důvod tento fakt spojuje s ústředním tématem Kylovy prezentace, tedy jak lidem předat možnost ovlivnit zážitek na webu. Protože se díky variabilním fontům již **nemusíme omezovat** co se týče typografie, máme příležitost nabídnout lidem částečnou kontrolu i nad ní. V rámci mantinelů, které určíme, lze například umožnit změnit velikost písma, jeho řez (kvůli zvýšení kontrastu) nebo třeba svislý odstup (neboli proklad) řádků, kvůli zlepšení čitelnosti pro lidi s poruchou čtení jako je dyslexie.

Variabilních verzí oblíbených fontů se objevuje čím dál tím více, je tedy z čeho [vybírat](https://v-fonts.com). Zároveň vznikají i vysoce experimentální fonty, které by bez této technologie nemohly existovat a u kterých lze pracovat s velkým množstvím často neobvyklých dimenzí. Dobrým příkladem jsou fonty jako [Graduate](https://v-fonts.com/fonts/graduate), [Whoa](https://v-fonts.com/fonts/whoa) nebo [Cheee Variable](https://v-fonts.com/fonts/cheee-variable).

{{< figures/quote >}}
Každý řádek kódu, který napíšeme, má měřitelný dopad ve skutečném světě v podobě spotřebované energie, ať už té elektrické nebo lidské.{{< /figures/quote >}}

## Méně kódu, více radosti

Rich Harris, mimo jiné tvůrce nástroje [Rollup](https://rollupjs.org), přišel s jasným sdělením: **pište méně kódu**. Proč? Každý kód nevyhnutelně obsahuje chyby a jejich počet přirozeně roste spolu s délkou kódu. Problém tkví v tom, že tento vztah není lineární, ale spíše **kvadratický**. Z naší zkušenosti to dává smysl — čím obsáhlejší je nějaký *pull request*, tím neúměrně větší problém nám dělá kód pochopit a objevit záludné chyby. Rich v tomto ohledu nabízí jednoduchou radu: kód jakéhokoliv modulu by se měl vejít na jednu obrazovku. Stejnou pozornost, jakou dáváme pokrytí kódu testy nebo výsledné velikostí skriptů bychom měli věnovat snaze vyhnout se zbytečnému kódu.

Mnohdy je to kód, který sám o sobě nepřináší žádný užitek, ale který vyžaduje daný jazyk nebo *framework*. Dobrým příkladem jsou funkce pro čtení a zápis proměnných v instancích tříd, které najdeme třeba v Javě. Ve své základní podobě jsou paradoxně nutné i zbytečné zároveň, a nic nebrání tomu, aby byly generovány automaticky. Podobným neduhem však trpí i řada *frameworků* a Rich se rozhodl tento problém vyřešit — alespoň ve světě JavaScriptu. Výsledkem je [Svelte](https://svelte.dev).

{{< figures/code >}}
```html
<script>
  let a = 1;
  let b = 2;
</script>

<input type="number" bind:value={a}>
<input type="number" bind:value={b}>

<p>{a} + {b} = {a + b}</p>
```
{{< /figures/code >}}

{{< figures/code >}}
```js
import React, { useState } from 'react';

export default () => {
  const [a, setA] = useState(1);
  const [b, setB] = useState(2);

  function handleChangeA(event) {
    setA(+event.target.value);
  }

  function handleChangeB(event) {
    setB(+event.target.value);
  }

  return (
    <div>
      <input type="number" value={a} onChange={handleChangeA} />
      <input type="number" value={b} onChange={handleChangeB} />
      <p>{a} + {b} = {a + b}</p>
    </div>
  );
};
```
{{< /figures/code >}}

V čem se Svelte liší si nejlépe ukážeme na příkladu jednoduché komponenty{{< figures/code-ref >}}, kterou porovnáme s jejím ekvivalentem ze světa Reactu{{< figures/code-ref >}}. První, lehce přehlédnutelný, rozdíl spočívá v tom, že komponenta v Reactu může mít jen jeden rodičovský element (v tomto případě `div`), což samo o sobě přidá jeden zbytečný stupeň zanoření. Pro Svelte to není problém, protože HTML nedává do JavaScriptu, ale naopak. Je to přirozenější a v případě potřeby se nabízí přidat styly pomocí běžného elementu `style`.

A vzhledem k tomu, jak React pracuje se stavem, jsme mnohdy nuceni psát kód, který zbytečně zvyšuje prostor pro chyby. Proměnné `a` i `b` zde představují vnitřní stav komponenty. Abychom je provázali s `input` elementy, musíme použít atribut `onChange`, který odkazuje na funkci, jež volá interní metodu pro nastavení stavu. Ve světe Reactu takový vztah dává smysl, ale je pravda, že — s ohledem na to, že se jedná o pouhé přiřazení hodnoty — jde o přehnaně komplikovaný koncept. Navíc, pokud bychom při volání `setA(+event.target.value)` opomněli přetypovat hodnotu z `input` elementu na číslo (pomocí onoho `+`), komponenta by — kvuli přetížení operátoru — místo `1 + 2 = 3` vypsala `1 + 2 = 12`. Pro srovnání: stejný vztah ve Svelte vyjádříme tím, že použijeme jednoduchý atribut `bind:value`.

Aby toho nebylo málo, Svelte se od *frameworků* jako React nebo Vue liší ještě v jedné zásadní věci. Jde totiž o **kompiler**. *Single-page application* knihovny typu React převzaly zodpovědnost za vykreslení rozhraní z rukou serverů a daly ji klientům. Svelte ji nevrací zpátky, nýbrž se s ní vypořádá během kompilace komponent. Výsledkem je běžný JavaScript, který nejjednodušším možným způsobem popisuje stavy, jaké naše komponenta může nabýt. Srovnejme to s klasickým *frameworkem*. **Každý** klient musí nejprve **stáhnout** a **zpracovat** daný *framework* (desítky kilobytů JavaScriptu), a až poté může spustit naši aplikaci (běžně stovky kilobytů). V případě Svelte tyto tisíce či milióny klientů nezatížíme povinností stáhnout a zpracovat **identickou** knihovnu, protože kompilace proběhne jen **jednou** a klienti obdrží až jednoduchý JavaScript bez jakékoliv závislosti. Kolik zbytečných dat a zatížených procesorů tím můžeme ušetřit, lze jen hádat. Je ale nanejvýš zřejmé, že každý řádek kódu, který napíšeme, má měřitelný dopad ve skutečném světě v podobě spotřebované energie, ať už té elektrické nebo lidské.

## „People empathy“

Byť jsem popsal jen úzký výsek toho, co bylo na konferencích k vidění, snažil jsem se ukázat, že ústředním motivem nebyl — jak už jsem naznačil v úvodu — JavaScript nebo CSS, ale *user experience*. A tím nemyslím jen ono klasické *UX*, které popisuje vztah mezi službou a jejími uživateli, ale mnohem širší téma. To pojednává o skutečných lidech, tedy i o nás vývojářích a o našem přístupu k tvorbě. Středobodem by, jak řekl Kyle Simpson, měla být prostá lidská **empatie**. Ta musí určovat směr, jakým se vydáme, jaká rozhodnutí uděláme, jaké priority zvolíme a kdo bude v případě kompromisu tahat za kratší provaz.
