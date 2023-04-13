#!/bin/bash -e
_subscripts=(toolchain
             tools)
for _subscript in "${_subscripts[@]}"; do
	./build/$_subscript.sh
done
