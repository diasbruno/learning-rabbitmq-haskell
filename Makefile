TARGET?=all

.DEFAULT_GOAL:=all

_build:
	cabal v2-build $(TARGET)

.PHONY=build_sdk
build_sdk:
	TARGET=sdk make -k _build

.PHONY=build_consumer
build_consumer:
	TARGET=consumer make -k _build

.PHONY=build_producer
build_producer:
	TARGET=producer-t make -k _build

.PHONY=all
all:
	TARGET=all make -k _build
