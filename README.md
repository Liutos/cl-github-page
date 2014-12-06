# Akashic - Static Blog Generator

## Introduction

Akashic is a tool for generating the static blog based on GitHub Pages, written in Common Lisp.

Its original name is cl-github-page.

At the beginning, it was developed for simplifying the management of my blog built on the GitHub Pages. It just handles the generation of posts(.html files) and the update of the index.html file. The user can classify the posts into different categories and categories can be nesting. The categories is implemented by directories.

## Features

* Classify posts by categories
* Atom file generation

## Installation And Usage

In REPL, run the commands:

```lisp
(push "/path/to/cl-github-page/directory/" asdf:\*central-registry\*)
(asdf:load-system 'cl-github-page)
```

After loading the ASDF system, you can run the CL-GITHUB-PAGE:MAIN function for generating a static blog. There must be a directory for storing the directories and files of the blog, the default is directory `src/blog/' at your home directory.

Please ensure the blog directory contains the following sub-directories and files:

* src/ -- For storing the Markdown source text files.
* posts/ -- For storing the HTML files generated from corresponding Markdown files with same file name.
* friends.lisp -- Contains the pairs of URLs and website names.

Write a new article in src/ directory, for example, with name foobar.text, whose suffix must be `.text'. Invoke the function `CL-GITHUB-PAGE:MAIN', then a new HTML file named `foobar.html' would be generated and placed in directory posts/default. Now, just add, commit and push the reposity to GitHub.

## Author

Liutos(<mat.liutos@gmail.com>)

## TODOs

* <del>convenience for debugging</del>
* use array for storing posts instead of list
* use 3rd-party library for generating RSS and Atom
* <del>remove the categories bar in post page</del>
