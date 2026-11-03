# ILC 7

For today's ILC, we are working with bash and the `diff` command. 

## The `diff` Command
The `diff` command is used to compare the content of two files. When working on labs, you will be given text files containing expected output. Using the `diff` command is how you will determine whether your program produces the correct output or not. This is done by comparing your output with the given expected output. 
The purpose of this ILC is for you to get familiar with reading the output produced by `diff`, so you can comfortably determine where your program went wrong in future labs.

The way to use this command is:

`diff -u file1 file2`

Note: For this course, `diff` should always be run with `-u`

## Reading `diff` Output with an Example

`a.txt` contents:
```
This is a file 
with text.
some changes may happen
```

`b.txt` contents:
```
this is a file
with text.
some changes might happen
```

`diff -u a.txt b.txt` output:
```
--- a.txt       2024-09-09 12:00:00.000000000 -0600
+++ b.txt       2024-09-09 12:00:00.000000000 -0600
@@ -1,3 +1,3 @@
-This is a file 
+this is a file
 with text.
-some changes may happen
+some changes might happen
```
**Output breakdown:**

The first two lines say that the `-` character corresponds to `a.txt`, and the `+` character corresponds to `b.txt`. Any time one of `-` or `+` appears on the output after this point, it will refer to its corresponding file. Lastly, `2024-09-09 ...` is the file's timestamp.

`@@ -1,3 +1,3 @@`: This line tells us which lines will be shown on the output given on the lines after this one:
- `-1,3` means that `diff` will show lines `1` through `3` from `a.txt`.
- `+1,3` means that `diff` will show lines `1` through `3` from `b.txt`.

The rest of the lines show the differences between both files on each line:

If at any point, there is a difference between both files on a particular line, then `diff` will show both versions of that line, with one of the two lines beginning with `-`, and the other with `+`, telling us which file these lines belong to. Example from above:

```
-This is a file 
+this is a file
```
and

```
-some changes may happen
+some changes might happen
```

If there are no differences on a line, `diff` will simply show the line common between both files with a space in the beginning (instead of `-` or `+`). Example from above:

```
 with text.
```

## Task
This repository has 4 directories, `Testcase1` to `Testcase4`. Each directory contains one or more **pairs** of text files. The two files in a pair have the same name except for a `.1` or `.2` just before `.txt`. For example, `Version3.1.txt` and `Version3.2.txt` are a pair. Each pair contains some differences or none at all.
 
You will write two bash scripts: `script.sh` and `check.sh`. Make sure these files run on the lab machines. 
 
### Part 1: `script.sh`
Write a bash script called `script.sh` that compares the files in each pair using `diff`.
 
Your script must:
* Be located in the root of your repository and work when run from there with `bash script.sh`
* Compare the two files in every pair with `diff -u`, with the `.1` file first and the `.2` file second (for example `diff -u Version3.1.txt Version3.2.txt`). The order matters, because swapping the files changes the output.
* Save the `diff -u` output of each pair that differs in a file named after the pair, without the `.1`/`.2`, followed by `Diff.txt`. The pair `Version3.1.txt` and `Version3.2.txt` gives `Version3Diff.txt`. The file must contain only the output of `diff -u`.
* Put these files in a directory called `Testcase#Diff` (`#` is the Testcase number), located in the root of your repository, **not** inside the `Testcase#` directory. For example: `Testcase3Diff/Version3Diff.txt`
* Do not create an output file for a pair with no differences
* Do not create the `Testcase#Diff` directory at all if there are no differences anywhere in that Testcase folder
* Do not change anything inside the `Testcase#` directories
* Give the same result no matter how many times it is run (hint: remove any old `Testcase#Diff` directory before creating a new one)
It may be helpful to look into bash `for` loops.
 
### Part 2: `check.sh`
Write a bash script called `check.sh` that verifies the files your `script.sh` produced.
 
Your `check.sh` must:
* Be located in the root of your repository and work when run from there with `bash check.sh`
* Only **read** files. It must not run `script.sh`, create or change any files, or rely on any files other than the `Testcase#` directories and your output
* Verify, for **each** of the 4 Testcases:
  * If at least one pair in the Testcase differs, the `Testcase#Diff` directory must exist. If no pair differs, it must **not** exist.
  * Every pair that differs must have its output file (for example `Version3Diff.txt`) in that directory, and its contents must match what `diff -u` reports for the two files
  * A pair that is identical must **not** have an output file
* Check every Testcase even if an earlier one fails
**Printing and exit status**
 
`check.sh` is graded by another script, so the format below must be followed exactly:
* Print exactly one line per Testcase to standard output, for all 4 Testcases, in this form:
  * `Testcase3: PASS` if that Testcase is correct
  * `Testcase3: FAIL` if that Testcase is incorrect
  
  (capital `T`, no space between `Testcase` and the number, a colon, one space, then `PASS` or `FAIL`)
* Do not print any other line starting with `Testcase#:` to standard output. If you want to explain what went wrong, print it to standard error instead (for example `echo "missing Testcase3Diff/Version2Diff.txt" >&2`) or start the line with something else
* Exit with status `0` if every Testcase is correct, and a non-zero status if any Testcase is incorrect
Example of correct output when Testcase3 is wrong and the others are right (the exit status is non-zero):
```
Testcase1: PASS
Testcase2: PASS
Testcase3: FAIL
Testcase4: PASS
```
 
Hints:
* `diff` and `cmp -s` return an exit status you can check with `$?` or an `if` statement: `0` means the files are the same, non-zero means they differ
* `[ -f file ]` tests whether a file exists and `[ -d dir ]` tests whether a directory exists
* The first two lines of `diff -u` output are the file names and timestamps, which can differ between runs. `tail -n +3` prints a file starting from its third line, so you can skip those two lines when comparing
* `exit 1` ends a script with a failure status
Your `check.sh` will be tested against **incorrect** outputs as well as correct ones (for example, a missing `Testcase#Diff` directory, an output file with the wrong contents, or a `Testcase#Diff` directory that should not exist). A script that always prints `PASS` will not earn mark

## Demo 
No questions from TAs this time, we are looking for completion of this ILC. 
1. Fork and clone this repository
   <img width="1238" height="62" alt="fork" src="https://github.com/user-attachments/assets/4e022d60-014c-4ed2-b0df-9726307f7e0a" />
<img width="764" height="610" alt="image" src="https://github.com/user-attachments/assets/d819ff71-bd3b-40d9-a187-9cfa28bc3edc" />

2. Make sure your forked repository is public (Hint: Use git clone)

3. After completing your bash scripts, show your `script.sh`, your `check.sh`, and the Testcase#Diff directories to TAs. Be ready to run `check.sh` to show that it passes on your output! 


