# docker-miktex-with-git

![Docker Image Size](https://img.shields.io/docker/image-size/blueberryapple/docker-miktex-with-git/latest)

Docker image with miktex and git so it is the smallest image size possible while still having git and be a drop in image to run on GitHub Actions

## Example usage

```yml
name: Build LaTeX document
on: [push]
jobs:
  build_latex:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/blueberryapple/docker-miktex-with-git:latest
    steps:
      - name: Set up Git repository
        uses: actions/checkout@v4
      - name: Compile LaTeX document
        run: latexmk -pdflatex='xelatex %O %S' -synctex=1 -interaction=nonstopmode -file-line-error -pdf "main.tex"
      - name: Upload PDF file
        uses: actions/upload-artifact@v4
        with:
          name: PDF
          path: "main.pdf"
```
