---
title: wol
subtitle: A minimal command-line Wake-On-LAN client.
date: 2022-11-05T09:45:19-05:00
draft: false
---

wol is a command-line tool for implementing the Wake-On-LAN protocol over a local-area network.

## USAGE

```
wol [OPTION...] <mac address>
Wake-On-LAN packet sender

  -i, --interface=NAME       Specify the net interface to use
  -p, --password=PASSWORD    Specify the WOL password
  -q, -s, --quiet, --silent  No output
  -?, --help                 Give this help list
      --usage                Give a short usage message
  -V, --version              Print program version
```

## FLAGS

`-i`, `--interface`
* Specify the network interface through which to send the magic packet.

`-p`, `--password`
* Supply a password in the magic packet to the Wake-On-LAN device.

`-q`, `-s`, `--quiet`, `--silent`
* Do not print any output.

`-?`, `--help`
* Output the usage and flags.

`--usage`
* Output the short usage message. 

`-V`, `--version`
* Output the version number.

## INSTALL

```shell
./autogen.sh
./configure
make
sudo make install
```

## CAVEATS

In order to use wol, the target computer must support Wake-On-LAN, which is typically a requirement of the network interface card.

## LICENSE

wol is licensed with [GNU GPL 3.0])http://www.gnu.org/licenses/gpl-3.0.txt).
