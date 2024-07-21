---
title: plexlint
subtitle: A command-line tool for linting Plex libraries.
date: 2022-11-05T09:45:19-05:00
draft: false
---

plexlint is a command-line tool for scanning Plex library directories for potential problems. plexlint tries to identify files and directories that do not conform to Plex’s recommended layout and naming conventions.

It couldn't be easier to use plexlint! Once compiled, simply supply one or more movie-library root directories with the `-m` flag.

```shell
$ plexlint -m /path/to/movies
PL001  /path/to/movies/my_empty_folder
PL002  /path/to/movies/movie.mkv
```

The output is be a tab-separated value of two "columns": the first contains the check ID&mdash;it's meaning can be referenced at the [homepage](https://mario-campos.github.io/software/plexlint/). The second column contains the problematic movie file/folder to which the check is referring.

## USAGE

```
plexlint -m|--movies PATH
plexlint -v|--version
plexlint -h|--help
```

## FLAGS

`-m`, `--movies`
* Specify a path to a movie library root directory. More than one of these flags can be passed.

`-V`, `--version`
* Output the version number.

`-h`, `--help`
* Output the usage and flags.

## BUILD

plexlint is written in the D programming language, which means you need [dub](https://dub.pm/) to compile plexlint:

```
dub build
```

## SUPPORTED OPERATING SYSTEMS

* Linux
* FreeBSD

## CAVEATS

Currently, plexlint is limited to linting movies, but the goal is to eventually be able to lint TV shows and music as well.

## PLEXLINT CHECKS

### PL001

PL001 checks for empty movie directories.

Empty movie directories serve no purpose to Plex. Additionally, they may incur performance delays as the empty directories must be parsed and processed by Plex.

Empty movie directories may also create the illusion of a legitimate movie in Plex, by confusingly showing a movie entry in the library without any playable files.

### PL002

PL002 checks for movie files in the library root directory.

Plex recommends organizing movies into their own individual directories under the library root. To quote,

>Movie files can be placed into individual folders and this is the recommended method, as it can (sometimes significantly) increase the speed of scanning in new media. This method is also useful in cases where you have external media for a movie (e.g. custom poster, external subtitle files, etc.).

For more information, see https://support.plex.tv/articles/naming-and-organizing-your-movie-media-files/.

### PL003

PL003 checks for movie files/directories with insufficient permission.

Movie files that are not readable by the Plex media server process cannot be imported into the library. Likewise, directories that are not readable and executable can not be scanned by Plex.

### PL004

PL004 checks for movie file names that do not match their parent directory names.

Since Plex recommends storing movies in their own directories, a movie file name should match the parent directory name. To quote,

>Name the folder the same as the movie file:
>
>    /Movies/MovieName (release year)/MovieName (release year).ext


For more information, see https://support.plex.tv/articles/naming-and-organizing-your-movie-media-files/.