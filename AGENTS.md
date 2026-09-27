# Agent notes

TD material (exercise sheets and detailed corrections) for the M1 course
4MA305 — *Bases d'analyse fonctionnelle*, academic year 2026–2027.
Human-facing setup instructions: `README.md`.

## Build

Container-based TeX Live (no host LaTeX install), wrapped in a justfile:

```bash
just td <n>        # compile every .tex in TD<n>/ (or: just td TD<n>)
just all           # compile every TD
just clean         # remove aux files, keep PDFs
just image-build   # rebuild the container image (only if Dockerfile changed)
just machine       # macOS only: start the podman VM before building
```

Under the hood this is `podman run --rm -v "$PWD":/workdir[:Z] m1-305-latex
latexmk -pdf -cd TD<n>/*.tex`. Documents are compiled with **pdfLaTeX**
(`inputenc`/`T1` preambles), not LuaLaTeX. Set `CONTAINER_ENGINE=docker` to
drive the same recipes through docker.

After compiling, check the `.log` for errors, overfull/underfull boxes and
undefined references, then run `just clean` so only `.tex` and `.pdf` remain.

## Layout

- `TD<n>/` — one folder per TD. Each `.tex` is a standalone document with its
  own preamble (no shared files); names like `corrige_TD<n>.tex`.
- PDFs are git-ignored (rebuild with `just td <n>`); never commit them.

## Conventions

- Language: French. Follow the existing style of a file when editing it.
- Notation follows the course *polycopié*: `B(a,r)` open ball, `\Bf(a,r)`
  closed ball, `\interieur{A}` / `\adh{A}` interior / closure, `\partial A`
  boundary, sequential compactness as the definition of compactness. Cite
  the polycopié's numbering (e.g. « Définition 1.20 ») when relevant.
- Corrections use the tcolorbox environments defined in the preamble:
  `exo` (statement), `solution`, `pointcle`, `piege`, `commentaire`,
  `methode`. Reuse the preamble of an existing correction when starting a
  new TD.
