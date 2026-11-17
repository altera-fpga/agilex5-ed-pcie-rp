if test -n "$BASH" ; then SCRIPT_NAME=$BASH_SOURCE
elif test -n "$TMOUT"; then SCRIPT_NAME=${.sh.file}
elif test -n "$ZSH_NAME" ; then SCRIPT_NAME=${(%):-%x}
elif test ${0##*/} = dash; then x=$(lsof -p $$ -Fn0 | tail -1); SCRIPT_NAME=${x#n}
else SCRIPT_NAME=$0
fi

SCRIPT_DIR="$(cd "$(dirname -- "$SCRIPT_NAME")" 2>/dev/null && pwd -P)"

export RP_ROOTDIR=$(readlink -f ${SCRIPT_DIR}/../..)
unset SCRIPT_DIR

export WORKDIR=$RP_ROOTDIR/verification
export QUARTUS_HOME=$QUARTUS_ROOTDIR
export QUARTUS_INSTALL_DIR=$QUARTUS_ROOTDIR
export QUARTUS_ROOTDIR_OVERRIDE=$QUARTUS_ROOTDIR
export IMPORT_IP_ROOTDIR=$QUARTUS_ROOTDIR/../ip
export DESIGNWARE_HOME=/p/psg/EIP/synopsys/vip_common/vip_Q-2020.03A
export https_proxy=http://proxy-chain.intel.com:912
export http_proxy=http://proxy-chain.intel.com:911
export http_proxy=http://proxy-dmz.altera.com:912
export https_proxy=http://proxy-dmz.altera.com:912
echo "VCS                 " $VCS_HOME
echo "QUARTUS_HOME        " $QUARTUS_HOME
echo "IMPORT_IP_ROOTDIR   " $IMPORT_IP_ROOTDIR
echo "RP_ROOTDIR          " $RP_ROOTDIR

