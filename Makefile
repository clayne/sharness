prefix = $(HOME)

INSTALL_DIR = $(prefix)/share/sharness
LIB_DIR=$(INSTALL_DIR)/lib-sharness
DOC_DIR = $(prefix)/share/doc/sharness
EXAMPLE_DIR = $(DOC_DIR)/examples
VIM_DIR = $(prefix)/.vim/pack/filetypes/start/sharness

INSTALL_FILES = sharness.sh
LIB_FILES = aggregate-results.sh lib-sharness/functions.sh
DOC_FILES = API.md CHANGELOG.md COPYING README.git README.md
EXAMPLE_FILES = test/Makefile test/simple.t

INSTALL = install
RM = rm -f
SED = sed
TOMDOCSH = tomdoc.sh
CP = cp

all:

install: all
	$(INSTALL) -d -m 755 $(INSTALL_DIR) $(LIB_DIR) $(DOC_DIR) $(EXAMPLE_DIR)
	$(INSTALL) -m 644 $(INSTALL_FILES) $(INSTALL_DIR)
	$(INSTALL) -m 644 $(LIB_FILES) $(LIB_DIR)
	$(INSTALL) -m 644 $(DOC_FILES) $(DOC_DIR)
	$(SED) -e "s!aggregate-results.sh!$(LIB_DIR)/aggregate-results.sh!" test/Makefile > $(EXAMPLE_DIR)/Makefile
	$(SED) -e "s!SHARNESS_TEST_SRCDIR:=.!SHARNESS_TEST_SRCDIR:=$(INSTALL_DIR)!" test/simple.t > $(EXAMPLE_DIR)/simple.t

install-vim:
	$(INSTALL) -d -m 755 $(VIM_DIR)
	$(CP) -r vim/* $(VIM_DIR)

uninstall:
	$(RM) -r $(INSTALL_DIR) $(LIB_DIR) $(DOC_DIR) $(EXAMPLE_DIR)

doc: all
	{ printf "# Sharness API\n\n"; \
	  $(TOMDOCSH) -m -a Public $(INSTALL_FILES) $(LIB_FILES); \
	  printf "Generated by "; $(TOMDOCSH) --version; } >API.md

lint:
	shellcheck -s sh $(INSTALL_FILES) $(LIB_FILES)

test: all
	$(MAKE) -C test

.PHONY: all install uninstall doc lint test
