# Full TeX Live (all packages, latexmk, etc.) maintained by the Island of TeX
FROM registry.gitlab.com/islandoftex/images/texlive:latest

WORKDIR /workdir

# Default: compile every TD with latexmk via pdfLaTeX
# (-cd: resolve paths relative to each TD folder)
CMD ["sh", "-c", "latexmk -pdf -cd -interaction=nonstopmode TD*/*.tex"]
