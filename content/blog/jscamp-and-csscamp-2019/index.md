---
title: "JSCamp and CSSCamp 2019: Write less code"
slug: jscamp-and-csscamp-2019
date: 2019-09-02
keywords:
    - web
    - conferences
menu:
    main:
        parent: 'blog'
photoDesc: Cable car in Barcelona — Valdemaras D.
photoUrl: https://unsplash.com/photos/aktjetKBqzc
---

Barcelona not only fills news headlines, but hosts a number of great conferences too — I have already [written](/blog/full-stack-fest-2018) about one — and *JSCamp* and *CSSCamp 2019* were no exception. As the names suggest, the conferences focus on JavaScript and CSS in all their forms. The best speakers, however, used these topics only as a stepping stone to explore broader themes.

<!--more-->

Kyle Simpson, the author of the great textbook *[You Don’t Know JavaScript](https://github.com/getify/You-Dont-Know-JS)* (you'll find the title is appropriate) opened the JSCamp and set a high standard right from the start. In his talk with the provocative title *"FOUC, and the Death of Progressive Enhancement"* he tried to convince the audience that the principle of progressive enhancement — which I've written about [here](/blog/the-art-of-progressive-enhancement) — is not a panacea. The problem, he argued, is that developers often put their experience and convenience above those of users. He pointed to a [document](https://www.w3.org/TR/html-design-principles/#priority-of-constituencies) of HTML design principles from 2008. It says, "in case of conflict, consider users over authors over implementors over specifiers over theoretical purity."

{{< figures/quote >}}
People don't necessarily want the latest technology or full experience. Sometimes, when it's dark and raining, the network hardly works, and just a few percent of battery is left, they just need to quickly find a connection home.
{{< /figures/quote >}}

## People, not users

The problem runs deeper than we think, he says, starting with the words we use. At best, we consider our users a finite **set of segments** (broken down by device or browser) and at worst, a **monolithic mass**. [The principle of progressive enhancement](/blog/the-art-of-progressive-enhancement) falls on the better part of that spectrum because an application's shape is guided by a given user's subset. Kyle argues, however, that users are not nameless groups, clearly divided into groups we choose, but **individual people**, each with different needs and preferences. To begin with, it helps if we start thinking of them that way and stop using the impersonal word users.

But where to go next? When designing a web application, we rely primarily on our judgement and think we know what the user needs or wants. It's easier that way. At the same time, however, it is obvious that our ideas often do not correspond to reality and, on the contrary, can spoil the experience for individual people. Just because a particular browser supports a technology (such as WebGL) doesn't mean the person using that browser wants it. We, as developers and designers, might not understand this but people don't necessarily want the latest technology or full experience. Sometimes, when it's dark and raining, the network hardly works, and just a few percent of battery is left, they just need to quickly find a connection home. In those moments, less is more. That's why, in rare cases, we do not rely solely on our opinion and take other information into account. We ask the browser for battery status, lighting conditions, or type of network. But that's where the effort ends, at least for most of us.

Kyle claims that this isn't enough. Decisions like these should be left to the people themselves and not just to their browsers. Yes, that means giving them a **way of altering** the experience of our app and **defer** to their preferences. A good example are the newer CSS *media queries*, such as `prefers-color-scheme: dark`, which indicates whether a person is using dark mode in MacOS so we can adjust colors accordingly, or ` prefers-reduced-motion`, which suggests we should reduce (or eliminate) the amount or intensity of animations. Kyle even showed an example of a theoretical HTTP header (called `request-fidelity`) with a unitless value from zero to one. You would set it using a simple slider, either for each site or the whole browser. We as developers could **respond** to this number in our app and send back a different set of scripts or styles, for example. Of course, no such header exists at the moment but that doesn't prevent us from developing similar features in our applications right now. If nothing else, the effort could increase the chance of a widely used, standardized solution to be developed.

{{< figures/image "ibm-plex-sans.png" "The freely available font *IBM Plex Sans* — along with its siblings *Serif* and *Mono* — is an example of the fast growing family of variable fonts. For that matter, this text is set using the font." >}}

## The future of typography

Jason Pamental would agree. He [introduced](https://noti.st/jpamental/4tpci9) the so-called **variable fonts**, a new format that embeds different weights and styles in a single file. This type of font is not defined in a **discrete** way, i.e. as a set of files each representing one particular weight or variant such as italics, but **continuously**, allowing for an almost infinite number of possible combinations.

This is great news for two reasons. The first is the amount of downloaded data and the number of HTTP requests. Variable fonts are naturally smaller than a comparable set of normal fonts and there is only one request. The second reason is connected to the central theme of Kyle's presentation; giving people a way of altering their experience on the web. Thanks to variable fonts, we **no longer have to limit ourselves** in terms of typography. We can, therefore, offer people a partial control over this aspect of design. Within boundaries we set, a person should be able to change the font size, weight (to increase contrast), or the vertical line spacing. It really makes a difference for people with reading disorders such as dyslexia.

As more and more variable fonts appear every day, there are [plenty to choose from](https://v-fonts.com). Most of these are variable versions of popular fonts, but some are highly experimental. Fonts like these couldn't exist without the new specification because they are variable not only in weight, but also in a number of weird dimensions. Good examples are [Graduate](https://v-fonts.com/fonts/graduate), [Whoa](https://v-fonts.com/fonts/whoa), or [Cheee Variable](https://v-fonts.com/fonts/cheee-variable).

{{< figures/quote >}}
Every line of code we write has a measurable impact in the real world in the form of the energy consumed, whether electrical or human.{{< /figures/quote >}}

## Less code, more fun

Rich Harris, one of the creators of the tool [Rollup](https://rollupjs.org), delivered a clear message: **write less code**. Why? Each line of code inevitably contains errors and their number naturally increases along with the length of the code. This relationship, however, is not linear but rather **quadratic**. From experience, we can tell it's true; larger pull requests are disproportionately harder to understand, bugs slipping through easily. Rich offers help in the form of a simple heuristic: the code of any module should fit on a single screen. The same attention we give to test coverage or the size of downloaded scripts should be paid to avoiding unnecessary code.

Often it's code that doesn't provide any benefit in itself but that is required by a given language or *framework*. A good example are the functions for reading and writing variables of class instances in Java, the so called getters and setters. In their basic form, they are paradoxically both necessary and unnecessary, and can be easily generated automatically. However, many *frameworks* suffer from similar ailments and Rich decided to solve this problem, at least in the world of JavaScript. The result is [Svelte](https://svelte.dev).

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

To understand the ideas behind Svelte, it's best to look at a simple component{{< figures/code-ref >}} and compare it with its equivalent from the world of React{{< figures/code-ref >}}. The first and easily overlooked difference is that a React component can have only one parent element (in this case `div`) which in itself adds one unnecessary level of indentation. In Svelte, this is not the case because it doesn't put HTML in JavaScript, but the other way round. It is more natural and allows for adding scoped styles using a simple `style` element.

And because of the way React works with state, we are often forced to write code that is unnecessarily complex. The variables `a` and `b` represent the internal state of the component. To link them to `input` elements, you must use the `onChange` attribute and point it to a function that sets the new state. In React, such a relationship makes sense. Yet, it feels like an overly complicated process, given that we're talking about a simple assignment of value. And if you forget to cast the `input` value from string to number (using the `+`) when calling the `setA(+event.target.value)`, the component would render `1 + 2 = 12` instead of `1 + 2 = 3`. Compare that with Svelte, where we express the same relationship by using the simple `bind:value` attribute.

But Svelte differs from other *frameworks* like React or Vue in a more profound way; it's a **compiler**. *Single-page application* libraries like React took away the responsibility of rendering an interface from the hands of the servers and gave it to clients. Svelte isn't giving it back, but deals with it during the compilation process. The result is vanilla JavaScript that describes the various states our components could take in the simplest possible way. Normally, **each** client (of which there are thousands, possibly millions) must first **download** and **process** a given *framework* (tens of kilobytes of JavaScript) before it can even launch our application (usually hundreds of kilobytes). Svelte, on the other hand, doesn't require each client to download the same **identical** library over and over again because the compilation takes place just **once**. The client therefore receives only our application in the form of simple JavaScript without dependencies. We can only guess how much unnecessary data and CPU load we could save this way. But it makes it obvious that every line of code we write has a measurable impact in the real world in the form of the energy consumed, whether electrical or human.

## „People empathy“

Although I described only a small selection of the talks, I tried to show what I hinted at in the introduction. The underlying theme of both conferences wasn't really JavaScript or CSS but rather *user experience*. And I don't mean just the classic *UX* that describes the relationship between a service and its users but a much broader topic which concerns real people, including us developers and our ways of building experiences. It's all about simple human **empathy**, as Kyle Simpson would say. Empathy must be our source of direction, of the decisions we make, and what priorities we choose.

