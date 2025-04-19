test:
	./cram.sh test.t

shellcheck:
	shellcheck cram.sh

fmt:
	shfmt -w cram.sh

.PHONY: test shellcheck fmt
