include ../config.mk

LIB_DIST=menubuilder.lua\
	session.lua\
	authenticator.lua\
	authenticator-plaintext.lua\
	roles.lua\
	htmlviewfunctions.lua\
	modelfunctions.lua\

EXTRA_DIST=README Makefile
DISTFILES=$(LIB_DIST) $(EXTRA_DIST)

install_dir=$(DESTDIR)/$(acflibdir)
dist_dir=$(DISTDIR)/$(notdir $(PWD))

phony+=all
all:

phony+=clean
clean:

phony+=distdir
distdir: $(DISTFILES)
	mkdir -p "$(dist_dir)"
	for i in $(DISTFILES); do\
		dest=`dirname "$(dist_dir)/$$i"`;\
		mkdir -p "$$dest";\
		cp "$$i" "$$dest";\
	done

phony+=install
install:
	mkdir -p $(install_dir)
	for i in $(LIB_DIST); do\
		dest=`dirname "$(install_dir)/$$i"`;\
		mkdir -p "$$dest";\
		cp "$$i" "$$dest";\
	done


.PHONY: $(phony)
