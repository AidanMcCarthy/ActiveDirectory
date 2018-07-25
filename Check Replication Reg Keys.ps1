$server = Get-Content C:\temp\dc_server_list.txt
Import-Module PSRemoteRegistry

foreach ($entry in $list) {
	Get-RegString -ComputerName $server -Hive LocalMachine -Key SYSTEM\CurrentControlSet\Services\NTDS\Parameters -Value "TCP/IP Port" | Select-Object ComputerName,Value,Data
	Get-RegString -ComputerName $server -Hive LocalMachine -Key SYSTEM\CurrentControlSet\Services\NtFrs\Parameters -Value "RPC TCP/IP Port Assignment" | Select-Object ComputerName,Value,Data
	Get-RegMultiString -ComputerName $server -Hive LocalMachine -Key SOFTWARE\Microsoft\Rpc\Internet -Value "Ports" | Select-Object ComputerName,Value,Data
	}