---
title: Full Stack Fest 2018
date: 2019-01-03
keywords:
    - web
    - conferences
menu:
    main:
        parent: 'blog'
photoDesc: La Sagrada Familia — Erwan Hesry
photoUrl: https://unsplash.com/photos/QYYg0KwTGYc
---

Have you ever felt the urge to throw that bag full of useless things — the one they still give you on conferences despite common sense — on the stage? It happens to me. At that moment, instead of hard-won experiences or thoughts, you listen to something that resembles reading a documentation and, on top of that, the person on the stage pretends it's all so fascinating.

<!--more-->

Fortunately, such a thing happens rarely at [Full Stack Fest](https://fullstackfest.com/). It's a five-day conference, divided into two blocks, roughly labeled as back-end and front-end. And, although I have more to say about the latter, I am always happy to learn about the former, too. It doesn't hurt a bit that it all takes place in Barcelona. Two themes dominated this year: peer-to-peer technology and decentralization in general on the back-end, and performance and optimization in the world of front-end.

## The decentralization of the internet

Unlike the previous year, the word blockchain wasn't automatically thrown together with the word decentralization. But we got a glimpse of blockchain — or rather its private, toothless form — in a ~~advertising~~ [presentation from IBM](https://youtu.be/v2WiqQs_JAs), anyway. [The talk by Andre Staltz](https://youtu.be/8GE5C9-RUpg) was way more intriguing. He talked about the sympatethic effort to replace the current model of social networks with a decentralized alternative. And since the cornerstone of every peer-to-peer network is a protocol, he described a solution based on a particular technology called [Scuttlebutt](https://www.scuttlebutt.nz/). When I asked how Scuttlebutt compares to Tim Berners-Lee's [project Solid](https://solid.mit.edu/) which seems to be solving a similar set of problems, Andre replied that while Solid started as a specification first and only then turned into an implementation, Scuttlebutt is the other way around. That path is more organic and wild, but certainly more engrossing for those entertaining the idea to get involved.

{{< figures/quote >}}
Whether we talk about microservices, distributed databases, blockchain, or the promise of the so-called "Web 3.0", we will increasingly face this complexity both as creators and users.
{{< /figures/quote >}}

A similar topic, but a different point of view, was [presented by Tara Vancil](https://youtu.be/raUE23RKLvE). Tara is part of the team around the experimental [Beaker browser](https://beakerbrowser.com/). It confidently and directly targets one of the foundations of the internet, the HTTP protocol, and hopes to replace it with a protocol called [DAT](https://datproject.org/) which is built on the principles of peer-to-peer technology. Like BitTorrent, it breaks down the traditional arrangement of servers and clients, and replaces it with a complex network of peer nodes. If I want to contribute content (like a website), I need to get involved in the network and let my computer act as a type of "server", at least in the beginning. The more intriguing part comes next when, hopefully, some users visit my site. Then, they also become providers of the website, which means it's hosted on several different computers, the number of which is directly proportional to the website's popularity. This eliminates the need for my computer to be online at all times. As long as at least one of the nodes that have copy of the website is connected to the network, it should still be available. That makes it very hard to censor a popular content, compared to the current model of the internet. Now, it's easy to ban entire websites, like, for example, Wikipedia in Turkey.

The purpose of Beaker is to allow ordinary users to create and read such content, and to raise awareness of the alternative to the current internet. At the same time, it partially conceals the complexity that necessarily arises in decentralized networks. Whether we talk about microservices, distributed databases, blockchain, or the promise of the so-called "Web 3.0", we will increasingly face this complexity both as creators and users. There's one thing I regret regarding Beaker, though. It doesn't (yet) support the [IPFS protocol](https://ipfs.io/), which is very similar to DAT and perhaps more well-known.

{{< figures/image "tara-vancil.jpg" "Tara Vancil presented the experimental browser Beaker. Its purpose is to offer a version of the internet that is not based on the protocol HTTP, but on a peer-to-peer alternative called DAT." >}}

## The Holy Grail of optimization?

From the front-end side of the fence, we got several contributions to the evergreen topic of optimization. And despite some innovations, it still rings true that it's a treacherous area, with just a few signs of elegant solutions here and there.

The [talk from Patrick Hamann](https://youtu.be/ga_-zsTHRm8) was essential in this regard. Thanks to his work at Fastly, he showed us that the so-called HTTP server push is not as straighforward as we thought. In this, it was similar to an older [article by Jake Archibald](https://jakearchibald.com/2017/h2-push-tougher-than-i-thought/). Server push was one of the big promises of the HTTP2 protocol that we hoped would solve all our website loading problems. How to send all the files required for rendering a website to a client as fast as possible? The server knows exactly which files those are, but the client has to download the whole HTML document first in order to find out all the dependencies like styles or images. Server push theoretically allows sending all the dependecies at once based on just the one original request for the document. The problem, however, arises when we consider cache. It appears on several levels (memory, service worker, HTTP cache and the new push cache) and behaves differently in different browsers. As usual, the solution is not easy and is based on compromises. But in combination with current and future technologies like [Cache Digest](https://tools.ietf.org/html/draft-ietf-httpbis-cache-digest-04), [Early Hints](https://tools.ietf.org/html/rfc8297) or [preloading](https://w3c.github.io/preload/), it's still a big step forward.

{{< figures/quote >}}
Server push was one of the big promises of the HTTP2 protocol that we hoped would solve all our website loading problems.
{{< /figures/quote >}}

In the uplifting [presentation on native modules in JavaScript](https://youtu.be/O4r9D2jI0_w), Serg Hospodarets demonstrated we can already try testing modules in production environment. We can't toss out transpilation and bundling yet, but thanks to the `nomodule` directive, we can at least send significantly less data to those browsers that support modules and HTTP2 multiplexing. No directive, however, can help us when dealing with the so far insufficient support for dynamic module loading.

Zack Argyle told us a [story](https://youtu.be/pluzva6Dk9Q) of how they handled a mobile site in Pinterest. After the initial decision to push users to download a native application — which, predictably, turned out to be unfortunate — they decided to devote all manpower to the mobile site and fix it up completely. The result is a React-based website built on the *progressive web app* principles. Pinterest used all the tricks, too, for example aggressive caching in service worker, server-side rendering, or a strict limit on the amount of code a user has to download. Sia Karamalegos also pursued the last point. She [talked about](https://youtu.be/SA_Hp8l7lr4) the not well-known fact that although images carry the most data, it is JavaScript who's the real "winner". That's because each byte of JavaScript requires more operations to process than images. Hence it's more burdensome for CPUs which capacities, especially on mobile devices, are not unlimited.

Finally, I recommend watching a [video](https://youtu.be/K0WU02flF_E) in which Andrew Louis presents what it looks like when you try to record every detail from your life in digital form. Andrew tries to tackle this herculean task by developing a [modern version of the memex](https://hyfen.net/memex/), an ideological precursor to hypertext. If you have a thing for data organization or fear that you spend too much time in the digital realm, this talk might calm you down.
