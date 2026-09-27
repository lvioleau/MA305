# 4MA305 — Bases d'analyse fonctionnelle

TD (travaux dirigés) material for the M1 course, written in LaTeX and compiled
in a container (full TeX Live). Academic year 2026–2027.

## Layout

```
TD1/, TD2/, …   — one folder per TD: subject and/or correction (.tex)
Dockerfile      — TeX Live build environment
justfile        — build recipes
```

Every `.tex` file in a `TD*/` folder is a standalone document; there is no
shared preamble, and files don't need to be called `main.tex`.

## Building

Compilation runs inside a TeX Live container (pdfLaTeX + latexmk), driven by
[just](https://just.systems):

```bash
just image-build  # build the container image (once)
just td 1         # compile every .tex in TD1/ (also: just td TD1)
just watch 1      # recompile TD1 on every change (Ctrl-C to stop)
just view 1       # compile TD1, then open its PDFs
just all          # compile every TD
just clean        # remove aux files, keep PDFs
just distclean    # remove aux files and generated PDFs
just              # list all recipes
```

On macOS: `brew install just podman`.

### macOS: the podman VM

Containers on macOS run inside a Linux VM, so it has to be up before any
build:

```bash
just machine           # create it on first run, start it afterwards
podman machine stop    # when you're done
```

The `:Z` SELinux relabel flag is Linux-only and is added automatically; the
folder must live under `$HOME` (that is what the podman VM mounts). To use
docker instead, set `CONTAINER_ENGINE=docker`.
