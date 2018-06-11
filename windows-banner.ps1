#Genpact Banner Deployment Start

Set-Location -Path C:\Users\Administrator\AppData\Local\

Start-Sleep -s 1

Remove-Item "C:\Users\Administrator\AppData\Local\Ec2Wallpaper_Info.jpg"

Remove-Item "C:\Users\Administrator\AppData\Local\Ec2Wallpaper.jpg"

Start-Sleep -s 1

Start-BitsTransfer -source "https://s3.amazonaws.com/ddehardening/WP.jpg"

Start-Sleep -s 1

reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d C:\Users\Administrator\AppData\Local\WP.jpg /f

Start-Sleep -s 5

rundll32.exe user32.dll, UpdatePerUserSystemParameters, 0, $false

Start-Sleep -s 1

Get-ItemProperty -path "HKCU:\Control Panel\Desktop"

#Genpact Banner Deployment End
