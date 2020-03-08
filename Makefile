SHELL := bash

JAVA_DIR = $(PWD)/java
CLASS_DIR = $(PWD)/class

JAVA_BIN  = $(shell which java)
JAVAC_BIN = $(shell which javac)
JAR_BIN   = $(shell which jar)

ANTLR_JAR = antlr-4.7.1-complete.jar

ext_c    = c
ext_java = java
ext_go   = go
ext_rust = rs

.PHONY: all
all: rust.jar

%.test: %.jar
	find tests/$(basename $@) -name \*.$(ext_$(basename $@)) -print0 | parallel -j $(shell nproc) --null java -cp ${ANTLR_JAR}:$< rust.main

${ANTLR_JAR}:
	curl "https://www.antlr.org/download/antlr-4.7.1-complete.jar" -o ${ANTLR_JAR}

.PRECIOUS: ${JAVA_DIR}/%
${JAVA_DIR}/%: %.g4
	rm -rf $@ && mkdir -p $@
	${JAVA_BIN} -jar ${ANTLR_JAR} -package $(basename $<) $< -o $@

.PRECIOUS: %.main.java
%.main: main.java
	rm -rf ${JAVA_DIR}/$(basename $@)/META-INF && mkdir -p ${JAVA_DIR}/$(basename $@)/META-INF
	echo "Main-Class: $(basename $@).main" >${JAVA_DIR}/$(basename $@)/META-INF/MANIFEST.MF
	sed 's/{{% REPLACE_LANG %}}/'$(basename $@)'/g' main.java >${JAVA_DIR}/$(basename $@)/main.java

.PRECIOUS: ${CLASS_DIR}/%
${CLASS_DIR}/%: ${JAVA_DIR}/% %.main ${ANTLR_JAR}
	rm -rf $@ && mkdir -p $@
	CLASSPATH=${ANTLR_JAR} ${JAVAC_BIN} $</*.java -d $@

%.jar: ${CLASS_DIR}/%
	${JAR_BIN} --create --file $@ --manifest ${JAVA_DIR}/$(basename $@)/META-INF/MANIFEST.MF -C $< .

.PHONY: clean
clean:
	rm -vrf *.jar ${JAVA_DIR} ${CLASS_DIR}
