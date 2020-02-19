---
title: How I Learned to Stop Worrying and Love the Cascade
slug: css-at-heureka
date: 2020-01-14
keywords:
    - web
    - front-end
menu:
    main:
        parent: 'blog'
photoDesc: Tim Johnson
photoUrl: https://unsplash.com/photos/VkuWpYCV2MU
---

Many, if not all, of us at Heureka enjoy CSS. Like HTML, it's a declarative and simple language, with a similarly lax validator that tactfully skips over what it doesn't know. Unlike HTML, however, lot of people actually lose sleep over CSS. The main culprit tends to be the so called *cascade* which is sometimes hard to grapple with.

<!--more-->

## Cascade and specificity

At first glance, *cascade* looks simple: later declarations trump previous ones. This gives CSS a clear order where general declarations — like the color or size of text — precedes the more specific ones like the background of color of some component.

{{< figures/quote >}}
It's not the simple *cascade* itself, then, that's problematic, but *specificity*, which can turn the codebase into a complex mess, full of hard to predict interactions.
{{< /figures/quote >}}

There is, however, one more law that governs the realm of CSS, called *specificity*, which makes the whole affair a bit more complicated. It's not only the order that matters, but the type of declaration, too. Various declarations have different *specificity* and thus the potential to override declarations that follow them but have a lower *specificity*.

The *selector* we use to link declaration to HTML elements has the main say regarding *specificity*. For example, `[data-foo="bar"]` finds all elements with the `data-foo` HTML attribute equal to `bar`, while `.foo` targets elements with `class` matching `foo`. These are examples of different types of *selectors* with different *specificity*. They can be chained leading to *selectors* like `.foo p` or `.bar div p`, and the longer the chain, the greater the *specificity*. Simple *selectors* such as `p` or` div` are thus easily overriden.

Finally, we stumble upon the keyword `!important`. A desperate developer, in his vain struggle with *specificity*, uses it as a weapon of mass destruction, having exhausted all other options. It is, however, a short-lived victory. By declaring `p { color: red !important }`, all paragraphs will probably acquire the desired text color. But when we create a conflicting declaration with `!important`, *specificity* returns in full force, because we need it to decide which of the two declarations wins. This path, too, leads into a game of whack-a-mole.

It's not the simple *cascade* itself, then, that's problematic, but *specificity*, which can turn the codebase into a complex mess, full of hard to predict interactions. If we want to avoid unmaintainable code, we need to come up with a plan.

## Technology and methodology

