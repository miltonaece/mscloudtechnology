# Powershell Script to Rotate ESXI root passwords on selected hosts


#################

### VARIABLES ###

#################

$SDDCManager = "Your SDDC manager FQDN"

$vcfUsername = "Administrator@vsphere.local"

$vcfPassword = "Password"

Request-VCFToken -fqdn $SDDCManager -username $vcfUsername -password $vcfPassword

#Configure Path to store json configuration files

    $jsonFilePath = "Path\1.ESXI" #Windows System

#Select All Hosts from Given Cluster

#$VCFClusterName = "vcf-m01-cl01 vcf-w01-cl01"

#$VCFClusterId = (Get-VCFCluster -name $VCFClusterName).id

#$vcfHosts = Get-VCFHost |Where-Object {$_.cluster.id -eq $VCFClusterId} |Select-Object fqdn, id |Sort-Object fqdn

# Or select ALL hosts from VCF | You may want to filter here


# Define multiple cluster names

$VCFClusterNames = @("vcf-m01-cl01", "vcf-w01-cl01")

$vcfHosts = @()


# Get hosts for each cluster and combine

foreach ($clusterName in $VCFClusterNames) {

    $clusterId = (Get-VCFCluster -name $clusterName).id

    $hostsInCluster = Get-VCFHost | Where-Object { $_.cluster.id -eq $clusterId } | Select-Object fqdn, id

    $vcfHosts += $hostsInCluster

}


#$vcfHosts = Get-VCFHost |Select-Object fqdn


# Write current root passwords to console

foreach ($vcfHost in $vcfHosts){

    $recName = $vcfHost.fqdn

    $VCFCreds =  Get-VCFCredential -resourceName $recName|Where-Object {$_.username -eq "root"}

    Write-host "Current root credentials for VCF Host" $recName " : " $VCFCreds.password

}


# Change root passwords - Operation Type can be UPDATE, ROTATE, REMEDIATE

foreach ($vcfHost in $vcfHosts) {

    $esxFilename = $jsonFilePath + $vcfHost.fqdn + ".json"

    $recName = $vcfHost.fqdn

    #$recId = $vcfHost.id

    $jsonData = "{

        `"elements`": [ {

            `"credentials`": [ {

                `"credentialType`": `"SSH`",

                `"username`": `"root`"

            } ],

            `"resourceName`": `"$recName`",

            `"resourceType`": `"ESXI`"

        } ],

        `"operationType`": `"ROTATE`"

    }"

    $jsonData |Out-File $esxFilename -Force #Export the json to a file

    Set-VCFCredential -json $esxFilename

    Start-Sleep -Seconds 10 #This is really lazy. You should use Get-VCFCredentialTask :)

}


# Write current root passwords to console

foreach ($vcfHost in $vcfHosts){

    $recName = $vcfHost.fqdn

    $VCFCreds =  Get-VCFCredential -resourceName $recName|Where-Object {$_.username -eq "root"}

    Write-host "Current root credentials for VCF Host" $recName " : " $VCFCreds.password

}
