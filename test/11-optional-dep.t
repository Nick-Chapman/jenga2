
  $ ln $(find $TESTDIR/../.stack-work/dist -type f -name main.exe) jenga.exe
  $ cp -rp $TESTDIR/example-11-optional-dep example

Build:
  $ ./jenga.exe build -c.
  elaborated 2 rules and 2 targets
  materalizing 1 artifact
  A: gcc -c $(test -f CFLAGS && cat CFLAGS) main.c
  A: gcc -o main.exe main.o
  ran 2 actions

Zero build:
  $ ./jenga.exe build -c.
  elaborated 2 rules and 2 targets
  materalizing 1 artifact

Define CFLAGS; rebuilds:
  $ echo '-O2' > example/CFLAGS
  $ ./jenga.exe build -c.
  elaborated 2 rules and 2 targets
  materalizing 1 artifact
  A: gcc -c $(test -f CFLAGS && cat CFLAGS) main.c
  A: gcc -o main.exe main.o
  ran 2 actions

Change CFLAGS; rebuilds:
  $ echo '-Wall' > example/CFLAGS
  $ ./jenga.exe build -c.
  elaborated 2 rules and 2 targets
  materalizing 1 artifact
  A: gcc -c $(test -f CFLAGS && cat CFLAGS) main.c
  main.c:2:6: warning: return type of 'main' is not 'int' [-Wmain]
      2 | void main() { //m ain ought to be declared as int. -Wall will detect this.
        |      ^~~~
  ran 1 action

Remove CFLAGS; reuse original build:
  $ rm example/CFLAGS
  $ ./jenga.exe build -c.
  elaborated 2 rules and 2 targets
  materalizing 1 artifact
