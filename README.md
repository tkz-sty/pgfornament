# pgfornament – Drawing of Vectorian ornaments with PGF/TikZ

Release 1.1 2020/04/06

## Description

This package allows the drawing of Vectorian ornaments (196) with pgf/tikz.
The documentation presents the syntax and parameters of the macro `pgfornament`.

## News

With this new version comes a new family of ornaments. Chennan Zhang drew
the motifs using a CAD application, re-drew them in TikZ, and granted permission
for these to be turned into a library `pgfornament-han` suitable for use with
the `pgfornament` package by LianTze Lim.

It is now possible to use directly the library for Chinese traditional motifs
and patterns.

## About tikzrput package:

This package contains the `\rput` macro that can be used to place objects. This
macro does similar actions of the `\rput` macro from pstricks. Here this macro
needs tikz to work.

## Licence

The packages may be modified and distributed under the terms and
conditions of the [LaTeX Project Public
License](https://www.latex-project.org/lppl/), version 1.3c or greater.

## Installation

The package `pgfornament` and `tikzrput` are present in `TeXLive` and `MiKTeX`, use the
package manager to install.

You can experiment with the `pgfornament` and `tikzrput` packages by placing all of the
distribution files in the directory containing your current tex file.

For manual instalation all files must be moved into the different directories in your
installation `TDS` tree or in your `TEXMFHOME`:

```
  doc/*.*             -> TDS:doc/latex/pgfornament/*.*
  code/latex/*.*      -> TDS:tex/latex/pgfornament/*.*
  code/generic/*.*    -> TDS:tex/generic/pgfornament/*.*
```

## How to use it

To use the package `pgfornament`, place the following lines in the preamble of
your LaTeX document.

```
\usepackage{pgfornament}
```

## Documentation

Documentations for `pgfornament` and `tikzrput`  are available on CTAN and in your TeX distribution.

## History

- v 1.00 Add the Han ornanments and some new macros. Add some examples to the
 documentation. Thanks to Pablo Gonzáles L to help me with "Git".

- v0.21: `pgfornament.sty`, Christian Feuersänger thank you for seeing this bug
 ornament/at now replaces the key at (conflict with at from pgf).

- v0.21: documentation: Peter Zimmermann thank you for seeing some bugs in the
 examples.

- New section Problem to describe some difficulties.
