# Akashic - Static Blog Generator

## Introduction

Akashic is a tool for generating the static blog based on GitHub Pages, written in Common Lisp.

Its original name is cl-github-page.

At the beginning, it was developed for simplifying the management of my blog built on the GitHub Pages. It just handles the generation of posts(.html files) and the update of the index.html file. The user can classify the posts into different categories and categories can be nesting. The categories is implemented by directories.

## Features

* Classify posts by categories
* Atom file generation

## Author

Liutos(<mat.liutos@gmail.com>)

## TODOs

* <del>convenience for debugging</del>
* use array for storing posts instead of list
* use 3rd-party library for generating RSS and Atom
