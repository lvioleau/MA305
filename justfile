image := env("LATEX_IMAGE", "m1-305-latex")
# podman by default; set CONTAINER_ENGINE=docker to build through docker/colima
engine := env("CONTAINER_ENGINE", "podman")
# SELinux relabelling: needed on Linux hosts, unsupported by the macOS VM mounts
mount := if os() == "linux" { ":Z" } else { "" }
run := engine + " run --rm -v \"$PWD\":/workdir" + mount
latexmk := "latexmk -pdf -cd -interaction=nonstopmode"

# list recipes
default:
    @just --list

# compile every .tex of a TD folder: just td 1  (or: just td TD1)
td n:
    {{run}} {{image}} {{latexmk}} {{ if n =~ '^[0-9]+$' { "TD" + n } else { n } }}/*.tex
    @just pdfs

# refresh pdf/: one symlink per compiled PDF, for browsing them in one place
pdfs:
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p pdf
    find pdf -type l -delete
    for f in TD*/*.tex; do
        [ -f "${f%.tex}.pdf" ] && ln -s "../${f%.tex}.pdf" pdf/
    done
    ls pdf

# compile every TD folder
all:
    for d in TD*/; do just td "$d"; done

# compile a TD and open its PDFs in the default viewer
[macos]
view n: (td n)
    for f in {{ if n =~ '^[0-9]+$' { "TD" + n } else { n } }}/*.tex; do open "${f%.tex}.pdf"; done

# compile a TD and open its PDFs in Okular
[linux]
view n: (td n)
    for f in {{ if n =~ '^[0-9]+$' { "TD" + n } else { n } }}/*.tex; do setsid -f flatpak run org.kde.okular "${f%.tex}.pdf" >/dev/null 2>&1; done

# recompile a TD on every change (Ctrl-C to stop)
watch n:
    {{run}} -it {{image}} {{latexmk}} -pvc {{ if n =~ '^[0-9]+$' { "TD" + n } else { n } }}/*.tex

# remove aux files of every TD, keep PDFs
clean:
    {{run}} {{image}} sh -c 'for f in TD*/*.tex; do latexmk -cd -c "$f"; done'

# remove aux files and generated PDFs of every TD
distclean:
    {{run}} {{image}} sh -c 'for f in TD*/*.tex; do latexmk -cd -C "$f"; done'
    @just pdfs

# interactive shell inside the TeX Live container
shell:
    {{run}} -it {{image}} bash

# (re)build the container image
image-build:
    {{engine}} build -t {{image}} .

# start the podman VM (created on first run) — macOS needs it before any build
[macos]
machine:
    #!/usr/bin/env bash
    set -euo pipefail
    if podman info >/dev/null 2>&1; then
        echo "podman VM already running"
        exit 0
    fi
    podman machine inspect >/dev/null 2>&1 || podman machine init --cpus 4 --memory 4096 --disk-size 60
    podman machine start
