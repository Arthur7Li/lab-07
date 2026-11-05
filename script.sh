#!/usr/bin/env bash

for i in {1..4}; do
	src_dir="Testcase${i}"
	diff_dir="${src_dir}Diff"

	[ -d "$src_dir" ] || continue

	rm -rf "$diff_dir"

	for file1 in "$src_dir"/*.1.txt; do
		[ -f "$file1" ] || continue

		file2="${file1%.1.txt}.2.txt"
		[ -f "$file2" ] || continue

		stem=$(basename "$file1" .1.txt)
		diff_file="${diff_dir}/${stem}Diff.txt"

		diff_output=$(diff -u "$file1" "$file2")
		if [ $? -ne 0 ]; then
			mkdir -p "$diff_dir"
			echo "$diff_output" > "$diff_file"
		fi
	done
done
