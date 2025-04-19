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

shift "$((OPTIND-1))"


if [ -z "$1" ]; then
  echo "Test file not provided" >&2
  usage
  exit 1
fi

while IFS= read -r line; do
  echo "Line: $line"
done < "$1"