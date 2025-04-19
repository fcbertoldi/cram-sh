test:
	./cram.sh test.t

shellcheck:
	shellcheck cram.sh

.PHONY: test shellcheck
