
#Connect to SDDC and get token

$password = "PSC Password"

Request-VCFToken `
    -fqdn "SDDC FQDN" `
    -username "administrator@vsphere.local" `
    -password $password

    connect-VcfSddcManagerServer `
    -server "SDDC FQDN" `
    -username "administrator@vsphere.local" `
    -password $password

    # Retrieve vRLI details
$vRLIInfo = get-vrliServerDetail -Fqdn "Your SDDC FQDN" -Username administrator@vsphere.local -Password $password

# Extract primary node FQDN
$PrimaryNodeFqdn = $vRLIInfo.node3Fqdn
Write-Host "Primary Node FQDN: $PrimaryNodeFqdn" -ForegroundColor Cyan

# Prompt for root credentials
#$RootPassword = Read-Host "Enter the root password for $PrimaryNodeFqdn"

# Establish SSH connection to the primary node & #Check admin status
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$PrimaryNodeFqdn '/usr/lib/loginsight/application/sbin/li-reset-admin-passwd.sh --checkAdminStatus'


