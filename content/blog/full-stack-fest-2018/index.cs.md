---
title: Full Stack Fest 2018
slug: full-stack-fest-2018
date: 2019-01-03
keywords:
    - web
    - konference
menu:
    main:
        parent: 'blog'
photoDesc: La Sagrada Familia — Paolo Nicolello
photoUrl: https://unsplash.com/photos/Bx60CBuweYA
accentColor: "#6987b0"
---

Měli jste někdy chuť na pódium hodit tu tašku plnou zbytečností, co navzdory zdravému rozumu na konferencích stále rozdávají? Mně se to občas stává. Místo zajímavých zkušeností nebo myšlenek přednáška obsahuje výčet dokumentace, a osoba na pódiu se navrch tváří, že je to zajímavé.

<!--more-->

Taková zhůvěřilost se na [Full Stack Fest](https://fullstackfest.com/) naštěstí děje jen výjimečně. Jde o pětidenní konferenci, rozdělenou vpůli na dva bloky, zhruba označené jako back-end a front-end, a přestože mám blíž k tomu druhému, s radostí si rozšířím obzory i u prvního. Že se to celé koná v Barceloně, rozhodně neuškodí. Na letošním ročníku dominovaly dvě témata: na straně back-endu to byly peer-to-peer technologie a decentralizace obecně, zatímco ve světě front-endu stále vítězí výkon a jeho optimalizace.

## Decentralizace internetu

Narozdíl od předchozího roku se spolu s decentralizací automaticky nespojovalo slovo blockchain — i když i na něj došlo, v jeho privátní (tedy nesmyslné) podobě v ~~reklamě~~ [prezentaci od IBM](https://youtu.be/v2WiqQs_JAs). Mnohem zajímavější byla [přednáška od Andreho Staltze](https://youtu.be/8GE5C9-RUpg). Mluvil o — mně sympatické — snaze, jak nahradit současný model sociálních sítí jeho decentralizovanou alternativou. A jelikož základní kámen každé peer-to-peer sítě je protokol, popisoval možné řešení na konkrétní technologii jménem [Scuttlebutt](https://www.scuttlebutt.nz/). Na moji otázku, jak si Scuttlebutt stojí v porovnání s [projektem Solid](https://solid.mit.edu/) od Tima Berners-Leeho, který řeší podobnou množinu problémů, Andre odpověděl, že zatímco Solid vzniká nejprve jako specifikace, a až v závěsu jako implementace, volí Scuttlebutt přesně opačnou cestu. Tedy tu nutně divočejší, ale pro ty, kdo by se rádi zapojili, nepochybně zajímavější.

{{< figures/quote >}}
Ať už mluvíme o mikroslužbách, distribuovaných databázích, blockchainu, nebo o čerstvém příslibu takzvaného „Webu 3.0“, decentralizaci se v budoucnu nevyhneme.
{{< /figures/quote >}}

Podobné téma, ale jiný úhel pohledu, [přednášela Tara Vancil](https://youtu.be/raUE23RKLvE), která je součástí týmu kolem experimentálního [prohlížeče Beaker](https://beakerbrowser.com/). Ten sebevědomě cílí přímo na jeden ze základů internetu — protokol HTTP — a míní ho nahradit protokolem jménem [DAT](https://datproject.org/), který staví na principech peer-to-peer technologií. Podobně jako BitTorrent rozbíjí tradiční schéma server a klient, a nahrazuje ho komplexní sítí rovnocenných uzlů. Pokud chci přispět obsahem (třeba webovou stránkou) musím se do sítě zapojit a z počátku nechat svůj počítač figurovat jako „server“. Zajímavá část přichází, když si moje stránky zobrazí první návštěvníci. Tehdy se i oni stanou poskytovateli a web díky tomu existuje na několika různých místech, jejichž počet je odvozen od jeho oblíbenosti. Tím zaniká nutnost, aby můj počítač byl vždy připojen — dokud je k síti připojen alespoň jeden z uzlů, který si moje stránky zobrazil, jsou stále dostupné. Zároveň tak vzniká obsah, u kterého dramaticky vzrůstá odolnost vůči cenzuře. Vzpomeňme třeba na zákaz Wikipedie v Turecku nebo model centrálně kontrolovaného internetu v Číně.

Smyslem Beakeru je umožnit běžnému uživateli takový obsah vytvářet a číst, a rozšířit povědomí o tomto alternativním pojetí internetu. Zároveň částečně skrývá komplexitu, která v takové decentralizované síti nutně vzniká a se kterou se jako tvůrci i uživatelé budeme potýkat čím dál častěji. Ať už mluvíme o mikroslužbách, distribuovaných databázích, blockchainu, nebo o čerstvém příslibu takzvaného „Webu 3.0“, decentralizaci se v budoucnu nevyhneme. Ve spojitosti s Beakerem mě mrzí jen jedna věc. Nepodporuje technologii velmi podobnou protokolu DAT, kterou je — možná o něco známější — protokol [IPFS](https://ipfs.io/).

{{< figures/image "tara-vancil.jpg" "Tara Vancil uvedla experimentální prohlížeč Beaker, jehož cílem je nabídnout internet, který nestaví na protokolu HTTP, ale na jeho peer-to-peer alternativě v podobě protokolu DAT." >}}

## Svatý grál optimalizace?

Z druhé strany barikády proběhlo několik příspěvků ke vždy aktuálnímu tématu optimalizace z pohledu prohlížeče. A navzdory několika novinkám stále platí závěr, že jde o zrádnou oblast, byť se tu a tam konečně objevují náznaky elegantních řešení.

Zásadní byla v tomto ohledu [přednáška od Patricka Hamanna](https://youtu.be/ga_-zsTHRm8), který díky svému angažmá ve Fastly — a podobně jako [Jake Archibald](https://jakearchibald.com/2017/h2-push-tougher-than-i-thought/) — ukázal, že takzvaný HTTP push je v praxi mnohem komplikovanější téma, než jsme si naivně mysleli. Server push byl jedním z příslibů protokolu HTTP2, který alespoň na papíře řeší základní problém optimalizace načtení webu. Jak klientovi co nejrychleji poslat všechny soubory nutné pro vykreslení stránky? Server ví přesně, které soubory to jsou, ale klient musí nejprve stáhnout a zpracovat HTML, aby získal přehled o dalších závislostech jako styly nebo obrázky. Server push umožňuje na základě jednoho požadavku místo pouhého HTML souboru poslat teoreticky všechny závislosti, aniž by si je klient sám vyžádal. Problém ovšem — jako obvykle — vzniká, když do úvah zapojíme cache. Ta se objevuje na několika úrovních (paměť, service worker, HTTP cache, a nově push cache), a navrch se v různých prohlížečích chová odlišně. Řešení samozřejmě není jednoduché a jako vždy je založené na kompromisech. V kombinaci se současnými a budoucími technikami jako [Cache Digest](https://tools.ietf.org/html/draft-ietf-httpbis-cache-digest-04), [Early Hints](https://tools.ietf.org/html/rfc8297) nebo [preloading](https://w3c.github.io/preload/) jde nicméně i tak o velký krok kupředu.

{{< figures/quote >}}
Server push byl jedním z příslibů protokolu HTTP2, který alespoň na papíře řeší základní problém optimalizace načtení webu.
{{< /figures/quote >}}

[Přednáška o nativních modulech v JavaScriptu](https://youtu.be/O4r9D2jI0_w), ve které Serg Hospodarets předvedl, že není důvod otálet vyzkoušet moduly na produkčním prostředí — ať už v prohlížeči nebo v Node.js — byla o mnoho veselejší. Ještě nějakou dobu se sice neobejdeme bez skriptů transpilovaných a zabalených do jednoho balíčku, ale díky direktivě `nomodule` můžeme těm prohlížečům, které moduly podporují, poslat výrazně méně dat a využít HTTP2 multiplexingu. Jedinou vadou je zatím nedostatečná podpora pro dynamické nahrávání modulů, a s tou nám bohužel žádná direktiva nepomůže.

Zack Argyle [vyprávěl](https://youtu.be/pluzva6Dk9Q), jak si v Pinterestu poradili s mobilním webem. Po prvotním rozhodnutí tlačit uživatele ke stažení nativní aplikace, které se ukázalo být neštastné (kdo by to čekal?), usoudili, že všechny síly naopak věnují právě mobilnímu webu a od základů ho předělají. Výsledkem jsou stránky postavené na Reactu a principech PWA (progressive web app). Výjimečná je v tomto ohledu snaha Pinterestu na poli optimalizace, kde využívají všech možností, od agresivního cachingu na úrovni service workeru, vykreslení části aplikace na serveru (server-side rendering), až po striktní limit na množství kódu, které musí uživatel stáhnout. Poslednímu bodu se věnovala i Sia Karamalegos. Ve své [prezentaci](https://youtu.be/SA_Hp8l7lr4) opakovala nepříliš známý fakt, že ačkoliv v množství stažených dat stále vedou obrázky, je skutečným „vítězem“ JavaScript. Důvod tkví v tom, že každý byte kódu vyžaduje větší množství operací nutných pro jeho zpracování než v případě obrázku, tudíž i více zatěžuje procesor, jehož kapacity obzvlášť na mobilních zařízení nejsou neomezené.

Na závěr doporučuju zhlédnout [video](https://youtu.be/K0WU02flF_E), kde Andrew Louis ukazuje, jak to vypadá, když se pokusíte zaznamenat co největší množství detailů z vlastního života v digitální podobě. Andrew se toho snaží dosáhnout tak, že vytvořil a dále vyvíjí [moderní verzi memexu](https://hyfen.net/memex/) — ideového předchůdce hypertextu. Pokud máte úchylku na organizaci dat nebo se naopak obáváte, že to občas přeháníte s digitálním životem na úkor toho skutečného, možná vás přednáška uklidní.