
#Connect to SDDC and get token

$password = "PSC Password"

Request-VCFToken `
    -fqdn "SDDC FQDN" `
    -username "svc-vcf-report@vsphere.local" `
    -password $password

    connect-VcfSddcManagerServer `
    -server "SDDC FQDN" `
    -username "administrator@vsphere.local" `
    -password $password

    # Retrieve vRLI details
$vRLIInfo = get-vrliServerDetail -Fqdn aqgge1avcf01.qgt.qld.gov.au -Username svc-vcf-report@vsphere.local -Password $password

# Extract primary node FQDN
$PrimaryNodeFqdn = $vRLIInfo.node3Fqdn
Write-Host "Primary Node FQDN: $PrimaryNodeFqdn" -ForegroundColor Cyan

# Prompt for root credentials
#$RootPassword = Read-Host "Enter the root password for $PrimaryNodeFqdn"

# Establish SSH connection to the primary node & #Check admin status
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$PrimaryNodeFqdn '/usr/lib/loginsight/application/sbin/li-reset-admin-passwd.sh --checkAdminStatus'


