# PRTG Sensor for Windows Backup
*based on [htrengove/PRTGwindowsbackup](https://github.com/htrengove/PRTGwindowsbackup/)* 

## How to install
1. Download WindowsBackup.ps1
2. Save it to your PRTG custom sensor folder for XML-sensors   
e.g. C:\Program Files (x86)\PRTG Network Monitor\Custom Sensors\EXEXML

## How to use
1. In PRTG create a new sensor and choose Type "Program/Script (Advanced)"
2. Adjust the following settings:
   * Program/Script: choose WindowsBackup.ps1 from drop-down menu
   * Parameter: '%host' '%windowsdomain' '%windowsuser' '%windowspassword'

## Channels
The channels will be created automatically and have some default limits:

| Channel Name | Description | Values | Warning | Error |
| ------------ | ----------- | ------ | ------- | ----- |
| Backup Status           | Represents the latest status code from Windows Backup | 0 for Success <br/> non-0 for Failure | | <=1 <br/> >=1
| Hours Since Last Backup | Hours past since last successfully created Backup | e.g. 12h | >=26 | >=50
| Number of Versions      | No. of backups currently available | e.g. 25# | | <=0
