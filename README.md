### testlr

To build a `rust.jar` file, make sure that `rust.g4` exists in the project's root directory and that you have all the necessary Java tooling installed. Then run:

```bash
$ make rust.jar
```

This will pull the latest ANTLR4 binary, transpile the grammar file into Java, compile to classes and archive the classes to produce a `rust.jar` file.

The `rust.jar` file is a standalone command-line utility that can be used to test Rust programs. To test that an arbitrary file `/path/to/hello_world.rs` is grammatically valid, run the following:

```bash
$ java -cp antlr-4.8-complete.jar:rust.jar rust.main /path/to/hello_world.rs
/path/to/hello_world.rs
PASS
```

If the given file is grammatically invalid, a `FAIL` message, along with the errors will be printed. The exit code of the JAR can also be used to determine the validity of a tested program (exit codes 0 and 127 signify `PASS` and `FAIL`, respectively).

This repo also contains the test suite imported from the Rust source tree. This can be found in `tests/rust`. To run `testlr` on every `.rs` file:

```bash
$ mak rust.test
```

This will automatically traverse, find, and process each Rust file through the JAR utility in parallel.

#### Other Languages

Currently, support exists for Rust. Other languages aren't supported, but can be added trivially. To do so, simply add the grammar file to the project's root directory and run `make <language>.jar` to generate the JAR file. Some languages (such as Go) make require auxillary files in ANTLR4, so care must be taken to modify the `Makefile` appropriately.
