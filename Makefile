#
# Makefile for todo.txt
#

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
	cp -rf README $(DISTNAME)/
	cp -rf $(DISTFILES) $(DISTNAME)/
	cp -rf $(READMEFILES) $(DISTNAME)/docs
	tar cf $(DISTNAME).tar $(DISTNAME)/
	gzip -f -9 $(DISTNAME).tar
	zip -9r $(DISTNAME).zip $(DISTNAME)/
	rm -r $(DISTNAME) VERSION-FILE

.PHONY: clean
clean:
	rm -f $(DISTNAME).tar.gz $(DISTNAME).zip VERSION-FILE

