SHELL=/bin/bash


tests:=$(shell find ./test -iname "*_test.cr")
.PHONY: test
test:
	crystal run ${tests}
