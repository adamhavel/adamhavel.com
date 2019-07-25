---
title: How to Wrestle with Browser Support
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

HTML is the foundation of web services. That is the conclusion of the [previous article](/blog/progressive-enhancement/) and the prerequisite we build on when we enhance a service with JavaScript. But how to make JavaScript run only when we know the host environment — typically a browser — will handle it? And where to set the boundary that clearly divides users into two camps: with and without JavaScript?

<!--more-->

{{< figure code >}}
```js
if (navigator.userAgent.indexOf('Chrome') !== -1) {
    var myMap = new Map();
    // ReferenceError: Map is not defined.
}
```
{{< /figure >}}

{{< figure code >}}
```js
if ('fetch' in window) {
    fetch('https://example.com').then(response => {
        // No worries.
    });
}
```
{{< /figure >}}

The essence of both questions lies in environment detection. Web is not a *binary* platform like iOS or Android, but a huge set of configurations. So, in principle, it is not possible to create a unified experience and the application must be **"responsive"** from the perspective of *UX*. One way to detect an environment is to ask for its **name** and **version**, and make a decision based on the answer. Typically, we would look at the HTTP header `User Agent`[^1]. The header, though, offers no guarantee and is often false, which makes this method useless. So, rather than ask for an environment's name, it's better to query about its **properties**[^2]. If the response meets our requirements, we can count on it being true.

## Real users

Now is the time to set the boundary, which is a small set of **properties** we deem necessary. Browsers that don’t "cut the mustard" will receive a basic — but still useful — version without JavaScript. A good idea is to use some form of **web analytics**. It allows you to evaluate real users' environment (their browser, device and operating system) and helps you decide not on intuition but data. If half of the users use Internet Explorer 8, it makes sense to choose a different approach than if there is just a handful of those poor souls.

{{< figure code >}}
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
{{< /figure >}}

What properties to choose? It's best to pick those we can't live without and which, if missing, we don't to want handle by *polyfilling* (more on that later).

- `querySelector` (✝ *Internet Explorer 7*)
- `addEventListener` (✝ *Internet Explorer 8*)
- `classList` (✝ *Internet Explorer 9*)
- `Object.assign` (✝ *Internet Explorer 11*)
- `localStorage` (✝ *Opera Mini*)

After we decide on our target group, we'll add a simple condition into our application — we’ll call it `app.js` — to check the chosen properties. In case of failure, we will immediately stop execution of the script[^3]. If, however, the browser passes the test, we’ll let the application do its job, and add the `.js` class to the HTML document. Thanks to this last detail, we can tell if the application is running even outside the context of the script (like in stylesheets). That will be helpful when designing components.

{{< figure code >}}
```html
<section class="accordion">
    <button class="accordion__button"><h3>Lorem ipsum</h3></button>
    <p class="accordion__content">Consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
</section>
```
{{< /figure >}}

{{< figure code >}}
```scss
.accordion { … }

    .accordion__content {
        display: none;
        …

        .accordion.is-active & { display: block; }
    }
```
{{< /figure >}}

{{< figure code >}}
```scss
.accordion { … }

    .accordion__content {
        …

        .js & { display: none; }
        .js .accordion.is-active & { display: block; }
    }
```
{{< /figure >}}

For example, let's make a component with the class `.accordion` and the following structure: a heading, which is also a `button`, and under it, a content that is hidden by default and shows only after clicking the button[^4]. A common method is to hide the content, perhaps with `display: none`, and reveal it with the help of JavaScript by adding the class `.is-active` to the component[^5]. If, however, the script fails to load for any reason, the content is lost forever (or until we fix the problem). That's why we use the `.js` class and rewrite the component's styles so that the logic is reversed: the content is visible and hides only if we are certain the script is running[^6]. It's a trivial change with a major impact, truly in the spirit of the [progressive enhancement](/blog/progressive-enhancement/).

## *Polyfilling*

{{< figure code >}}
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
{{< /figure >}}

When we return back to `app.js`, we encounter another problem.
Thanks to the `return false` in our application, we let the browsers that don’t pass the test save their face. But they still have to download the whole script, which can amount to hundreds of kilobytes, perhaps even a few megabytes. There’s a solution that consists of a little script — let’s call it `scout.js` — with a single purpose: to test the environment and, if positive, load the rest of the application[^7].

Of course, there are some obstacles. We can deduce, based on the set of properties in the example, that the application is supposed to run in Internet Explorer 10 and 11. The example, however, makes use of `fetch`, which is an API for making AJAX calls built on *Promise* and which, sadly, is missing in these browsers. The script would therefore fail spectacularly.

{{< figure code >}}
```html
<script src="js/lib/promise.js" defer></script>
<script src="js/lib/whatwg-fetch.js" defer></script>
<script src="js/lib/pep.js" defer></script>
<script src="js/scout.js" defer></script>
```
{{< /figure >}}

The solution for missing APIs are the already mentioned *polyfills*, which are libraries for filling the gaps. If we load a *polyfill* for the `fetch` before the `scout.js` runs, we’re out of deep water. To do that, we can use the attribute `defer`, which guarantees the scripts load in the order defined in the document[^8].

When it comes to plundering data plans, we’re back to square zero, though. The browsers that fail the `scout.js` test will obediently — and in vain — download all the *polyfills*, which size can, once again, stretch to hundreds of kilobytes. A better solution is needed, then.

{{< figure code >}}
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
{{< /figure >}}

We could let the `scout.js` script pick which *polyfill* to load. For each of them, it would ask whether it’s needed, and act accordingly. After all necessary *polyfills* had loaded, the rest of the application would be requested[^9]. But, since *Promise* is one of the APIs we are *polyfilling*, we can’t enjoy the conveniency of `Promise.all` and need to implement our own — and very naive — solution based on the `counter` variable. When `counter === 0` turns true, we can finally use `fetch` without worry.

## *Transpilation*

The fight is not over yet, though. Keen eyes already see another problem: Internet Explorer 10 doesn’t understand the keyword `let`, while version 11 struggles with *arrow* functions (`(...) => { ... }`) and *destructuring* (`({ test })`).

{{< figure code >}}
```js
var reqPolyfills = polyfills.filter(function(_ref) {
    var test = _ref.test;
    return !test;
});
```
{{< /figure >}}

*Polyfills* won’t help us now, because problems like this are no longer about missing APIs, but spring from the deeper level of syntax. There are two ways to deal with them. The first one is obvious: use only syntax that all target browsers know. But unless we want to compromise and skip new features of the language, we must use a method called *transpilation*. It transforms a code in such a way that a **specified** set of browsers can handle it. The best tool for this job is [Babel](https://babeljs.io/). If we use it on our example, it outputs code that even the last two versions of Internet Explorer won’t choke on[^10].

The end result of the whole struggle is a pair of scripts, `scout.js` and `app.js`, that, together, deliver our application to a clearly defined set of browsers. But they won’t force the application to users that couldn’t run the application anyway. That’s why it’s important to design the application properly and heed the ethos of [progressive enhancement](/blog/progressive-enhancement/). In the next article, I’ll show how to use a similar approach in the case of *frameworks* like React.
