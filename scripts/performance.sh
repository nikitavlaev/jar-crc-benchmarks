##  on mimas
# cd /tmp/diploma

# paths for docker
export JAVA_HOME=/mnt/diploma/zulu8-emb-one/build/linux-x86_64-normal-server-fastdebug/images/j2sdk-image
export JAVA_HOME1=/mnt/diploma/old_zulu8-emb-one/build/clean/images/j2sdk-image

CR_OPTS="-XX:CRTrainingCount=3 -XX:-UsePerfData"

IOLIM=1000mb
DOCKERLIM=(
        --device-read-bps  /dev/vda:$IOLIM
        --device-write-bps /dev/vda:$IOLIM
)
dropcache() {
        sync;
        echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null;
}

dr() {
	local tty_opt=
	[ -t 1 ] && tty_opt="-t";
	# docker run --rm -i $tty_opt --detach-keys ctrl-_ -e HOME=$HOME -v $HOME:$HOME -w $PWD -u $(id -u):$(id -g) "$@";
    docker run --privileged --rm -i $tty_opt -v $(pwd):/mnt/diploma -w /mnt/diploma "$@";
}

drr() {
        dropcache;
        dr ${DOCKERLIM[@]} "$@";
}

export CP="-cp dacapo.jar"
export BENCH="Harness -n 1 avrora"

# export CP=
# export BENCH="JarFullLoad"

# set -x
if [ $1 = "c" ]; then
    echo "Preparing checkpoint images";

    # if cache exists, delete it
    sudo rm -rf cache
    sudo rm -rf cache1

    echo ">>>> Patched";
    drr ubuntu:20.04 bash -c "$JAVA_HOME/bin/java -Zcheckpoint:./cache $CR_OPTS -Dcom.azul.System.exit.doCheckpointRestore=true $CP com.azul.helper.CRMain $BENCH > /dev/null; echo $? > /dev/null";

    echo ">>>> Clean";
    drr ubuntu:20.04 bash -c "$JAVA_HOME1/bin/java -Zcheckpoint:./cache1 $CR_OPTS -Dcom.azul.System.exit.doCheckpointRestore=true $CP com.azul.helper.CRMain $BENCH > /dev/null; echo $? > /dev/null";

    echo "Finished checkpoint";
else
    echo "Restoring";

    echo ">>>> Patched";
    drr ubuntu:20.04 bash -c "time $JAVA_HOME/bin/java -Zrestore:./cache -Dcom.azul.System.exit.doCheckpointRestore=true $CP com.azul.helper.CRMain $BENCH > /dev/null; echo $? > /dev/null";

    echo ">>>> Clean";
    drr ubuntu:20.04 bash -c "time $JAVA_HOME1/bin/java -Zrestore:./cache1 -Dcom.azul.System.exit.doCheckpointRestore=true $CP com.azul.helper.CRMain $BENCH > /dev/null; echo $? > /dev/null";

    echo "Finished restore";
fi
