---
title: "My Password Generator"
layout: post
tags: Unix shell scripting
---
I often need to generate secure passwords for service accounts and what not. I could reach to one of the web-based "random" password generators, but I don't trust Javascript enough--and you shouldn't either. So, I've figured out a way to generate pseudorandom passwords, of any length, using nothing more than the standard tools provided by Linux:

```bash
$ </dev/urandom tr -dc [:graph:] | tr -d "Il10Oo\\\"'" | head -c 25; echo
8pG;gqA@_s<]K>E,z?hXW+D&h
```

Let's break it down!

* `</dev/urandom`
  - Provides a stream of pseudorandom characters.
* `tr -dc [:graph:]`
  - Filters out all characters that are not graphical (printable).
* `tr -d "Il10Oo\\\"'"`
  - Filters out all characters that are similar in shape.
  - Also filters out quotes and backslashes, as they might introduce problems when you copy/paste it into a command.
* `head -c 25`
  - Output the first 25 characters.
* `; echo`
  - Syntactic sugar. It appends a newline character, outputting the password to its own line, thereby making it easier to copy/paste.
  
That's it! To increase the password length (and thus security), adjust the "25." To simplify execution, paste it into a bash function or bash alias.
  
The only caveat is that randomness--or pseudorandomness--is based on `/dev/urandom`, which requires that a system be able to generate enough entropy. On personal computers, this shouldn't be a problem.
