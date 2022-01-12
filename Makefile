#
# Makefile for todo.txt Actions
#

SHELL = /bin/sh

INSTALL = /usr/bin/install
INSTALL_PROGRAM = $(INSTALL)
INSTALL_DATA = $(INSTALL) -m 644

# Dynamically detect/generate version file as necessary
# This file will define a variable called VERSION.
.PHONY: .FORCE-VERSION-FILE
VERSION-FILE: .FORCE-VERSION-FILE
	@./GEN-VERSION-FILE
-include VERSION-FILE

# For packaging
DISTFILES := actions
READMEFILES := README.*

DISTNAME=todo.txt_plugins-$(VERSION)
dist: $(DISTFILES) 
	mkdir -p $(DISTNAME)/docs/
	cp -rf $(DISTFILES) $(DISTNAME)/
	cp -rf $(READMEFILES) $(DISTNAME)/docs
	tar cf $(DISTNAME).tar $(DISTNAME)/
	gzip -f -9 $(DISTNAME).tar
	zip -9r $(DISTNAME).zip $(DISTNAME)/
	rm -r $(DISTNAME) VERSION-FILE

.PHONY: clean
clean:
	rm -f $(DISTNAME).tar.gz $(DISTNAME).zip VERSION-FILE

# Testing
#
TESTS = $(wildcard tests/t[0-9][0-9][0-9][0-9]-*.sh)
#TEST_OPTIONS=--verbose

test-pre-clean:
	rm -rf tests/test-results "tests/trash directory"*

aggregate-results: $(TESTS)

$(TESTS): test-pre-clean
	cd tests && ./$(notdir $@) $(TEST_OPTIONS)

test: aggregate-results
	tests/aggregate-results.sh tests/test-results/t*-*
	rm -rf tests/test-results
    
# Force tests to get run every time
.PHONY: test test-pre-clean aggregate-results $(TESTS)

