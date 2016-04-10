export BACKUPPC_PASSWORD=password
export LOCAL_ZONE=America/New_York
export DOMAIN_NAME=default.com
export LOCAL_ADDR=`ip addr | grep -E "inet .*eth0" | awk '{ split($2,results,"\/"); print results[1]; }'`
