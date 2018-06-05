
$CrashBehaviour = Get-WmiObject Win32_OSRecoveryConfiguration -EnableAllPrivileges

# To check the config of crash dump 
#$CrashBehaviour | Format-List *

#Make Debuginfo as 1
#0 = None
#1 = Complete memory dump
#2 = Kernel memory dump
#3 = Small memory dump
$CrashBehaviour | Set-WmiInstance -Arguments @{ DebugInfoType= $1}
#Make autoreboot as false
$CrashBehaviour | Set-WmiInstance -Arguments @{ AutoReboot=$False }

(Get-WmiObject -Class Win32_OSRecoveryConfiguration).DebugInfoType
(Get-WmiObject -Class Win32_OSRecoveryConfiguration).AutoReboot