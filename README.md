# `Terminal_size`

[![Build Status][build_status_badge]][build_status_link]
[![Documentation][doc_badge]][doc_link]

## What is it?

You can use this small ocaml library to detect the dimensions of the terminal
window attached to a process. It contains the two following functions:

```ocaml
val get_rows : unit -> int option
val get_columns : unit -> int option
```

## How does it work?

Usually, to get this information, one would open a pipe from `tput cols` or
`stty size` and parsing the output. Instead, this uses the `ioctl` that these
commands use, `TIOCGWINSZ`.

[build_status_badge]: https://github.com/cryptosense/terminal_size/actions/workflows/main.yml/badge.svg
[build_status_link]: https://github.com/cryptosense/terminal_size/actions/workflows/main.yml
[doc_badge]: https://img.shields.io/badge/doc-online-blue.svg
[doc_link]: https://cryptosense.github.io/terminal_size/doc/
