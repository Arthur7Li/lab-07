#!/usr/bin/env bash

overall_status=0

for i in {1..4}; do
    src_dir="Testcase${i}"
    diff_dir="${src_dir}Diff"
    tc_passed=true
    any_diff=false

    for file1 in "$src_dir"/*.1.txt; do
        [ -f "$file1" ] || continue

        file2="${file1%.1.txt}.2.txt"
        [ -f "$file2" ] || continue

        stem=$(basename "$file1" .1.txt)
        diff_file="${diff_dir}/${stem}Diff.txt"

        if ! cmp -s "$file1" "$file2"; then
            any_diff=true

            if [ ! -f "$diff_file" ]; then
                echo "Missing expected file: $diff_file" >&2
                tc_passed=false
            else
                expected_diff=$(diff -u "$file1" "$file2" | tail -n +3)
                found_diff=$(tail -n +3 "$diff_file")

                if [ "$expected_diff" != "$found_diff" ]; then
                    echo "Content mismatch in: $diff_file" >&2
                    tc_passed=false
                fi
            fi
        else

            if [ -f "$diff_file" ]; then
                echo "Unexpected diff file exists: $diff_file" >&2
                tc_passed=false
            fi
        fi
    done

    if [ "$any_diff" = true ]; then
        if [ ! -d "$diff_dir" ]; then
            echo "Directory $diff_dir should exist but does not" >&2
            tc_passed=false
        fi
    else
        if [ -d "$diff_dir" ]; then
            echo "Directory $diff_dir should not exist but does" >&2
            tc_passed=false
        fi
    fi

    if [ "$tc_passed" = true ]; then
        echo "Testcase${i}: PASS"
    else
        echo "Testcase${i}: FAIL"
        overall_status=1
    fi
done

exit "$overall_status"
        
      
