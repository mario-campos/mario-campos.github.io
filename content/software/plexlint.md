---
title: plexlint
subtitle: A command-line tool for linting Plex libraries.
date: 2022-11-05T09:45:19-05:00
draft: false
---

plexlint is a command-line tool for scanning Plex library directories for potential problems. plexlint tries to identify files and directories that do not conform to Plex's recommended layout and naming conventions.

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

## SUPPORTED OPERATING SYSTEMS

* Linux
* FreeBSD

## CHECKS

### PXLINT001

PXLINT001 checks for the existance of empty directories. Empty directories serve no purpose to Plex and may only create the "illusion" of a legitimate movie in Plex.

### PXLINT002

PXLINT002 checks for the existence of movie files at the root of the library. Plex recommends organizing movies into their own individual directories under the library root.

For more information, see https://support.plex.tv/articles/naming-and-organizing-your-movie-media-files/.

### PXLINT003

PXLINT003 checks for movie files that are not readable by the Plex user.

### PXLINT004

PXLINT004 checks for movie files whose metadata does not match its directory.
