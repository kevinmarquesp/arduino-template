SKETCH := sketch
VENDOR := vendor
DOCS := docs
BIN := bin

VENDOR_IGNORE := doxygen googletest
VENDOR_FLAGS := $(patsubst %, --library %, $(filter-out $(patsubst %, $(VENDOR)/%, \
	$(VENDOR_IGNORE)), $(wildcard $(VENDOR)/*)))

ACC := arduino-cli
ACC_FLAGS := $(VENDOR_FLAGS)

PORT := /dev/ttyUSB0
CORE := arduino:avr
BOARD := arduino:avr:uno
BAUD := 115200

DOXYGEN_VENDOR := $(VENDOR)/doxygen
DXG := $(DOXYGEN_VENDOR)/build/bin/doxygen

GOOGLETEST_VENDOR := $(VENDOR)/googletest

.PHONY: default
default:
	@echo $(ACC_FLAGS)

.PHONY: compile
compile: $(SKETCH)
	$(ACC) compile --verbose $(ACC_FLAGS) --port $(PORT) --fqbn $(BOARD) $^

.PHONY: upload
upload: $(SKETCH)
	$(ACC) compile --verbose $(ACC_FLAGS) --port $(PORT) --fqbn $(BOARD) --upload $^

.PHONY: monitor
monitor:
	$(ACC) monitor --port $(PORT) --config "baudrate=$(BAUD)" --timestamp

.PHONY: deps deps/doxygen deps/googletest
deps:
	@git clone git@github.com:doxygen/doxygen   $(VENDOR)/doxygen    || printf "" 
	@git clone git@github.com:google/googletest $(VENDOR)/googletest || printf "" 
	make deps/doxygen deps/googletest

deps/doxygen:
	mkdir -vp $(DOXYGEN_VENDOR)/build || printf ""
	cd $(DOXYGEN_VENDOR)/build && cmake .. && make

deps/googletest:
	mkdir -vp $(GOOGLETEST_VENDOR)/build || printf ""
	cd $(GOOGLETEST_VENDOR)/build; cmake ..; make

.PHONY: docs
docs:
	./$(DXG) Doxyfile

.PHONY: clean
clean:
	rm -rf $(VENDOR)
	rm -rf $(DOCS)
	rm -rf $(BIN)
