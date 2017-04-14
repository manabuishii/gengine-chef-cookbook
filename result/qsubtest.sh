qsub -j y -o /tmp/result/echo.log -wd /tmp/result /tmp/result/echo.sh
while true
do
  sleep 2
  JOBS=$(qstat | wc -l)
  if [ "${JOBS}" = "0" ]; then
    break
  else
    RUNJOBS=$(($JOBS-2))
    echo "${RUNJOBS} jobs is remained."
  fi
done

RET=0
grep "vagrant@exec" /tmp/result/echo.log
RET=$((${RET}+$?))
echo "RET[${RET}] echo"
exit ${RET}
