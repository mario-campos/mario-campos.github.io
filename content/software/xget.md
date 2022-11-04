---
title: xget
subtitle: A minimal, secure, command-line tool for interfacing with XDCC senders.
date: 2022-11-04T11:52:14-05:00
draft: true
---

## Usage
```
usage: xget [-A|--no-acknowledge] [-O|--output-document] <uri> <nick> send <pack>
```

In its most basic form, xget accepts a number of arguments: an IRC URI, which denotes the hostname, scheme, port number, and IRC channels to join; the XDCC-sending nick name; `send`, the XDCC command; and the pack number to request.

The URI format is `irc://HOSTNAME[:PORT]/[#]CHANNEL[,[#]CHANNEL...]`. If the port number is not specified, the port number TCP/6667 will be used. The URI may contain one or more IRC channels&mdash;optionally prefixed with an octothorpe (`#`)&mdash;each of which will be joined.

## Flags

`-A`, `--no-acknowledge`
  * This flag may be used to suppress xget from returning file offsets as acknowledgements. Although it is DCC protocol to send these acknowledgements, many DCC senders don't require them&mdash;some will even abort the DCC transfer if too many acknowledgements are sent.

`-O`, `--output-document`
  * This flag may be used to create the file with a given name, instead of the name provided by the DCC sender. This option requires one argument: the new name and/or path of the file to be downloaded.

## Examples

Request pack #34 from nick _super-duper-bot_ with `XDCC SEND` on the IRC network irc.sampel.net, after joining the IRC channel _#best-channel_.

``` 
xget irc://irc.sampel.net/#best-channel super-duper-bot send 34
``` 

Request pack #34 from nick _super-duper-bot_ with `XDCC SEND` on the IRC network irc.sampel.net, connected via port TCP/1337, after joining the IRC channel _#best-channel_.

``` 
xget irc://irc.sampel.net:1337/#best-channel super-duper-bot send 34
```

Request pack #34 from nick _super-duper-bot_ with `XDCC SEND` on the IRC network irc.sampel.net, after joining the IRC channels _#best-channel_ and _#best-chat-channel_.

``` 
xget irc://irc.sampel.net/#best-channel,#best-chat-channel super-duper-bot send 34
``` 

## Supported Operating Systems:

* GNU/Linux
* OpenBSD
* FreeBSD
* macOS
