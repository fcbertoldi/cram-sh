test:
	./cram.sh tests/test.t

shellcheck:
	shellcheck cram.sh

fmt:
	shfmt -w cram.sh

.PHONY: test shellcheck fmt
