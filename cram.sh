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
output_build=''

while IFS= read -r line; do
	if echo "$line" | grep -E '^  \$' >/dev/null; then
		output_build=1
		# Extract the command from the line
		command=$(echo "$line" | sed -E 's/^  \$ //')
		echo "$command"
		# Execute the command and capture the output

	fi
done <"$1"
