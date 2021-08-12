---
title: "More Hints for Writing Unix Tools"
layout: post
tags: Unix shell scripting
---
I've been meaning to write this post for a long time, because I've been thinking that it needs to be said explicitly somewhere. I learned these Unix conventions implicitly, via imitation, as I reckon most have. It wasn't until I read Marius Eriksen's [Hints For Writing Unix Tools](https://monkey.org/~marius/unix-tools-hints.html) that I felt inspired to write down what I've been saying to myself all these years.

If you haven't read his article yet, I highly recommend you do so now.

### Use `--` to separate options and arguments
There's a subtle danger to calling programs with the shell's wildcard, `*`. The shell will recognize `*` and expand it to all of the filenames in the current working directory. Now suppose you've got a file named `-l`. It's unorthodox, but not invalid. What do you think would happen? The invoked program, if it supported the `-l` flag, might interpret that `-l` filename as the `-l` command-line flag. Here's a simple proof-of-concept from my laptop:

#### With the `-l` file

```bash
$ touch -- '-l'
$ ls *
srwxrwxrwx  1 mario  wheel  0 Jun 10 15:51 dbus-pbu1VfrK2K
srwxrwxrwx  1 mario  wheel  0 Jun 10 15:51 dbus-zZv2gYpChF

aucat:
total 0
srw-rw-rw-  1 root  wheel  0 Jun 10 15:50 aucat0

ssh-HWh60iJW0hq3:
total 0
srw-------  1 mario  wheel  0 Jun 10 15:51 agent.93327

vi.recover:
```

#### Without the `-l` file

```bash
$ rm -- '-l'
$ ls *
dbus-pbu1VfrK2K dbus-zZv2gYpChF

aucat:
aucat0

ssh-HWh60iJW0hq3:
agent.93327

vi.recover:
```

Notice the difference? `ls` modified its output based on the presense of a particular file (or rather, its name), which is erroneous behavior. The astute reader will even notice that I had to use `--` to even create and delete the `-l` file. Otherwise, `touch` and `rm` might have misinterpreted it.

The `--` sequence is a command-line delimiter. It states, "this is the end of options; from here on out are arguments!" And it was created for just this case. And although it may not be needed often, it has its moments. Just the other day, my friend had trouble moving a file (with `mv`) because it started with a leading hyphen. Don't trust user input. Implement `--`.

### Reload configuration on SIGHUP
There is an unspoken "rule" about Unix daemons: they reload on `SIGHUP`. That is, conventionally, Unix daemons will re-read their configuration file(s) and then update their internal state when they receive the `SIGHUP` signal. Why reload? Because reloading is often faster and "cheaper" than a full restart. Okay, but why `SIGHUP`? `SIGHUP` is reserved for signalling to a process that its tty has been closed. Since a daemon doesn't need a tty anymore, it should never receive `SIGHUP` for the reasons it was intended; that leaves `SIGHUP` to be repurposed.

### Don't start in the background; fork(2)!
I've seen the "nohup cmd &" hack more times than I would like. It's a crude way to daemonize an application. The better solution is to have `cmd` handle its own daemonizing, by calling *fork(2)* and properly severing ties to the shell's environment. Explaining how to properly daemonize is beyond the scope of this paragraph, but these two articles are highly recommended:

* [Process Groups and Sessions](http://www.andy-pearce.com/blog/posts/2013/Aug/process-groups-and-sessions/)
* [Daemon-izing a Process in Linux](https://codingfreak.blogspot.com/2012/03/daemon-izing-process-in-linux.html)

### Implement -0 when outputting filenames
If you have ever piped `find` to `xargs`, you may have wondered why [it's recommended to pass the `-print0` and `-0` flags, respectively](https://stackoverflow.com/a/897043). The reason is because [most characters are allowed in Unix filenames](https://unix.stackexchange.com/a/155836), except the NUL byte (`\0`) and Unix path separator (`/`). That means you'll never see a NUL byte in a filename, so it is the perfect filename delimiter!

You can't always expect filenames to be consistent, regular, or even sensible. So if your Unix program is outputting a stream of filenames, implement a `-0` switch and then delimit filenames with the NUL byte to reliable handle irregular input.

### Implement a usage
A program's usage is one of those things that people take for granted. It's there when you've forgotten the command's syntax, but you're too lazy (admit it) to plow through the full man page. The usage is the "man page: cliff-notes edition." A simple `-h` or `--help` can go a long way for documention.

There are various ways to structure a usage, but that is out of the scope of this post--and, honestly, a bit too trite for words. For the curious, I implement my usages like so:

```
usage: cmd foo [-f file] [--] arg1 arg2 arg3
       cmd bar [-abc] [--] arg1
       cmd -V|--version
       cmd -h|--help
```

I try to implement these conventions into my programs so that my users don't have to work harder than they should. It's these little details--the little courtesies from one Unix programmer to another--that makes the Unix programming environment so powerful and pleasant. Or, at least, that is one of the reasons. Be kind to your fellow techies. Write quality software :)
