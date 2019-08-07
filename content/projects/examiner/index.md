---
title: Examiner
date: 2014-05-21
menu:
    main:
        parent: 'projects'
keywords:
    - app
    - website
thumbCrop: right
---

Examiner is a web application for both teachers and students. Its purpose is to help the first group with the dull process of creating and evaluating written tests. The students, then, use the same application for taking the tests. At the end, both groups part ways. Hopefully in peace.

<!--more-->

{{< peristyle title="Inspiration" img1="img/notebooks.jpg" img1-caption="Vanguard notebooks" img2="img/bookmark.jpg" img2-caption="Confidant notebook's bookmark" saturation="saturated" >}}
The design was heavily inspired by notebooks from the company [Baron Fig](https://www.baronfig.com/) that I used when studying at college. I was especially drawn to the bold colors and accents Baron Fig chose for their notebooks, like the distinct yellow cloth bookmark. I wanted the application to feel as physical as possible, without resorting to overt skeuomorphism, keeping the look clean and simple. So, taking cues from the notebooks, I've decided to make it resemble a piece of paper, with colorful ribbons for a menu.
{{< /peristyle >}}

{{< asymmetric-with-grid title="Workflow" img1="img/process1.png" img2="img/process2.png" img3="img/process3.png" img4="img/process4.png" >}}
It begins when a teacher decides to create a new test. At first, he is presented with an empty sheet of paper. Using the provided controls, he quickly fills the paper with various sections and questions. A question consists of various types of content mixed together, for example simple text, code example, image, or diagram, drawn direcly in the application. An answer can be a similar mix, or it can take a form of multiple choice. When finished, the test is saved and assigned a subject. All that remains, then, is giving it a date and time, and it's ready for taking.
{{< /asymmetric-with-grid >}}

{{< stack "Cheating" "img/cheating1.png" "img/cheating2.png" >}}
Before allowed further, a student is presented with a modal citing a passage from the Ethical codex of CTU which she has to acknowledge in order to continue. While seemingly a superfluous formality, the reasoning behind this step is based on research by Dan Ariely, who led a series of experiments on cheating. As Ariely concluded, “recalling moral standards at the time of temptation can work wonders to decrease dishonest behavior and potentially prevent it altogether.”

If that doesn't help, two techniques are employed to prevent — and hopefully discourage — students from cheating. When a student switches to a different browser tab or opens another application, the teacher leading the exam immediately receives a notification. A resourceful student, however, might think of a way to slip through. If he perhaps prepares a file with notes and resizes the browser window in advance so that the notes can be seen, this technique alone won't stop him. The application on the student’s computer therefore calculates how much of the screen is used by the browser and if it's not 100&nbsp;%, his cover is blown.
{{< /asymmetric-with-grid >}}



