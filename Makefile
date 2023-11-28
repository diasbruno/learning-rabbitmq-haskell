TARGET?=all

PROGRAMS=producer consumer sdk

.DEFAULT_GOAL:=all

define program_rules :=
build_$(1):
	cabal v2-build $(1)

run_$(1):
	cabal v2-run $(1)

repl_$(1):
	cabal v2-repl $(1)

.PHONY: build_$(1) run_$(1) repl_$(1)
endef

.PHONY: all
all:
	TARGET=all make -k _build

$(foreach P,$(PROGRAMS),$(eval $(call program_rules,$(P))))
