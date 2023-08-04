all: build_docs

build_docs:
	@rm spec/apollo.pdf -f
	@typst compile spec/src/main.typ spec/apollo.pdf