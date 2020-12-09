Title: Meson, First Impressions
Author: Mario Campos
Date: 2016-05-02
Summary: The pains and joys of using Meson for the first time!
Tags: GNU Autotools, Meson, build system, C

I am going through the [Matasano Crypto Challenges](http://cryptopals.com/){:rel="nofollow"} right now. Since the challenges seem to be one-input-one-output, question-answer oriented, I've setup GNU Autotools to build a binary for each challenge:

```bash
mario@bobthebuilder ~ $ ./s1c1
SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t
```

Recently, however, I have come across [Meson](http://mesonbuild.com/){:rel="nofollow"}, the new-and-improved C/C++ build system. So, I thought I'd describe my experience installing Meson, and building my (albeit simple) project.

Installing Meson
----------------

The download page indicates that I might need a dependency, [Ninja](https://martine.github.io/ninja/){:rel="nofollow"}:

```bash
mario@bobthebuilder ~ $ sudo apt-get update
mario@bobthebuilder ~ $ sudo apt-get install ninja-build
```

Installing Meson turned out to be easier than I thought it would be. Although the download page doesn't mention it, Meson is on PyPi!

```bash
mario@bobthebuilder ~ $ virtualenv -p `which python3` meson
Running virtualenv with interpreter /usr/bin/python3
Using base prefix '/usr'
New python executable in /home/mario/meson/bin/python3
Also creating executable in /home/mario/meson/bin/python
Installing setuptools, pip, wheel...done.
mario@bobthebuilder ~ $ cd meson/
mario@bobthebuilder ~/meson $ . bin/activate
(meson) mario@bobthebuilder ~/meson $ pip3 install meson
Collecting meson
  Downloading meson-0.31.0.tar.gz (465kB)
    100% |████████████████████████████████| 471kB 1.7MB/s 
Building wheels for collected packages: meson
  Running setup.py bdist_wheel for meson ... done
  Stored in directory: /home/mario/.cache/pip/wheels/9a/53/3f/56f0fedfbc336d525154c8eedd637f7d980bd594ebd01d254a
Successfully built meson
Installing collected packages: meson
Successfully installed meson-0.31.0
(meson) mario@bobthebuilder ~/meson $ meson.py --version
0.31.0
```

Running Meson
-------------

My directory layout is pretty simple and flat:

```bash
(meson) mario@bobthebuilder ~/meson/src $ tree 
.
├── base64.c
├── base64.h
├── hex.c
├── hex.h
├── math.c
├── math.h
├── meson.build
├── s1c1.c
├── s1c1.h
├── s1c2.c
├── s1c3.c
├── xor.c
└── xor.h

0 directories, 13 files
```

Notice that my *meson.build* file is also very small and simple, since I'm only testing this out on one executable right now:

```bash
(meson) mario@bobthebuilder ~/meson/src $ cat meson.build 
project('matasano', 'c')
executable('s1c1', 's1c1.c')
```

Now, all I do is create a *build* directory and run `meson.py` on it:

```bash
(meson) mario@bobthebuilder ~/meson/src $ mkdir build
(meson) mario@bobthebuilder ~/meson/src $ meson.py build
The Meson build system
Version: 0.31.0
Source dir: /home/mario/meson/src
Build dir: /home/mario/meson/src/build
Build type: native build
Build machine cpu family: x86_64
Build machine cpu: x86_64
Project name: matasano
Native c compiler: cc (gcc 4.8.4-2ubuntu1)
Build targets in project: 1
ninja: fatal: ninja version (1.3.4) incompatible with build file ninja_required_version version (1.5.1).
Traceback (most recent call last):
  File "/home/mario/meson/lib/python3.4/site-packages/mesonbuild/mesonmain.py", line 254, in run
    app.generate()
  File "/home/mario/meson/lib/python3.4/site-packages/mesonbuild/mesonmain.py", line 158, in generate
    g.generate(intr)
  File "/home/mario/meson/lib/python3.4/site-packages/mesonbuild/backend/ninjabackend.py", line 196, in generate
    self.generate_compdb()
  File "/home/mario/meson/lib/python3.4/site-packages/mesonbuild/backend/ninjabackend.py", line 202, in generate_compdb
    jsondb = subprocess.check_output([ninja_exe, '-t', 'compdb', 'c_COMPILER', 'cpp_COMPILER'], cwd=builddir)
  File "/usr/lib/python3.4/subprocess.py", line 620, in check_output
    raise CalledProcessError(retcode, process.args, output=output)
subprocess.CalledProcessError: Command '['ninja', '-t', 'compdb', 'c_COMPILER', 'cpp_COMPILER']' returned non-zero exit status 1
```

Well, that's a bummer. The error message is pretty clear, though: I need a newer version of Ninja, at least v1.5.1. After uninstalling Ninja through `apt-get`, I downloaded the Ninja binary directly from the GitHub release page:

```bash
(meson) mario@bobthebuilder ~ $ wget https://github.com/ninja-build/ninja/releases/download/v1.7.1/ninja-linux.zip
--2016-05-02 18:50:34--  https://github.com/ninja-build/ninja/releases/download/v1.7.1/ninja-linux.zip
# ...
HTTP request sent, awaiting response... 200 OK
Length: 74111 (72K) [application/octet-stream]
Saving to: ‘ninja-linux.zip’

100%[======================================>] 74,111       392KB/s   in 0.2s   

2016-05-02 18:50:34 (392 KB/s) - ‘ninja-linux.zip’ saved [74111/74111]
(meson) mario@bobthebuilder ~ $ unzip -l ninja-linux.zip 
Archive:  ninja-linux.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
   175240  2016-04-28 10:39   ninja
---------                     -------
   175240                     1 file
(meson) mario@bobthebuilder ~ $ unzip ninja-linux.zip 
Archive:  ninja-linux.zip
  inflating: ninja
(meson) mario@bobthebuilder ~ $ sudo mv ninja /usr/local/bin/
(meson) mario@bobthebuilder ~ $ which ninja
/usr/local/bin/ninja
(meson) mario@bobthebuilder ~ $ ninja --version
1.7.1
```

Once I installed Ninja 1.7.1, I re-ran the `meson.py build` command, but that "failed." Evidently, since I already ran Meson to produce a Ninja build file, I no longer needed to run Meson again. Meson will "recompile" itself. Or rather, it will self-regenerate the Ninja build file, after editing *meson.build*. Neat! So, I ran `ninja`:

```bash
(meson) mario@bobthebuilder ~/meson/src/build $ ninja
[1/2] Compiling c object 's1c1@exe/s1c1.c.o'
FAILED: s1c1@exe/s1c1.c.o 
cc  '-Is1c1@exe' '-I..' '-I.' '-pipe' '-Wall' '-Winvalid-pch' '-O0' '-g' '-MMD' '-MQ' 's1c1@exe/s1c1.c.o' '-MF' 's1c1@exe/s1c1.c.o.d' -o 's1c1@exe/s1c1.c.o' -c ../s1c1.c
In file included from ../s1c1.c:4:0:
../hex.h:6:39: error: expected ‘;’, ‘,’ or ‘)’ before ‘hex’
 size_t hextobin(const char * restrict hex, uint8_t * restrict bin);
                                       ^
../hex.h:8:40: error: expected ‘;’, ‘,’ or ‘)’ before ‘bin’
 void bintohex(const uint8_t * restrict bin, const size_t size,
                                        ^
In file included from ../s1c1.c:5:0:
../base64.h:6:42: error: expected ‘;’, ‘,’ or ‘)’ before ‘base64’
 size_t base64tobin(const char * restrict base64, uint8_t * restrict bin);
                                          ^
../base64.h:8:43: error: expected ‘;’, ‘,’ or ‘)’ before ‘bin’
 void bintobase64(const uint8_t * restrict bin, const size_t size,
                                           ^
In file included from ../s1c1.c:6:0:
../s1c1.h:3:40: error: expected ‘;’, ‘,’ or ‘)’ before ‘hex’
 void hextobase64(const char * restrict hex, char * restrict base64);
                                        ^
../s1c1.c:8:40: error: expected ‘;’, ‘,’ or ‘)’ before ‘hex’
 void hextobase64(const char * restrict hex, char * restrict base64) {
                                        ^
../s1c1.c: In function ‘main’:
../s1c1.c:19:3: warning: implicit declaration of function ‘hextobase64’ [-Wimplicit-function-declaration]
   hextobase64(hex, base64);
   ^
../s1c1.c:21:1: warning: control reaches end of non-void function [-Wreturn-type]
 }
 ^
ninja: build stopped: subcommand failed.
```

If you examine this closely, you'll see I've got two general errors in compiling *s1c1.c*.

First, `$CC` seems to be choking on `restrict`, which means I've got to set the language standard somewhere. The only reference I could find of that is in [Adding Arguments](https://github.com/mesonbuild/meson/wiki/Adding-arguments){:rel="nofollow"}, but only a small blurb:

> Note that for setting the C/C++ language standard (the `-std=c99` argument in Gcc), you would probably want to use a default option of the `project()` function.

That wasn't much to go on, especially since I couldn't find an API for `project()`. I initially tried changing the `project()` line of *meson.build* to something like, `project('matasano', 'c11')`, but Meson did not like that. After a few minutes, I gave up and cheated:

```bash
(meson) mario@bobthebuilder ~/meson/src $ cat meson.build 
project('matasano', 'c')
add_global_arguments('-std=gnu11', language : 'c')
executable('s1c1', 's1c1.c')
```

Second, `$CC` wasn't finding my other source files or header files (probably because I didn't tell it about them). After a few trials (and errors), I figured it out:

```bash
(meson) mario@bobthebuilder ~/meson/src $ cat meson.build 
project('matasano', 'c')

add_global_arguments('-std=gnu11', language : 'c')

src = include_directories('.')
executable('s1c1', ['s1c1.c', 'hex.c', 'base64.c'],
	   include_directories : src)
```

Recall that I keep my header files and source files together, under *src/*. That's probably not best practice, but whatever. I had to tell Meson about those header files, by "include"-ing `.` (the *src* directory). Then, I listed all of the *.c* source files as sources of the `s1c1` executable. Now, my project compiles:

```bash
(meson) mario@bobthebuilder ~/meson/src/build $ ninja
[0/1] Regenerating build files
The Meson build system
Version: 0.31.0
Source dir: /home/mario/meson/src
Build dir: /home/mario/meson/src/build
Build type: native build
Build machine cpu family: x86_64
Build machine cpu: x86_64
Project name: matasano
Native c compiler: cc (gcc 4.8.4-2ubuntu1)
Build targets in project: 1
[2/4] Compiling c object 's1c1@exe/hex.c.o'
../hex.c: In function ‘hexord’:
../hex.c:27:3: warning: array subscript has type ‘char’ [-Wchar-subscripts]
   return lookup[c];
   ^
[3/4] Compiling c object 's1c1@exe/base64.c.o'
../base64.c: In function ‘base64ord’:
../base64.c:21:3: warning: array subscript has type ‘char’ [-Wchar-subscripts]
   return lookup[c];
   ^
[4/4] Linking target s1c1
```

SUCCESS!

Conclusion
----------

All in all, it wasn't a bad experience. I've had far worse compiling C before, as--I'm sure--many have. And, truthfully, it was *far* simpler than first learning GNU Autotools (trying to figure out how `autoheader` and `autoscan` and `autoconf` work together, or *whether* they all work together). I would have run into one less problem had Ninja been up-to-date on the Debian/Ubuntu repositories, but that wasn't a major problem, nor the fault of the good people behind Meson + Ninja, as far as I could tell.

This is my first (of many) blog posts. If you've got questions, comments, or constructive criticisms, leave them in the comments or contact me.

### Update

Per Jussi's comment, I was able to remove the call to `add_global_arguments()` by changing my project definition to `project('matasano', 'c', default_options : ['c_std=gnu11'])`. I was also able to remove the call to `include_directories('.')`, since the current working directory is already added to the Include path. Thanks, Jussi!
