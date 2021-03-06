#!/bin/bash -
#title           :down.sh
#description     :bring down a kraken cluster
#author          :Samsung SDSRA
#==============================================================================
# k2-crash-app is taking over the EXIT in common.sh functions called in the trap
# leaving this commented out in case we missed an edge case
# set -o errexit
set -o nounset
set -o pipefail

# pull in utils
my_dir=$(dirname "${BASH_SOURCE}")
source "${my_dir}/../lib/common.sh"

# capture logs for crash app
LOG_FILE=$"/tmp/crash-logs"

# exit trap for crash app
trap crash_test_down EXIT

K2_CRASH_APP=$(which k2-crash-application)  
if [ $? -ne 0 ];then  
	ansible-playbook ${K2_VERBOSE} -i ansible/inventory/localhost ansible/down.yaml --extra-vars "${KRAKEN_EXTRA_VARS}kraken_action=down" --tags "${KRAKEN_TAGS}"
else
	ansible-playbook ${K2_VERBOSE} -i ansible/inventory/localhost ansible/down.yaml --extra-vars "${KRAKEN_EXTRA_VARS}kraken_action=down" --tags "${KRAKEN_TAGS}" | tee $LOG_FILE
fi