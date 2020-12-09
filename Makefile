SBLG	 = sblg
LOWDOWN  = lowdown
ARTICLES = docs/blog/meson-first-impressions.md \
	   docs/blog/prefer-data-constructors.md \
	   docs/blog/shitty-software.md \
	   docs/blog/dyndnsds-ast.md \
	   docs/blog/more-unix-tools-hints.md \
	   docs/blog/my-password-generator.md

ARTICLES_HTML = ${ARTICLES:S/md$/html/}

.SUFFIXES: .md .xml
.md.xml: article.xml.sh
	LOWDOWN=$(LOWDOWN) sh article.xml.sh $< >$@

.SUFFIXES: .xml .html
.xml.html: page.xml
	$(SBLG) -t page.xml -c $<

all: $(ARTICLES_HTML)
	cd docs && $(SBLG) -o index.html -t ../index.xml blog/*.html

clean:
	rm -f docs/index.html $(ARTICLES_HTML) ${ARTICLES:S/md$/xml/}
