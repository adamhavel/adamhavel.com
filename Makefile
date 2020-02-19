.PHONY: develop build clean clean-build

build: static/lib clean-build
	hugo

develop: static/lib clean-build
	hugo server

static/lib: node_modules
	mkdir static/lib
	cp -R node_modules/reveal.js static/lib/reveal.js

node_modules:
	npm install

clean-build:
	rm -rf public

clean: clean-build
	rm -rf node_modules
	rm -rf static/lib
	rm -f package-lock.json
