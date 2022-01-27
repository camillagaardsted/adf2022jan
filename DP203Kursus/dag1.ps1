## DAg 1 DP203 kursus


$connectTestResult = Test-NetConnection -ComputerName su20220124storage.file.core.windows.net -Port 445


if ($connectTestResult.TcpTestSucceeded) {
    # Save the password so the drive will persist on reboot
    # anMVTwdlQV3PLWcEDW8sc9ub2wrhH+l95NRcu6cs/o6p45xjJGsbold2LCLKjWqSbom7Lm1yCIntVypjvm3NgA==
    cmd.exe /C "cmdkey /add:`"su20220124storage.file.core.windows.net`" /user:`"localhost\su20220124storage`" /pass:`"anMVTwdlQV3PLWcEDW8sc9ub2wrhH+l95NRcu6cs/o6p45xjJGsbold2LCLKjWqSbom7Lm1yCIntVypjvm3NgA==`""
    # Mount the drive
    New-PSDrive -Name T -PSProvider FileSystem -Root "\\su20220124storage.file.core.windows.net\bidepartment" -Persist
} else {
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}


# 
# Vi har to muligheder når vi scripter til Azure lokalt:
# ) PowerShell
# ) Azure CLI
# Eller begge værktøjer findes også tilgængelige i shell.azure.com


# VI KAN OGSÅ SCRIPTE oprettelse af ressourcer via ARM (Azure resource manager) templates 
# se https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-powershell


New-AzResourceGroupDeployment -ResourceGroupName $resourcegroup -TemplateParameterFile C:\DP203Kursus\databricks\parameters.json -TemplateFile C:\DP203Kursus\databricks\template.json


######################################################################

# PowerShell modulet til at håndtere ressourcer i Azure
Install-Module az

Get-command New-AzResourceGroup


$resourcegroup='dk'
$location="westeurope"
$datalakeName = "datalake20220124"

Connect-AzAccount

New-AzResourceGroup -Name $resourcegroup

New-AzStorageAccount -Name $datalakeName -ResourceGroupName $resourcegroup -SkuName Standard_GRS  -Location $location -Kind StorageV2 -AccessTier Hot -EnableHierarchicalNamespace $True


Get-AzStorageAccount


New-AzDatabricksWorkspace

# ###

# SQL værktøj som bliver afløser for SSMS er Azure Data Studio
# kan sagtens bruges onpremise

# https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver15


get-service *sql*


# notebooks anvendes bredt i dag f.eks. til python, powershell, sql etc
# indholder tekstblokke
# og indeholder kodeblokke i sql, python etc og en play knap

# databricks anvender notebooks til scripts

# Pa55w.rd

# Databricks

# Under advanced settings kan man slå den her til:
# DBFS File Browser: Enabled


# i key vault: covidcontainer
# ?sv=2020-10-02&st=2022-01-24T14%3A19%3A41Z&se=2023-01-25T14%3A19%3A00Z&sr=c&sp=rl&sig=RgdEq1JsGGv3ejvQXQo1GeISjaI96PtmDdLU4AePxuM%3D

# vi opretter secret scope i databricks via
# https://<databricks-instance>#secrets/createScope

# https://adb-8853563606950129.9.azuredatabricks.net/?o=8853563606950129#secrets/createScope

# databricksscope

###########################################################################################################
$cred=Get-Credential
New-AzSqlServer -Name sqlserver20220125 -Location $location -ResourceGroupName $resourcegroup -SqlAdministratorCredentials $cred



# vi skal oprette nogle brugere i Azure Ad

Get-AzDomain
# 
#su20220124outlook.onmicrosoft.com

$tenantName = 'su20220124outlook'
$pn = "$tenantName.onmicrosoft.com"

Get-AzDomain

$password="Pa55w.rd"
$passwordSecure=ConvertTo-SecureString -AsPlainText $password -Force


$username="otto"
$Name="Otto Pilfinger"
$upn = "$username@$pn"
$mailnickname="ottoregnskab"
$otto=New-AzADUser -DisplayName $Name -UserPrincipalName $upn -Password $passwordSecure -MailNickname $mailnickname

$username="ottoline"
$Name="Ottoline Pilfinger"
$upn = "$username@$pn"
$mailnickname="ottolinemarketing"
$ottoline=New-AzADUser -DisplayName $Name -UserPrincipalName $upn -Password $passwordSecure -MailNickname $mailnickname



$groupName="BI group"
$mailnickname="bigruppen"
$bigroup=New-AzADGroup -DisplayName $groupName -MailNickname $mailnickname 

Add-AzADGroupMember -TargetGroupDisplayName $groupName -MemberUserPrincipalName $otto.UserPrincipalName,$ottoline.UserPrincipalName

# IT folk:

$username="ivan"
$Name="Ivan IT"
$upn = "$username@$pn"
$mailnickname="ivanit"
$ivan=New-AzADUser -DisplayName $Name -UserPrincipalName $upn -Password $passwordSecure -MailNickname $mailnickname

$username="frode"
$Name="Frode Pilfinger"
$upn = "$username@$pn"
$mailnickname="frodeit"
$frode=New-AzADUser -DisplayName $Name -UserPrincipalName $upn -Password $passwordSecure -MailNickname $mailnickname

# Opret sikkerhedsgruppe til vores to IT folk
$groupName="IT group"
$mailnickname="itgruppen"
$bigroup=New-AzADGroup -DisplayName $groupName -MailNickname $mailnickname 

Add-AzADGroupMember -TargetGroupDisplayName $groupName -MemberUserPrincipalName $ivan.UserPrincipalName,$frode.UserPrincipalName


# Opret sikkerhedsgruppe til vores to IT folk
$groupName="DBA group"
$mailnickname="dbagruppen"
$dbagroup=New-AzADGroup -DisplayName $groupName -MailNickname $mailnickname 

Add-AzADGroupMember -TargetGroupDisplayName $groupName -MemberUserPrincipalName $upn


$otto












