# Author: Carsten Gips <carsten.gips@fh-bielefeld.de>
# Copyright: (c) 2016-2018 Carsten Gips
# License: MIT



## Path to this repository (to be used as git sub-module)

PWD          = $(shell pwd)
DATADIR     ?= ..
FILTERDIR    = $(DATADIR)/filters
RESOURCEDIR  = $(DATADIR)/resources
RESOURCEPATH = .:./figs:$(DATADIR)

PANDOC      ?= docker run --rm -v $(PWD):/pandoc -v $(PWD)/$(FILTERDIR):/filters -v $(PWD)/$(RESOURCEDIR):/resources debian-texlive pandoc



## Source files and lecture prefix

SRC   ?= $(wildcard a*.md)
ID    ?= pm

PDF    = ${ID}_exam.pdf ${ID}_solution.pdf
TMP1   = __header.filled.tex
TMP2   = __titlepage.filled.tex



## Exam options

PDFOPTIONS  = -f markdown
PDFOPTIONS += --pdf-engine=pdflatex
PDFOPTIONS += --default-image-extension=pdf
PDFOPTIONS += -V documentclass=exam
PDFOPTIONS += -V classoption=addpoints
PDFOPTIONS += -V fontsize=11pt -V papersize=a4
PDFOPTIONS += -V geometry:left=2cm -V geometry:right=2cm -V geometry:top=2cm -V geometry:bottom=2.5cm
# --toc: to compile twice
PDFOPTIONS += --number-sections --toc
PDFOPTIONS += --listings --highlight-style=tango
PDFOPTIONS += --lua-filter=${FILTERDIR}/tex.lua
PDFOPTIONS += --lua-filter=${FILTERDIR}/exams.lua
PDFOPTIONS += --include-in-header=${RESOURCEDIR}/definitions.tex
PDFOPTIONS += --include-in-header=${RESOURCEDIR}/definitions_obsolete.tex
PDFOPTIONS += --include-after-body=${RESOURCEDIR}/exam_end.tex
PDFOPTIONS += --data-dir=${DATADIR}
PDFOPTIONS += --resource-path=${RESOURCEPATH}



## Targets

all:	$(PDF)

${ID}_solution.pdf: PDFOPTIONS += -V classoption=answers
${ID}_exam.pdf ${ID}_solution.pdf: metadata.yaml $(SRC)
	$(PANDOC) --template=${RESOURCEDIR}/exam.tex -o ${TMP1} $<
	$(PANDOC) --template=${RESOURCEDIR}/exam_begin.tex -o ${TMP2} $<
	$(PANDOC) ${PDFOPTIONS} --include-in-header=${TMP1} --include-before-body=${TMP2} -o $@ $^
	rm -f ${TMP1} ${TMP2}


clean:
	rm -f $(PDF) ${TMP1} ${TMP2}


.PHONY: all clean




