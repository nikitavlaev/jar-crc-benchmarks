## prepare
# $JAVA_HOME/bin/java -Zcheckpoint:./cache -XX:CRTrainingCount=3 $JVM_OPTS -Dcom.azul.System.exit.doCheckpointRestore=true -cp dacapo.jar com.azul.helper.CRMain Harness -n 1 avrora
# $JAVA_HOME1/bin/java -Zcheckpoint:./cache_cl -XX:CRTrainingCount=3 $JVM_OPTS -Dcom.azul.System.exit.doCheckpointRestore=true -cp dacapo.jar com.azul.helper.CRMain Harness -n 1 avror

mrec() {
        export RES=$(iostat -m | grep vda | awk '{ print $6 }');
}

mshow(){
        CUR=$(iostat -m | grep vda | awk '{ print $6 }');
        export DIF=$((CUR-RES));
        echo $DIF;
}

dropcache() {
        sync;
        echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null;
}

touch /tmp/res.txt

dropcache
mrec
$JAVA_HOME/bin/java -Zrestore:./cache $JVM_OPTS -Dcom.azul.System.exit.doCheckpointRestore=true -cp dacapo.jar com.azul.helper.CRMain Harness -n 1 avrora
mshow >> /tmp/res.txt

dropcache
mrec
$JAVA_HOME1/bin/java -Zrestore:./cache_cl $JVM_OPTS -Dcom.azul.System.exit.doCheckpointRestore=true -cp dacapo.jar com.azul.helper.CRMain Harness -n 1 avrora
mshow >> /tmp/res.txt

cat /tmp/res.txt
rm /tmp/res.txt