There are two approaches. The first one is technological and relies on frameworks like React or Vue, but also the W3C specification of [Web Components](https://github.com/w3c/webcomponents). All of these revolve around the idea of small, independent components, which are bundles of JavaScript, HTML templates and optionally, CSS stylesheets. If used, these styles apply only at the component level and don't affect the global CSS context, similar to native JavaScript modules. At the same time, nothing prevents us from setting some values in the global context which will trickle down into components. The resulting code has fewer collisions and is more sustainable and modular. On the other hand, the styles become dependent on JavaScript, which — as I have [written earlier](/blog/the-art-of-progressive-enhancement/) — is fragile, unlike CSS and HTML.

That's why we chose the other approach. We decided on principles that make sense to us and we use them to guide us. The reward is clear and predictable code. The obvious advantage over the previous option is the lack of complicated technology, but though it's simple, it's not always easy. You have to deal with the “soft” realm of discipline, communication and understanding across teams. Good *code review* then becomes even more important. Having a well-managed *styleguide* — ours is at [heureka.cz/ui](https://heureka.cz/ui) — doesn't hurt either.

## Block, Element, Modifier

{{< figures/code >}}
```html
<nav class="breadcrumbs breadcrumbs--small">
    <ul class="breadcrumbs__list">
        <li class="breadcrumbs__item">
            <a class="breadcrumbs__link" href="…">Heureka.cz</a>
        </li>
        <li class="breadcrumbs__item">
            <a class="breadcrumbs__link" href="…">E-shops</a>
        </li>
        <li class="breadcrumbs__item">
            <span class="breadcrumbs__link">Notino</span>
        </li>
    </ul>
</nav>
```
{{< /figures/code >}}

There are many well known methodologies. We base ours on a set of recommendations called *BEM*, or *Block, Element, Modifier*, which rests on a simple, but hard rule. It forbids all selectors other than those targeting classes, like `.foo`, and prohibits chaining. Both, of course, with specific exceptions. If we comply, we avoid some of the biggest problems with *specificity*.

The abbreviation *BEM* hides another principle. A component represents a so-called *block*, which consists of several *elements* and may use *modifiers*. To distinguish them, each of these have a different naming convention. If you create a component (or *block*) with the name (class) `block`, then its inner *element* must be named something like `block__element`. We recognize *modifiers* because of their `block--modifier` class. Here is an example of specific component{{< figures/code-ref >}}.

Using multiple `__` to give an *element* its depth is a common mistake. Instead of the class `breadcrumbs__link`, we would have `breadcrumbs__list__item__link`. This is unnecessary — and ugly — and makes it harder to change the structure of a component.

## Structure

{{< figures/code >}}
```less
.breadcrumbs {
    …

    &--small { … }
    &--large { … }
}

    .breadcrumbs__list {
        …

        .breadcrumbs--small & { … }
    }

        .breadcrumbs__item {
            …

            @media (max-width: @lteLayout) {
                …
            }
        }

            .breadcrumbs__link {
                …

                &:not([href]) { … }
            }
```
{{< /figures/code >}}

At Heureka, we use the CSS [*preprocessor Less*](http://lesscss.org/). [*Sass*](https://sass-lang.com/), a widely used alternative, is significantly more powerful than *Less*, at the expense of drifting away from the simple and declarative spirit of CSS. *Less* is good enough for most uses.

Preprocessors give you the basic but important option to put each component in its own file, for example `breadcrumbs.less`{{< figures/code-ref >}}. The *element* selectors in the example are not chained with the *block* and thus remain simple. They are also indented to reflect the HTML structure of the component. This is a helpful practice that — as opposed to the multiple use of `__` — is easy to maintain.

In contrast, *modifiers* are inserted directly into a *block* using the `&` *parent selector*. *Modifiers* usually change properties of *blocks*, but sometimes these changes apply directly to *elements*. That's a good excuse to use chaining, like the `.breadcrumbs--small & { … }` in the *element* `breadcrumbs__list`. We treat `@media` blocks similarly and put them right where they belong.

The last interesting thing to point out is the *selector* `&:not([href]) { … }`. It goes against the principle of *BEM*. The correct way would be to create a new *modifier*, for example `breadcrumbs__link--current`. However, we try to honor what the ancient Greeks called *fronésis* and we call common sense, and not take it too seriously. If you were to poke through our code, you might be startled to find a component that denies everything I have described so far{{< figures/code-ref >}}.

{{< figures/code >}}
```less
.breadcrumbs {
    …

    ul { … }
    li { … }
    a { … }
}
```
{{< /figures/code >}}

It certainly isn't *BEM*, but on a good day, even a code like that might pass review. Since the component is very simple, the offense can be forgiven, because each HTML element clearly identifies a specific *element*. Only a slightly more complicated component would deprive us of this luxury and make us go back to using classes.

## Composition

If we want to adjust the appearance or behavior of a component depending on the context or its location in the HTML document, we often stumble. For example, two components named `article` and `category`, which represent different sections of the site and define their layout, are two different contexts. How to proceed if the `breadcrumbs` component should look or behave differently in each section?

We might think of using the *selectors* `.article .breadcrumbs { … }` and `.category .breadcrumbs { … }`. That, however, would be an unwise choice. We would quickly find out that it's not at all clear where to put these — into `breadcrumbs.less` or `article.less`? Either way is bad, because both create an unnecessary link between the components. That, in turn, would complicate future modifications and lead to trouble with *specificity*.

Depending on the amount and type of adjustments, we can make a better choice. If the changes are superficial, such as background color or text size, we make a *modifier*. These are best named in general way, like `breadcrumbs--small` or `breadcrumbs--large`. If we know these are specific and will not be used elsewhere, it's fine to use names such as `breadcrumbs--article` and `breadcrumbs--category`.

When it comes to major changes — at the level of structure or layout — we need to think a little more. The goal is to build components that are manageable and reusable. A component (*block*) is defined by its structure and **inner** layout, and therefore it *knows* if, for example, it's a `flex` or `grid` container, or whether its *elements* are `block` or `inline`. It shouldn't, however, reason or know about its location in the **external** layout. If, for example, we declare the `breadcrumbs` component as `position: absolute`, it will unnecessarily limit its reusability. So, it's better to leave such declarations to components that are designed to provide the overall page layout.

In our case, that's the `article` and `category` components' job. So, we create two new *elements* `article__breadcrumbs` and `category__breadcrumbs`, whose task is to place the `breadcrumbs` component within the section. Since the appearance and inner structure of the component are still handled by the `breadcrumbs` class, the result is a *composition* of classes: `<nav class="breadcrumbs category__breadcrumbs">`. Unlike the `.category .breadcrumbs { … }` solution, *composition* doesn't create a strong link between components and avoids *specificity*.

## Namespacing

The original purpose of *BEM* was to make developers' work easier and help them code better. Because of its clear syntax, it enhances code readability and eases orientation. We immediately know what we're dealing with, just by looking at the code. But can we make it even better?

Using the example of the `breadcrumbs` and `category` components, we see that the first one is a reusable component, while the other lays out a particular section. They're entirely different beasts. If that's not clear from the names, we'll make it obvious and add a *namespace* to the classes. `Breadcrumbs` becomes `c-breadcrumbs` and `category` takes the name of `l-category`. The *namespace* `c` (*component*) suggests that a class is a component — a closed module with a clear, specific use that is always the same. On the other hand, `l` (*layout*) gives the hint that a class provides page layout.

{{< figures/quote >}}
Whatever solution you choose — it doesn't have to be *BEM* — there's no reason to throw away the cascade. If you give it (and yourself) clear and hard rules, it will serve you well.
{{< /figures/quote >}}

We use three more *namespaces*. The first one, named `e` (*element*), is similar to `c` but used only on those components that don't have an inner structure (therefore no *BEM elements*). A good example is the `e-button` *element*, e.g. `<button class=“e-button”>Send</button>`. These are the simplest components.

The *namespace* `o` (*object*) is more complicated, but also more valuable in its meaning. It suggests a class that's in charge of the local structure and layout. The objects `o-block-list` and `o-inline-list` are good examples. The `o` in the title tells us that we're dealing with a structural element, not a specific component like a bullet list (which would have the `c-bullet-list` class). The `o-block-list` lays out its elements (called `o-block-list__item`) under each other, while `o-inline-list` puts them side by side. Also, both have a bunch of *modifiers* (such as `o-block-list--loose`), which are used to modify the spacing between elements. As *objects* can be used in many places and for different purposes, you can't predict where they end up, which means *objects* shouldn't be edited casually, because any change can have far-reaching consequences. It's better (and safer) to add new *modifiers*.

The last *namespace* is the *utility* class with the prefix `u`. These classes have only one specific purpose — which should be obvious from the name — such as `u-align-left` or `u-visually-hide`. However, they should be used sparingly. Unless we need the change only in one place or situation, it's better to create a new component or *modifier*.

Although not a *namespace* in the true sense, we also use the so-called JavaScript *hooks*, which we discern by the prefix `js`. They serve as a target class for selectors in JavaScript. If, for example, we want the `c-accordion` component to be interactive, we add the class `js-accordion`. In case the component or its name changes for some reason, the *hook* can remain the same and we don't have to change the script. On top of that, there are special status classes that start with `is-` or `has-`, like `is-active`. These indicate the state of a component, so we manage them through JavaScript and use them to target styles.

## Cascade: good servant, bad master

Whatever solution you choose — it doesn't have to be *BEM* — there's no reason to throw away the cascade. If you give it (and yourself) clear and hard rules, it will serve you well. The most important thing is to build the stylesheet in such a way that its *specificity* slowly rises on the scale of the whole document. It's a matter of giving the `@import` statements a logical order. The most general declarations and normalizations — like those to set up the basic typographic rules — which target selectors such as `*`, `html` or `a`, go first. They are followed by individual components. *Namespacing* complicates the situation a bit, because it's necessary to determine in which order (i.e. with what *specificity*) are the *namespaces* imported. In our case, we start with *objects* as these are the most general, continue with *layouts*, *elements* and *components*, and end with *utility*, which must have the highest *specificity*. Even if you devise something completely different, you can use the same considerations to create a system that makes sense to you and, most importantly, is sustainable in the long term.
