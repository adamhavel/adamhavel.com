---
title: The Primer on Icon Sprites
date: 2018-11-22
keywords:
    - web
    - optimizations
menu:
    main:
        parent: 'blog'
photoDesc: Khadeeja Yasser
photoUrl: https://unsplash.com/photos/3U9L9Chc3is
---

Even though small in size, icons seem to occupy a lot of space in the collective mind of the web development community. One way of handling icons replaces next -- each method a little better than the previous, each bringing its own set of problems. The last one to emerge is the so-called SVG sprite.

<!--more-->

A sprite is created by putting the icon shapes inside `symbol` elements in a SVG file. Symbols are used because unlike other SVG objects, they aren't rendered until you use them. Unless you want to create the sprite manually, you can use one of the many solutions available to automate the process, such as grunt-svgstore or gulp-svgsprite.

{{< figures/code >}}
```xml
<svg>
    <symbol viewBox="0 0 32 32" id="close">
        <path d="..." />
    </symbol>
    <symbol viewBox="0 0 32 32" id="search">
        <path d="..." />
    </symbol>
    ...
</svg>
```
{{< /figures/code >}}

To display an icon -- assuming we have the sprite ready and loaded (we’ll get to that) -- write an inline SVG containing a single `use` element which references the icon’s `id` using the `xlink:href` attribute. That’s the easy part.

```xml
<svg>
    <use xlink:href="#search"></use>
</svg>
```

Loading the sprite is a bit more involved. First, linking an external SVG sprite (via `xlink:href="sprite.svg#id"`) won't work in Internet Explorer (it will in Edge, though). That leaves you with two options: either put the sprite directly into all templates, or use AJAX and inject it on load. You can choose a third option and do it dynamically on the server side, but that doesn't solve the problem of caching two independent resources as one. That's where the second option comes to rescue. It consists of a small script directly inlined into a document's `head`. Apart from icons, the script can be used to load other non-critical assets such as fonts.


```javascript
(function(w) {
    'use strict';

    function getType(src) {
        return src.match(/\.([^\.\?]+)(?:\?.*)?$/)[1];
    }

    function injectContent(content, type) {
        if (type === 'css') {
            var style = document.createElement('style');

            document.head.appendChild(style);
            style.textContent = content;
        } else {
            document.head.insertAdjacentHTML('beforeend', content);
        }
    }

    w.loadFile = function(src) {
        if (!w.localStorage || !w.addEventListener) {
            return false;
        }

        var content = localStorage[src];

        if (content) {
            injectContent(content, getType(src));
        } else {
            var xhr = new XMLHttpRequest();

            xhr.addEventListener('load', function() {
                localStorage[src] = xhr.responseText;
                injectContent(xhr.responseText, getType(src));
            });

            xhr.open('GET', src);
            xhr.send();
        }
    };

})(window);
```

When you call the function, it makes an asynchronous request for the provided file URI. The file is then both saved in `localStorage` and injected into a document. The injection method depends on the file type: stylesheets are appended as `textContent` inside a new `style` node, and SVG sprites are injected directly into `head`, using the `insertAdjacentHTML` function. Putting the sprite into `body` would be better, but alas, that part of the document doesn't yet exist when the script runs. A SVG element might not be a valid part of `head`, but it works.

The upside of loading the sprite using the script lies in the fact that it won’t block the critical rendering path. That means faster loading times. An important caveat though: the icons won't show if JavaScript is disabled. There's no solution I know of (such as `noscript` for stylesheets), that doesn't require putting the whole sprite into the document. That means you have to treat icons as an enhancement and always use them alongside textual labels -- a good idea anyway.

If nothing goes wrong, icons should render almost instantaneously -- depending on the network, of course. When viewed for a second time, there should be no wait whatsoever as the sprite loads directly from `localStorage`, bypassing the request. Even though accessing `localStorage` requires a synchronous -- therefore blocking -- operation, it should be fast enough and more reliable than regular browser cache.

