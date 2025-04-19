#!/usr/bin/env sh

# Usage:
#   cram [OPTIONS] <test-file>
#
# Options:
#   -h --help      Show this help message and exit
#
# Arguments:
#   <test-file>: the test file

usage() {
	script_name=$(basename "$0")
	echo "Usage:"
	echo "  $script_name -h | --help"
	echo ""
	echo "Options:"
	echo "  -h --help      Show this help message and exit."
	echo ""
	echo "Arguments:"
	echo "  <test-file>: the test file"
}

compare_outputs() {
	expected="$1"
	actual="$2"

	if [ "$expected" != "$actual" ]; then
		printf "Error: Output differs from expected\n" >&2
		tmp_expected=$(mktemp)
		tmp_actual=$(mktemp)

		echo "$expected" >"$tmp_expected"
		echo "$actual" >"$tmp_actual"
		diff -u "$tmp_expected" "$tmp_actual"
		rm -f "$tmp_expected" "$tmp_actual"
		exit 1
	fi
}

while getopts ":h-" opt; do
	case "$opt" in
	h)
		usage
		exit 0
		;;
	-)
		case "$OPTARG" in
		help)
			usage
			exit 0
			;;
		*)
			echo "Error: Unknown option: --$OPTARG" >&2
			exit 1
			;;
		esac
		;;
	\?)
		echo "Error: Invalid option: -$OPTARG" >&2
		exit 1
		;;
	esac
done

shift "$((OPTIND - 1))"

if [ -z "$1" ]; then
	echo "Test file not provided" >&2
	usage
	exit 1
fi

cmd_build=''
while IFS= read -r line; do

	if echo "$line" | grep -E '^  \$' >/dev/null; then

		if [ -n "$cmd_build" ]; then
			output=$(eval "$cmd")
		fi

		if [ -n "$expected_output" ]; then
			compare_outputs "$expected_output" "$output"
		fi
		cmd_build=1
		expected_output=''
		cmd="${line#  $ }"

	elif echo "$line" | grep -E '^  >' >/dev/null; then

		cmd="$cmd ${line#  > }"

	elif echo "$line" | grep -E '^  ' >/dev/null; then

		if [ -n "$cmd_build" ]; then
			output=$(eval "$cmd")
		fi

		cmd_build=''
		if [ -z "$expected_output" ]; then
			expected_output="${line#  }"
		else
			expected_output="$expected_output ${line#  }"
		fi

	else

		if [ -n "$cmd_build" ]; then
			output=$(eval "$cmd")
		fi

		if [ -n "$expected_output" ]; then
			compare_outputs "$expected_output" "$output"
		fi

		cmd_build=''
		expected_output=''

	fi

done <"$1"

if [ -n "$cmd_build" ]; then
	output=$(eval "$cmd")
fi

if [ -n "$expected_output" ]; then
	compare_outputs "$expected_output" "$output"
fi
