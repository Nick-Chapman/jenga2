
Get me a jenga executable and the source code for the first example...

  $ ln $(find $TESTDIR/../.stack-work/dist -type f -name main.exe) jenga.exe
  $ cp -rp $TESTDIR/example-02-discover-deps example

Build from clean:
  $ ./jenga.exe build -c.
  elaborated 5 rules and 5 targets
  materalizing 1 artifact
  A: gcc -MG -MM fib.c -MF fib.d
  A: gcc -c fib.c -o fib.o
  A: gcc -MG -MM main.c -MF main.d
  A: gcc -c main.c -o main.o
  A: gcc fib.o main.o -o main.exe
  ran 5 actions
  $ ,jenga/example/main.exe
  hello, 55 world with auto discovery

Zero rebuild:
  $ ./jenga.exe build -c.
  elaborated 5 rules and 5 targets
  materalizing 1 artifact
  $ ,jenga/example/main.exe
  hello, 55 world with auto discovery

Change main.c
  $ sed -i 's/world/UNIVERSE/g' example/main.c
  $ ./jenga.exe build -c.
  elaborated 5 rules and 5 targets
  materalizing 1 artifact
  A: gcc -MG -MM main.c -MF main.d
  A: gcc -c main.c -o main.o
  A: gcc fib.o main.o -o main.exe
  ran 3 actions
  $ ,jenga/example/main.exe
  hello, 55 UNIVERSE with auto discovery

Whitespace change to fib.h
  $ sed -i 's/int fib/int      fib/g' example/fib.h
  $ ./jenga.exe build -c.
  elaborated 5 rules and 5 targets
  materalizing 1 artifact
  A: gcc -c fib.c -o fib.o
  A: gcc -c main.c -o main.o
  ran 2 actions
  $ ,jenga/example/main.exe
  hello, 55 UNIVERSE with auto discovery

Change const value in defs.h
  $ echo '#define MY_CONST 11' > example/defs.h
  $ ./jenga.exe build -c.
  elaborated 5 rules and 5 targets
  materalizing 1 artifact
  A: gcc -c main.c -o main.o
  A: gcc fib.o main.o -o main.exe
  ran 2 actions
  $ ,jenga/example/main.exe
  hello, 89 UNIVERSE with auto discovery

Setup ALT defs file (causes no actions):
  $ echo '#define MY_CONST 12' > example/defsALT.h
  $ ./jenga.exe build -c.
  elaborated 5 rules and 5 targets
  materalizing 1 artifact

Switch main to use ALT defs:
  $ sed -i 's/defs/defsALT/g' example/main.c
  $ ./jenga.exe build -c.
  elaborated 5 rules and 5 targets
  materalizing 1 artifact
  A: gcc -MG -MM main.c -MF main.d
  A: gcc -c main.c -o main.o
  A: gcc fib.o main.o -o main.exe
  ran 3 actions
  $ ,jenga/example/main.exe
  hello, 144 UNIVERSE with auto discovery

Modify original defs file back to original value (causes no action):
  $ echo '#define MY_CONST 10' > example/defs.h
  $ ./jenga.exe build -c.
  elaborated 5 rules and 5 targets
  materalizing 1 artifact
  $ ,jenga/example/main.exe
  hello, 144 UNIVERSE with auto discovery

Switch main back to origianl defs file (causes no action)::
  $ sed -i 's/defsALT/defs/g' example/main.c
  $ ./jenga.exe build -c.
  elaborated 5 rules and 5 targets
  materalizing 1 artifact
  $ ,jenga/example/main.exe
  hello, 55 UNIVERSE with auto discovery


Use feature of CC setup macro which is conditionally dependent on cflags key...

Compile with -Wall:
  $ echo '-Wall' > example/cflags
  $ ./jenga.exe build -c.
  elaborated 5 rules and 5 targets
  materalizing 1 artifact
  A: gcc -Wall -c fib.c -o fib.o
  A: gcc -Wall -c main.c -o main.o
  ran 2 actions

Compile with -O2 causes relink:
  $ echo '-O2' > example/cflags
  $ ./jenga.exe build -c.
  elaborated 5 rules and 5 targets
  materalizing 1 artifact
  A: gcc -O2 -c fib.c -o fib.o
  A: gcc -O2 -c main.c -o main.o
  A: gcc fib.o main.o -o main.exe
  ran 3 actions
