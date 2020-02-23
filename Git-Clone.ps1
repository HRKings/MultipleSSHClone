Function Git-Clone {
    Param(
        [Parameter(Position = 0, mandatory = $true)]
        [string] $sshKey,
        [Parameter(Position = 1, mandatory = $true)]
        [string] $userName,
        [Parameter(Position = 2, mandatory = $true)]
        [string] $repoName
    )

    $json = $null;
    $path = $PSScriptRoot + "\keys.json";

    if ([System.IO.File]::Exists($path)) {
        $json = (Get-Content ($path) -Raw) | ConvertFrom-Json;

        $email = ${json}.${sshKey}.email;
        $gpg = ${json}.${sshKey}.gpg_id;

        git clone git@${sshKey}:${userName}/${repoName}.git

        if (Test-Path ./${repoName}) {
            Set-Location ./${repoName}

            git config --add user.email $email | Out-Null

            if ((git config --get user.email) -eq $email) {
                Write-Host "Added email : '$email' to the repository";
            }
            else {
                Write-Host "Failed to add email : '$email' to the repository";
            }
            
            if ($gpg -ne "") {
                git config --add user.signingkey $gpg | Out-Null

                if ((git config --get user.signingkey) -eq $gpg) {
                    Write-Host "Added GPG Key : '$gpg' to the repository";
                }
                else {
                    Write-Host "Failed to add GPG Key : '$gpg' to the repository";
                }
            }
            
        }
        else {
            Write-Host "Failed to clone or locate repository folder";
        }
        
    }
    else {
        Write-Host "Keys JSON config not found in '"$PSScriptRoot"\user.json', aborting";
        Exit-PSHostProcess
    }
}