APP_NAME=core
PACKAGE=acf-$(APP_NAME)
VERSION=2.0_alpha1

P=$(PACKAGE)-$(VERSION)
DISTDIR:=$(PWD)/$(P)
DISTPKG=$(P).tar.bz2

SUBDIRS=app lib www
EXTRA_DIST=ChangeLog Makefile README TODO

DISTFILES=$(EXTRA_DIST)

CP=cp
TAR=tar

RECURSIVE_TARGETS=all-recursive install-recursive distdir-recursive \
	clean-recursive
phony+=$(RECURSIVE_TARGETS)

export DISTDIR DESTDIR
$(RECURSIVE_TARGETS):
	target=`echo $@ | sed 's/-recursive//'`;\
	for dir in $(SUBDIRS); do\
		( cd $$dir && $(MAKE) $$target ) || exit 1;\
	done

phony += all
all:	all-recursive

phony += clean
clean:	clean-recursive
	rm -rf $(DISTDIR) $(DISTPKG)

phony += distdir
distdir: distdir-recursive $(DISTFILES)
	for i in $(DISTFILES) ; do\
		dest="$(DISTDIR)/$$i";\
		mkdir -p `dirname $$dest` &&\
		$(CP) "$$i" "$$dest" || exit 1;\
	done

phony += dist
dist: 	$(DISTPKG)

$(DISTPKG): distdir $(DISTFILES)
	$(TAR) -chjf $@ $(P)
	rm -r $(DISTDIR)

phony+=install
install: install-recursive

.PHONY: $(phony)
