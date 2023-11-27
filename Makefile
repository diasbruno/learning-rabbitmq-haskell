TARGET?=all

PROGRAMS=producer consumer sdk

.DEFAULT_GOAL:=all

_build:
	cabal v2-build $(TARGET)

_run:
	cabal v2-run $(TARGET)

_repl:
	cabal v2-repl $(TARGET)

define program_rules
build_$(1):
	TARGET=$(1) make -k _build

run_$(1):
	TARGET=$(1) make -k _run

repl_$(1):
	TARGET=$(1) make -k _repl

.PHONY: build_$(1) run_$(1) repl_$(1)
endef

.PHONY: all
all:
	TARGET=all make -k _build

$(foreach P,$(PROGRAMS),$(eval $(call program_rules,$(P))))
