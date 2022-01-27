export JAVA_HOME=/home/ubuntu/zulu/diploma/zulu8-emb-one/build/linux-x86_64-normal-server-fastdebug//images/j2sdk-image
export JAVA_HOME1=/home/ubuntu/zulu/diploma/zulu8-emb-one/build/clean/images/j2sdk-image

# benches=(avrora batik eclipse fop h2 jython luindex lusearch lusearch-fix pmd sunflow tomcat xalan)
# benches=(avrora eclipse h2 lusearch lusearch-fix pmd sunflow xalan)
# tradebeans tradesoap, batik -- bugs
benches=(tomcat)

TRAIN_COUNT=3

for bnch in ${benches[@]}; do
    # checkpoint
    $JAVA_HOME/bin/java -Zcheckpoint:./cache -XX:CRTrainingCount=$TRAIN_COUNT -Dcom.azul.System.exit.doCheckpointRestore=true -cp dacapo.jar com.azul.helper.CRMain Harness -n 1 $bnch 2>&1 | tee logs/log${bnch}p_c.txt
    $JAVA_HOME1/bin/java -Zcheckpoint:./cache_cl -XX:CRTrainingCount=$TRAIN_COUNT -Dcom.azul.System.exit.doCheckpointRestore=true -cp dacapo.jar com.azul.helper.CRMain Harness -n 1 $bnch 2>&1 | tee logs/log${bnch}c_c.txt

    # restore
    echo "Restore" >> logs/${bnch}.txt
    echo "Patched 1" >> logs/${bnch}.txt
    $JAVA_HOME/bin/java -Zrestore:./cache -Dcom.azul.System.exit.doCheckpointRestore=true -cp dacapo.jar com.azul.helper.CRMain Harness -n 1 $bnch 2>&1 | grep -v -f forbidden.txt >> logs/${bnch}.txt
    echo "Clean 1" >> logs/${bnch}.txt
    $JAVA_HOME1/bin/java -Zrestore:./cache_cl -Dcom.azul.System.exit.doCheckpointRestore=true -cp dacapo.jar com.azul.helper.CRMain Harness -n 1 $bnch 2>&1 | grep -v -f forbidden.txt >> logs/${bnch}.txt

    echo "Clean 2" >> logs/${bnch}.txt
    $JAVA_HOME1/bin/java -Zrestore:./cache_cl -Dcom.azul.System.exit.doCheckpointRestore=true -cp dacapo.jar com.azul.helper.CRMain Harness -n 1 $bnch 2>&1 | grep -v -f forbidden.txt >> logs/${bnch}.txt
    echo "Patched 2" >> logs/${bnch}.txt
    $JAVA_HOME/bin/java -Zrestore:./cache -Dcom.azul.System.exit.doCheckpointRestore=true -cp dacapo.jar com.azul.helper.CRMain Harness -n 1 $bnch 2>&1 | grep -v -f forbidden.txt >> logs/${bnch}.txt
done

# VARIES
# lusearch 
# lusearch-fix
# pmd
# xalan
# avrora

# OK
# eclipse
# h2
# sunflow

# ?
# jython FAILED? Digest validation failed -- because of logging
# luindex FAILED? Digest validation failed -- because of logging

# ???
# tomcat failed silently for each



# $JAVA_HOME/bin/java -Zcheckpoint:./cache -XX:CRTrainingCount=3 -Dcom.azul.System.exit.doCheckpointRestore=true -cp dacapo.jar com.azul.helper.CRMain Harness -n 1 avrora 2>&1 | tee log.txt
# $JAVA_HOME/bin/java -Zrestore:./cache -Dcom.azul.System.exit.doCheckpointRestore=true -cp dacapo.jar com.azul.helper.CRMain Harness -n 1 avrora # 2>&1 | tee log1.txt

# $JAVA_HOME1/bin/java -Zcheckpoint:./cache_cl -XX:CRTrainingCount=3 -Dcom.azul.System.exit.doCheckpointRestore=true -cp dacapo.jar com.azul.helper.CRMain Harness -n 1 avrora 2>&1 | tee log.txt
# $JAVA_HOME1/bin/java -Zrestore:./cache_cl -Dcom.azul.System.exit.doCheckpointRestore=true -cp dacapo.jar com.azul.helper.CRMain Harness -n 1 avrora # 2>&1 | tee log1.txt