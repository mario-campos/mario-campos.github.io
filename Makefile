SBLG	 = sblg
LOWDOWN  = lowdown
ARTICLES = docs/meson-first-impressions.md \
	   docs/prefer-data-constructors.md \
	   docs/shitty-software.md \
	   docs/dyndnsds-ast.md \
	   docs/more-unix-tools-hints.md \
	   docs/my-password-generator.md

ARTICLES_HTML = ${ARTICLES:S/md$/html/}

.SUFFIXES: .md .xml
.md.xml:
	LOWDOWN=$(LOWDOWN) sh article.xml.sh $< >$@

.SUFFIXES: .xml .html
.xml.html:
	$(SBLG) -t page.xml -c $<

all: $(ARTICLES_HTML)
	cd docs && $(SBLG) -o index.html -t ../index.xml *.html

clean:
	rm -f docs/index.html $(ARTICLES_HTML) ${ARTICLES:S/md$/xml/}
