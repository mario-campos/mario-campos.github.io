SBLG	 = sblg
LOWDOWN  = lowdown
ARTICLES = docs/meson-first-impressions.md \
	   docs/prefer-data-constructors.md \
	   docs/shitty-software.md \
	   docs/dyndnsds-ast.md \
	   docs/more-unix-tools-hints.md \
	   docs/my-password-generator.md

ARTICLES_XML = ${ARTICLES:S/md$/xml/}
ARTICLES_HTML = ${ARTICLES:S/md$/html/}

.SUFFIXES: .md .xml
.md.xml:
	LOWDOWN=$(LOWDOWN) sh templates/article.xml.sh $< >$@

.SUFFIXES: .xml .html
.xml.html:
	$(SBLG) -t templates/page.xml -c $<

all: $(ARTICLES_HTML)
	$(SBLG) -o docs/index.html -t templates/index.xml $(ARTICLES_XML)
	$(SBLG) -a -o docs/atom.xml -t templates/atom.xml $(ARTICLES_XML)

clean:
	rm -f docs/index.html docs/atom.xml $(ARTICLES_XML) $(ARTICLES_HTML)
