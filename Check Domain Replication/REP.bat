@echo off

set logfile=\\server\AD\replication.log

:ShowCurrentDate
echo Replication Status for %computername%:  >> %logfile%
echo  >> %logfile%
echo %date% %time% >> %logfile%

:StartRepAdmin
Echo Compiling Replication Summary...
REPADMIN /REPLSUMMARY /bysrc /bydest /errorsonly /sort:delta>> %logfile%

echo  >> %logfile%
echo  >> %logfile%
echo ========================================================================== >> %logfile%
echo  >> %logfile%
echo  >> %logfile%
:Finish
Echo Finished %computername%!

Test Commit
