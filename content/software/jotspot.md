---
title: jotspot
subtitle: A command-line tool for linting media.
date: 2022-11-05T09:45:19-05:00
draft: false
---

jotspot is a command-line tool for scanning Plex library directories for potential problems. jotspot tries to identify files and directories that do not conform to Plex’s recommended layout or naming conventions.

It couldn't be easier to use jotspot! Once compiled, simply supply one or more movie-library root directories with the `-m` flag.

```shell
$ jotspot -m /path/to/movies
JS001  /path/to/movies/my_empty_folder
JS002  /path/to/movies/movie.mkv
```

The output is be a tab-separated value of two "columns": the first contains the check ID&mdash;it's meaning can be referenced at the [homepage](https://mario-campos.github.io/software/jotspot/). The second column contains the problematic movie file/folder to which the check is referring.

## USAGE

```
jotspot -m|--movies PATH
jotspot -v|--version
jotspot -h|--help
```

## FLAGS

`-m`, `--movies`
* Specify a path to a movie library root directory. More than one of these flags can be passed.

`-V`, `--version`
* Output the version number.

`-h`, `--help`
* Output the usage and flags.

## BUILD

jotspot is written in the D programming language, which means you need [dub](https://dub.pm/) to compile jotspot:

```
dub build
```

## SUPPORTED OPERATING SYSTEMS

* Linux
* FreeBSD

## CAVEATS

Currently, jotspot is limited to linting movies, but the goal is to eventually be able to lint TV shows and music as well.

## jotspot CHECKS

### JS001

JS001 checks for empty movie directories.

Empty movie directories serve no purpose to Plex. Additionally, they may incur performance delays as the empty directories must be parsed and processed by Plex.

Empty movie directories may also create the illusion of a legitimate movie in Plex, by confusingly showing a movie entry in the library without any playable files.

### JS002

JS002 checks for movie files in the library root directory.

Plex recommends organizing movies into their own individual directories under the library root. To quote,

>Movie files can be placed into individual folders and this is the recommended method, as it can (sometimes significantly) increase the speed of scanning in new media. This method is also useful in cases where you have external media for a movie (e.g. custom poster, external subtitle files, etc.).

For more information, see https://support.plex.tv/articles/naming-and-organizing-your-movie-media-files/.

### JS003

JS003 checks for movie files/directories with insufficient permission.

Movie files that are not readable by the Plex media server process cannot be imported into the library. Likewise, directories that are not readable and executable can not be scanned by Plex.

### JS004

JS004 checks for movie file names that do not match their parent directory names.

Since Plex recommends storing movies in their own directories, a movie file name should match the parent directory name. To quote,

>Name the folder the same as the movie file:
>
>    /Movies/MovieName (release year)/MovieName (release year).ext


For more information, see https://support.plex.tv/articles/naming-and-organizing-your-movie-media-files/.