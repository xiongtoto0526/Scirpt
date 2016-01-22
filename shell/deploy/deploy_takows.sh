
QA_TAKOWS="/var/lib/jenkins/workspace/qa-takows"

function pull () {
    cd "$QA_TAKOWS"
    [ -n "$1" ] && git checkout "$1"
    git pull
}

function restart () {
    echo "ready to restart"
    cd $QA_TAKOWS/run
    pids=`pgrep "takows$"`
    # echo "pids=$pids"
    # pids=`echo $pids`|grep -v $$
    # echo "=========== $pids"
    for pid in $pids
    do
        kill $pid
        echo "stop process: " $pid
        sleep 1
        cn=`ps -p $pid | wc -l`
        if [ $cn -gt 1 ]; then
            kill -9 $pid
        fi
    done
    nohup ./takows > /dev/null 2>&1 &
    retval=$?
    sleep 1
    [ $retval -eq 0 ] || echo "Restart FAILED" && echo "Restart SUCCESS"
}

function goget () {
    echo "ready to get dependence"
    cd "$QA_TAKOWS/gotako"
    ./golib
    echo "finish get dependence"
}

function build () {
    echo "ready to build tako"
    cd $QA_TAKOWS
    # set -x
    go install -ldflags "-s -w" github.com/yaosxi/mgox
    go install -ldflags "-s -w" takows
    [ -d run ] || mkdir -p run
    mv gotako/bin/takows run/

    # cd $QA_TAKOWS/client/web
    # grunt build
    # mv $QA_TAKOWS/run/web $QA_TAKOWS/run/web.bak
    # mv $QA_TAKOWS/client/web/dist $QA_TAKOWS/run/web
    # rm -rf $QA_TAKOWS/run/web.bak
    echo "finish build tako"
}

function usage() {
IFS=
usage_msg="
Use this script to update, build and deploy takows.

Userage: deploy_takows.sh [-h|--help] [-r|--restart] [-p|--help [branch_name]]
    -h, --help                  Show usage
    -p, --pull [branch_name]    Pull from github, pull from current branch if [branch_name] is not set
    -b, --build                 Build system
    -r, --restart               Restart server
    -a, --all                   Equals to -brp

EXAMPLES:
    # only restart takows
    ./deploy_takows.sh --restart
    # update source code and build system and then restart
    ./deploy_takows.sh --pull -b -r
    # update source code from branch [qa] and build system, but not restart
    ./deploy_takows.sh -p qa -b
"
echo $usage_msg
IFS=,
}

#=======================================================================
########################### MAIN PROCCESS ##############################
#=======================================================================
ARGS=`getopt -o hap::br -l help,all,pull::,build,restart -n 'deploy_takows.sh' -- "$@"`
# from http://blog.chinaunix.net/uid-21651880-id-3392466.html


if [ $? != 0 ]; then
    echo "Terminating... see -h or --help for help"
    exit 1
fi

eval set -- "${ARGS}"

while [[ true ]]; do
    case "$1" in
        -h | --help)
            shift
            SHOW_HELP=yes
            ;;
        -a | --all)
            shift
            ALL="yes"
            ;;
        -p | --pull)
            NEED_PULL=yes
            SHOW_HELP=no
            case $2 in
                "")
                    echo "update source from current branch"
                    shift 2
                    ;;
                *)
                    BRANCH_NAME=$2
                    echo "update source from branch [$BRANCH_NAME]"
                    shift 2
                    ;;
            esac
            ;;
        -b | --build)
            shift
            SHOW_HELP=no
            #echo "build system"
            NEED_BUILD=yes
            ;;
        -r | --restart)
            shift
            SHOW_HELP=no
            #echo "Need restart system after build"
            NEED_RESTART=yes
            ;;
        --)
            shift
            break
            ;;
        -*)
            echo "Wrong option~~ Please read the flowing usage doc."
            echo ""
            usage
            exit 2
            ;;
        *)
            break
            ;;
    esac
done

#======================= Check System Env ================================

if [ "$SHOW_HELP" = "yes" ]; then
    usage
    exit 0
fi

if [[ "$ALL" = "yes" ]]; then
    NEED_PULL="yes"
    NEED_BUILD="yes"
    NEED_RESTART="yes"
fi

[ "$NEED_PULL" = "yes" ] && pull "$BRANCH_NAME"
[ "$NEED_BUILD" = "yes" ] && goget && build
[ "$NEED_RESTART" = "yes" ] && restart


