---
title: dyndnsd
subtitle: A minimal, secure, and generic Dynamic-DNS daemon for OpenBSD.
date: 2022-11-04T21:07:01-05:00
draft: false
---

dyndnsd is a Dynamic-DNS daemon for OpenBSD. It is minimal, lightweight, intuitive, and generic/extensible enough to support any Dynamic-DNS provider. Whereas other Dynamic-DNS clients are scripted, one-shot, or limited to certain DNS providers, dyndnsd aims to be a simple and secure C program that runs quietly in the background, updating your DNS provider only as often as necessary. Furthermore, it supports any DNS provider by supplying it a command to execute, rather than an HTTP URL.

## USAGE

```
dyndnsd [-dhnv] [-f _file_]
```

## FLAGS

`-d`
* Run dyndnsd in debug mode.

`-f`
* Specify the dyndnsd configuration file as _FILE_.

`-n`
* Validate the configuration file, then terminate.

`-h`
* Output the usage and flags.

`-v`
* Output the version number.

## EXAMPLES

First, create the configuration file, */etc/dyndnsd.conf*:

```
run "curl https://www.duckdns.org/update?domains=${DYNDNSD_FQDN}&token=sometoken&ip=${DYNDNSD_IPADDR}"

interface em0 {
	domain www.example.com
}

interface em1 {
	domain ftp.example.com
}
```

Test the configuration file:

```shell
dyndnsd -n
```

Then, start the daemon:

```shell
dyndnsd
```

## SUPPORTED OPERATING SYSTEMS

* OpenBSD
