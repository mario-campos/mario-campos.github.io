---
layout: post
title: Shitty Software
date: 2017-02-21 00:00:00 -0600
tags: minimalism OpenBSD
---

Today, my boss asked me why I don't join the developers, noticing the talk [*Why Functional Programming Matters*](https://youtu.be/1qBHf8DrWR8) on my second screen. It was a rhetorical question, so I didn't answer. Otherwise, I might have said that software engineering is like trying to bake a wedding cake out of cake leftovers, frosting, and duct tape. [It's all shit.](http://tinyclouds.org/rant.html) Most software seems to be layers upon layers of obscure complexity, abstraction, and boilerplate middleware. And it will collapse under its own weight, if it hasn't already.


<span title="I'm looking at you, Graylog!">Resist the urge to require MongoDB as a configuration backend.</span> What's wrong with a file? Or SQLite? [Allow your users the luxury of ignorance.](http://www.catb.org/esr/writings/taouu/html/ch01s03.html) In general, if a user does not *need* a configuration knob, don't give them one, lest they will use it. Or worse yet, you may find it exposes a vulnerability to your application.


Less is more. While fancy features are nice, reliable fast-loading web pages are even nicer. Have you ever seen an app grow smaller and drop permissions over time? Me neither. An interesting side effect of reducing code size is an increase in performance. After all, [the fastest code is the code that never runs.](http://www.ilikebigbits.com/blog/2015/12/6/the-fastest-code-is-the-code-that-never-runs)


Don't use `pip` or whatever language-based package manager to deploy software. They lack in comparison to OS-based package managers. If you care about your users (and us system administrators), realize you're just adding an extra dependency to your software. Instead, I emplore developers to become package maintainers to their own software. Go the extra mile for your users.


Write readable, concise, descriptive documentation. Provide a brief tutorial, examples, an API guide, etc. Cover the corner cases. While I encourage plentiful documentation—the kind for which OpenBSD and Arch Linux is praised—I also warn you to Keep It Simple, Stupid. Too much documentation is only slightly better than too few. A sad amount of my time is devoted to wading through the swaths of books detailing the overly-convoluted update procedure of Shitty-Ass Software (SAS).


I think that's why, these days, I gravitate towards OpenBSD, and its stark nature for simplicity, minimalism, correctness, and security. In fact, it was [Ted Unangst's recent post on featuritis](http://www.tedunangst.com/flak/post/features-are-faults-redux) that inspired me to write this one. Sadly, this philosophy seems to be a minority.
