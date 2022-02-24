echo "******************************************************************************"
echo "Create networking files if they don't already exist." `date`
echo "******************************************************************************"
if [ ! -f ${ORACLE_HOME}/network/admin/tnsnames.ora ]; then
  echo "******************************************************************************"
  echo "First start, so create networking files." `date`
  echo "******************************************************************************"
export  PRIMARY_DB=`echo ${PRIMARY_DB_SVC} | cut -d '.' -f1`
export  STANDBY_DB=`echo ${STANDBY_DB_SVC} | cut -d '.' -f1`
  cat > ${ORACLE_HOME}/network/admin/tnsnames.ora <<EOF
${PRIMARY_DB}= 
(DESCRIPTION = 
  (ADDRESS = (PROTOCOL = TCP)(HOST = ${PRIMARY_HOST})(PORT = ${PRIMARY_DB_PORT}))
  (CONNECT_DATA =
    (SERVER = DEDICATED)
    (SERVICE_NAME = ${PRIMARY_DB_SVC})
  )
)

${STANDBY_DB}= 
(DESCRIPTION = 
  (ADDRESS = (PROTOCOL = TCP)(HOST = ${STANDBY_HOST})(PORT = ${STANDBY_DB_PORT}))
  (CONNECT_DATA =
    (SERVER = DEDICATED)
    (SERVICE_NAME = ${STANDBY_DB_SVC})
  )
)
EOF

echo -e "WALLET_LOCATION = (SOURCE = (METHOD = FILE) (METHOD_DATA = (DIRECTORY = /u01/app/oracle/admin/wallet)))\nSQLNET.WALLET_OVERRIDE = TRUE" >${ORACLE_HOME}/network/admin/sqlnet.ora
fi
echo "******************************************************************************"
echo "Create WALLET files if they don't already exist." `date`
echo "******************************************************************************"
if [ ! -d /u01/app/oracle/admin/wallet ]; then
echo "******************************************************************************"
echo "First start, so create WALLET files." `date`
echo "******************************************************************************"
mkdir -p /u01/app/oracle/admin/wallet
echo -e "${SYS_PASSWORD}\n${SYS_PASSWORD}" | mkstore -wrl /u01/app/oracle/admin/wallet -create
echo "${SYS_PASSWORD}" |mkstore -wrl /u01/app/oracle/admin/wallet -createEntry oracle.security.client.default_username SYS
echo "${SYS_PASSWORD}" |mkstore -wrl /u01/app/oracle/admin/wallet -createEntry oracle.security.client.default_password ${SYS_PASSWORD}
fi
echo "******************************************************************************"
echo "Create observer files if they don't already exist." `date`
echo "******************************************************************************"
if [ ! -d /u01/app/oracle/admin/observer ]; then
mkdir -p /u01/app/oracle/admin/observer
fi
echo "******************************************************************************"
echo "Run OBSERVER." `date`
echo "******************************************************************************"
dgmgrl -logfile '/u01/app/oracle/admin/observer/observer.log' /@${PRIMARY_DB} "start observer FILE='/u01/app/oracle/admin/observer/fsfo.dat'" &
sleep 30
dgmgrl /@${PRIMARY_DB} "enable fast_start failover"
echo "******************************************************************************"
echo "Tail the alert log file as a background process" `date`
echo "and wait on the process so script never ends." `date`
echo "******************************************************************************"
tail -f /u01/app/oracle/admin/observer/observer.log &
bgPID=$!
wait $bgPID