Getting that done and over with, we can finally get to the good parts. When you inline a SVG directly into the document, its structure becomes part of DOM. That means you can control and manipulate everything. The obvious use is changing an icon fill color dynamically depending on the context by using the CSS `currentColor` variable. But icons fonts can do that too. SVG lets you control any property you want, not only the color.

There are several ways to style an icon. First, you can put a presentational attribute such as `fill="currentColor"` on the icon itself or its parts. But most of your icons are probably going to look and behave the same, so it's a good idea to define the property globally. You could write an inline CSS in the SVG sprite to style all symbols at once. But depending on the way you create the sprite, that might prove difficult. A better method is to style icons in your global stylesheet using SVG properties such as `fill` or `stroke`. There are two important things to remember though: the cascade and the specificity.

To begin with, an inline `style` attribute trumps everything. Any styles put at the top of the sprite come next, followed by inline attributes such as `fill` or `stroke`. Finally, anything you write in your global stylesheet has -- assuming the same selector -- the lowest priority. With this cascade in mind, you could employ various approaches. I think it’s best to stick with the global stylesheet and strip all inline attributes when creating the sprite. If you need an icon that doesn't change its color depending on context (e.g. social media icons), define the color directly with a `style` attribute and keep it there. Another trick is to style some part of an icon with the `fill` property set to a specific color, and other with `fill` set to `currentColor`. That gives you the option to dynamically change two colors at once by changing either `fill` and `color`.

Each symbol in the sprite should have a properly defined `viewbox` of its own, but on top of that, it’s best to set a default width and height on each icon element in a template. Otherwise, any SVG without dimensions -- either set directly or by CSS -- will render with width and height of 300 and 150 pixels. That could happen when your styles fail to load or, if you fetch them in a non-blocking manner, before they had the chance to apply.

```xml
<svg width="32" height="32" class="e-icon">
    <use xlink:href="#search"></use>
</svg>
```

Another attribute worth mentioning is `role`. Set it to `image` if you want to make sure an icon is regarded as one by screen readers. But you shouldn’t employ icons on their own anyway, so it’s actually better to hide their presence from screen readers altogether by setting the `aria-hidden` attribute to `true`. If you still wish to use icons without a label, don’t forget to advertise their meaning with the attribute `aria-label`.

```html
<button>
    <svg aria-hidden="true">
        <use xlink:href="#search"></use>
    </svg>
    <span>Search</span>
</button>
```

```html
<button>
    <svg role="image" aria-label="Search">
        <use xlink:href="#search"></use>
    </svg>
</button>
```

If you require to support a browser that can't handle SVG, you can still employ the system as described before, only with some additional steps. First, you must generate PNG versions of your icons. A second step would be to check for SVG support. You can do that by using Modernizr or by asking the `document.implementation` object. The general idea is to replace the SVG element with a regular `img` that points to the PNG version of the icon. There are, however, several problems to tackle.

To begin with, you need to obtain the icon's `id` in order to construct the image URL. The browser in question doesn’t support SVG though, so it can’t read the `use` element which harbours the `xlink:href` attribute we need. The solution is to extract the type with a regular expression, run on the icon's parent node's `innerHTML`. Another problem is that Internet Explorer 8 treats the new injected image as if it had no dimensions. To help with that, a blank block element has to be placed alongside the new icon and styled the same way as a regular icon. And finally, the loading script won't work in Internet Explorer 8, but it can be easily modified to support it (replace `addEventListener()` with `onload` and so on).

```js
if (!document.implementation.hasFeature('http://www.w3.org/TR/SVG11/feature#Image', '1.1')) {
    [].forEach.call(document.querySelectorAll('svg.e-icon'), function(icon) {
        var fallbackIcon = document.createElement('img');
        var placeholder = document.createElement('div');
        var parent = icon.parentNode;
        var type = parent.innerHTML.match(/xlink:href=["']?#([^"'>\s]+)["']?/i)[1];

        fallbackIcon.classList.add('icon');
        placeholder.classList.add('j-icon-placeholder');
        fallbackIcon.src = 'img/' + type + '.png';

        parent.insertBefore(placeholder, icon.nextSibling);
        parent.replaceChild(fallbackIcon, icon);
    });
}
```

