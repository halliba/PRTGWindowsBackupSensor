# PRTG Sensor for Windows Backup
# see https://github.com/halliba

$ErrorActionPreference = "Stop";
$hostname = $args[0];
$domain = $args[1];
$username = $args[2];
$password = $args[3];

#create credentials
$secPassword = $password | ConvertTo-SecureString -AsPlainText -Force;
$userDomainName = $domain + '\' + $username;
$creds = New-Object -TypeName System.Management.Automation.PSCredential ($userDomainName, $secPassword);

#add hostname to trusted hosts to connect without ssl
Set-Item WSMan:\localhost\Client\TrustedHosts -Value $hostname -Concatenate -Force;

#get backup summary from host
$backupSummary = Invoke-Command -ComputerName $hostname -Credential $creds -ScriptBlock {
    Add-PSSnapin windows.ServerBackup -ErrorAction SilentlyContinue; #required for Windows Server 2008 / 2008 R2
    Get-WBSummary;
};

#calculate hours since last backup
$lastBackup = (Get-Date) - ($backupSummary.LastSuccessfulBackupTime | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum);

Write-Host "<prtg>
  <result>
    <channel>Backup Status</channel>
    <value>$($backupSummary.LastBackupResultHR)</value>
    <limitMaxError>1</limitMaxError>
    <limitMinError>-1</limitMinError>
    <limitMode>1</limitMode>
  </result>

  <result>
    <channel>Hours Since Last Backup</channel>
    <value>$([math]::Floor($lastBackup.TotalHours))</value>
    <unit>TimeHours</unit>
    <limitMaxWarning>26</limitMaxWarning>
    <limitMaxError>50</limitMaxError>
    <limitMode>1</limitMode>
  </result>

   <result>
    <channel>Number of Versions</channel>
    <value>$($backupSummary.NumberOfVersions)</value>
    <limitMinError>0</limitMinError>
  </result>
</prtg>";