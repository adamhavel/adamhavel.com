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

Since its inception, JavaScript, along with the whole internet, has come a long way. The little scripting language became a moloch, on whose shoulders rests the weight of many of the websites we use everyday. To validate this statement, turn off the JavaScript support in your browser and you will see those websites fall apart before your eyes. Perhaps as fast as your trust in Facebook's good intentions.

<!--more-->

Of course, there is the question of how many users actually turn off JavaScript in their browsers. You would be right if you guessed it was only an insignificant fraction. Unfortunately, there are other ways you can turn into a user without JavaScript: a page has downloaded, but not the script the website needs to run. That could happen for many reasons: request error, firewall, timeout, content manipulation on the side of your connection or hosting provider, or a browser extension like the AdBlock.

We then stumble on a second type of problems: a script downloads but doesn’t execute. Why? JavaScript is a complicated language and on top of that, it has no static type check. So it's no surprise that we often make mistakes that will show up only at runtime. But we can live with that. And there is nothing holding us from using the likes of TypeScript if we can’t. But there is another reason this could happen and that reason is browser support.

JavaScript is an easy and frequent target for mockery. Few, however, can appreciate the hostility of the hosting environment, the browser. When we work with language like Python, we are usually sure the application will execute on a server with some — but exact — version of the language. In the case of JavaScript (with the exemption of Node.js), there are no certainties. The environment is a combination of a device, operating system, and browser. From a practical point of view, an infinite set. It's a wonder that our application ever works!

## Resilient technologies

In light of the previous paragraphs, JavaScript rightly seems like a fragile technology, on which, however, most of the internet depends. But it shares this burden with many other technologies. And one of them is so simple we forget to consider it a technology at all: HTML.

Apart from being simple, HTML is declarative: we describe **what** we want to see or happen, and not **how** that happens. That reduces the chance of making an error. On top of that, HTML has another remarkable feature: when an error does occur, it is not followed by catastrophic failure.

When a browser comes upon a HTML error[^1], for example an unknown element, it will ignore it and render the document anyway. If we instead chose XHTML, the evil twin of HTML, we would only get an error message. That’s why nobody sane uses it. But why is HTML relevant? Because we can use it to build the foundation of our web service, one that is resilient and reliable. In the world of front-end development, that is a remarkable thing.

## Links and forms

From a browser's point of view, most websites stand on two pillars: navigation and communication. We navigate using *hyperlinks*, a declarative method of linking two documents together that we know as the humble, but powerful, links. The second pillar is communication between a browser and a remote server. Links can be used for that, too. However, if we want to send more than a simple data, we use a different method: forms[^2].

Form has a simple and **declarative** interface. First, there is the attribute `action`, which specifies the address where a remote server receives our data. Content belongs to `input` or` textarea`, whose `type`,` required` or `pattern` attributes limit what can be sent. The last necessary element is the `button` whose` type` — unless stated otherwise — is `submit`. It is used to, well, submit the form.

We can **replace** the form basic functionality with one of our own and use JavaScript to **enhance** it with AJAX call[^3]. The point of no return occurs at the moment we click the `button`. By calling `ev.preventDefault()`, we stop the browser from following the standard procedure. What happens next is completely in our hands. At the very least, we have to manually extract data from the form, send it to the server and handle the response. Since it's an AJAX call and not a normal request, we expect the response to be in JSON format, not HTML, which we indicate using the HTTP header `Accept: 'application/json'`.

However, if we leave the example as it is, we lose data validation. The browser would normally take care of it on its own based on our declarations on the `input` elements, but since we got cocky, we have to do it ourselves. In case of an error, we need to show some kind of message, too. That's when we start longing for the magic of simple and declarative code, because all of a sudden, we not only have to take care of **what** should happen, but also **how** that happens.

## „Minimum Viable Experience”

Back in the safety of HTML, we begin to fathom how to build those reliable foundations with simple links and forms. That's the starting point of the elusive principle of progressive enhancement. We define the so called minimum viable experience: what methods does the web service have to offer **at all times** in order to be useful? We then build those methods using the most simple — therefore the most resilient — technology available. In return, we get the certainty that the service will fulfil its job in almost any environment, and the luxury of using JavaScript to **enhance** the service at will and without worries.

Let’s try the principle on a service like Google Docs. The elements `textarea`, `input` and `form` are our foundation. They allow us to send data to a remote server which then saves it in a database, thus providing an access to the data from anywhere. With the basics built, nothing holds us from enhancing the basic experience. By sending the form automatically using AJAX when the content changes, the user doesn’t have to submit it manually every time. In the next round of enhancement, we save the data in `localStorage` so that it won’t get lost if the remote server is not available, and send it only after it’s back online. To finish, we could use *WebSocket* to allow for more users work with one document at the same time.

If any of these enhancements fails, either due to a lack of browser-side support, poor connection, or JavaScript error, we know for sure that **users will still get the basic service**. In our example, storing the content in cloud is the most important thing and the enhancements are what distinguishes the service from similar ones.

In fact, competition is a good incentive for embracing the principle of progressive enhancement. Although it seems like a simple, even trivial, method, few web services fulfil its essence. So if we take the opportunity to design a more resilient service, we get a natural advantage. On top of that, we offer all users — regardless of whether they have an old device or a browser — a functional service. Compare that to the usual procedure that starts from the other end — which is a web dependent on JavaScript or a specific framework — and only then tries to make it work for as many users as possible using *fallbacks*, *polyfills* and so on. Sooner or later, we get past a point where supporting a specific browser or device stops making sense for one reason or another, leaving users outside this bubble out of luck.

The principle of progressive enhancement is a simple method that relies on changing the way we design applications, rather than on specific technological solutions. And even though it looks like more work, the opposite is true. It gives us almost universal support in browsers and the certainty that the service won’t fall apart under the smallest pressure. The principle can be summarised in one sentence: use JavaScript, but don’t **rely** on it, and take advantage of the declarative methods offered by HTML. In practice, this means writing a **structured** and **semantically correct** document, not a “soup” of `div` elements that are by design without meaning and function.

In following articles, we will focus on how to handle JavaScript support in browsers, and how to maintain the principle of progressive enhancement when using tools like React.


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