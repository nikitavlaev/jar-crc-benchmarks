# Prerequsites

Download [guava-31.0.1-jre.jar](https://repo1.maven.org/maven2/com/google/guava/guava/31.0.1-jre/guava-31.0.1-jre.jar) for JarFullLoad

Download [dacapo-9.12-MR1-bach.jar](https://sourceforge.net/projects/dacapobench/files/9.12-bach-MR1/dacapo-9.12-MR1-bach.jar/download) and rename it to <b>dacapo.jar</b>


Set <b>$JAVA_HOME</b> to the home directory of the patched version of CRaM.

Set <b>$JAVA_HOME1</b> to the home directory of the clean version of CRaM.

# Create images for checkpoint
```console
./scripts/performance.sh c
```

# Run performance benchmark

```console
./scripts/performance.sh
```

# Run memory benchmark

```console
./scripts/memory.sh
```
