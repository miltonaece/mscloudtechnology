*********************************************************************************************************

# Define SDDC Manager details

$sddcManagerFqdn = "Your SDDC Manager"

$sddcManagerUser = "administrator@vsphere.local"

$sddcManagerPass = "Password"

$sddcManagerLocalUser = "vcf"

$sddcManagerLocalPass = "Password"



# Define the path for the report directory

$reportDirectory = "/tmp/reporting/"


# Create the directory if it doesn't exist

if (-not (Test-Path $reportDirectory)) {

    New-Item -Path $reportDirectory -ItemType Directory

}


# Generate the health report

Invoke-VcfHealthReport -sddcManagerFqdn $sddcManagerFqdn `

    -sddcManagerUser $sddcManagerUser `

    -sddcManagerPass $sddcManagerPass `

    -sddcManagerLocalUser $sddcManagerLocalUser `

    -sddcManagerLocalPass $sddcManagerLocalPass `

    -reportPath $reportDirectory `

    -allDomains


# Find the latest HTML report file

$latestReportFile = Get-ChildItem -Path $reportDirectory/HealthReports -Filter "*.htm" | Sort-Object LastWriteTime -Descending | Select-Object -First 1


if (-not $latestReportFile) {

    Write-Host "No HTML report found in $reportDirectory."

    exit

}


# Full path to the latest report

$reportPath = $latestReportFile.FullName

Write-Host "Attaching report: $reportPath"




# Email configuration

$EmailFrom = "Source Email address"

$EmailTo = "Destination Email address"

$SMTPServer = "SMTP Server"

$SMTPPort = port number (default 25)

$Subject = "SDDC Health Report"

$Body = "PLEASE FIND THE ATTACHED SDDC Health Report."


# Send the email with the attachment

try {

    Send-MailMessage -From $EmailFrom `

        -To $EmailTo `

        -Subject $Subject `

        -Body $Body `

        -SmtpServer $SMTPServer `

        -Port $SMTPPort `

        -Attachments $reportPath



    # Delete the report if the email is successfully sent

    if ($?) {

        Remove-Item /tmp/reporting/* -Force -Recurse

    } else {

        Write-Host "Failed to send health report."

    }

} catch {

    Write-Host "Error while sending email: $_"

}