```scss
$iconSize: 1em;

.e-icon,
.j-icon-placeholder {
    $size: 1em;

    width: $iconSize;
    height: $iconSize;
    display: inline-block;
    vertical-align: -.15em;
}

.e-icon {
    $gap: .5em;

    fill: currentColor;

    &:first-child {
        margin-right: $gap;
    }

    &:last-child {
        margin-left: $gap;
    }

    &:first-child:last-child {
        margin: 0;
    }

    .no-svg & {
        margin-left: $gap;

        &:first-child {
            margin-left: 0;
            margin-right: -$iconSize;

            ~ * {
                margin-left: $gap;
            }
        }
    }
}
```

The last use case concerns a situation where you need an icon for something like a list bullet. Let's assume the bullet is complex enough that you can't produce it only with CSS or Unicode symbols. You could put an `use` element in each list item, but that’s needless repetition. Now imagine a scenario where you want to use the same icon in different contexts, each requiring a different color. Even if you inlined the SVG directly into a stylesheet, you can’t alter the icon properties depending on the context. One solution would be to use icon fonts as an alternative system for cases like this. That'd give you the option to change the bullet's fill by simply changing its text color. But to me, that seems way too complicated.

In an attempt to solve this conundrum, I tried an approach that exploits CSS filters, specifically the `drop-shadow`. Unlike the `box-shadow` property, which produces rectangular shadows (including any rounded corners or transformations), the `drop-shadow` filter takes the exact shape of an element into account. Changing the bullet color is therefore as simple as changing the color of its shadow. That is, if you manage to hide the original icon producing the shadow.

You can't make the icon transparent or move its background position out of the element container, because that would make the shadow disappear. What works is positioning the icon out of its container and setting the `overflow` property on the container to `hidden`. By adjusting the `drop-shadow` offset to the negative of the icon's translation value, the shadow remains the only visible part of the bullet. Of course, this solution is far from ideal. To begin with, filters aren't supported in any version of Internet Explorer. You can, however, easily target non-supporting browsers with Modernizr and restore the original icon. Second, using filters in this manner might hinder the rendering performance. And the worst part, this technique stopped working in the latest Chrome -- the shadow won’t show if the original icon isn’t visible, regardless the technique used.

```scss
.c-bullet-list {

    > li {
        position: relative;
        padding-left: 1.5em;
        overflow: hidden;

        &:before {
            $size: 1em;

            width: $size;
            height: $size;
            content: '';
            position: absolute;
            top: ($lineHeight * .5em) - ($size / 2);
            left: -$size;
            background: url('img/icon/arrow.svg') center no-repeat;
            background-size: auto 100%;
            color: cyan;
            filter: drop-shadow($size 0 0 currentColor);
        }

        .no-cssfilters & {
            overflow: visible;

            &:before {
                left: 0;
            }
        }
    }
}
```

That leaves us with only one viable option, the one I already mentioned: inlining an icon into a stylesheet as a data URI.
This technique allows us to skip a blocking network request and provides a way to alter the icon directly in CSS. On top of that, if you are going to use an icon more than once and have a preprocessor in place, you can create a mixin or a function that could provide a way to color the icon using parameters. It won’t help the repetition, but it will at least provide a single point of truth. Of course, any such icon shouldn’t be overly complex. On the other hand, the more you use it, the better it can be compressed.

```scss
@function bullet($color) {
    @return url('data:image/svg+xml;charset=utf-8,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%2010.7%2016%22%3E%3Cpath%20fill%3D%22#{$color}%22%20d%3D%22M.7%202.7L6.4%208%20.6%2013.3%202.4%2015%2010%208%202.4%201%20.7%202.7z%22%2F%3E%3C%2Fsvg%3E');
}
```