Function Git-Init {
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

        git init

        git config --add user.email $email | Out-Null

        if ((git config --get user.email) -eq $email) {
            Write-Host "Added email : '$email' to the repository";
        }

        git remote add origin git@${sshKey}:${userName}/${repoName}.git

        if ((git remote get-url --all origin) -eq "git@${sshKey}:${userName}/${repoName}.git") {
            Write-Host "Added remote origin : 'git@${sshKey}:${userName}/${repoName}.git' to the repository";
        }
            
        if ($gpg -ne "") {
            git config --add user.signingkey $gpg | Out-Null

            if ((git config --get user.signingkey) -eq $gpg) {
                Write-Host "Added GPG Key : '$gpg' to the repository";
            }
        }
    
    }
    else {
        Write-Host "Keys JSON config not found in '"$PSScriptRoot"\user.json', aborting";
        Exit-PSHostProcess
    }
}