Function Git-Set-Keys {
    Param(
        [Parameter(Position = 0, mandatory = $true)]
        [string] $keyName,
        [Parameter(Position = 1, mandatory = $false)]
        [string] $userName,
        [Parameter(Position = 2, mandatory = $false)]
        [string] $repoName
    )

    $json = $null;
    $path = $PSScriptRoot + "\keys.json";

    if ([System.IO.File]::Exists($path)) {
        $json = (Get-Content ($path) -Raw) | ConvertFrom-Json;

        $email = ${json}.${keyName}.email;
        $gpg = ${json}.${keyName}.gpg_id;

        git config --unset user.email | Out-Null
        git config --add user.email $email | Out-Null

        if ((git config --get user.email) -eq $email) {
            Write-Host "Added email : '$email' to the repository";
        }

        if( ($userName -ne "") -or ($repoName -ne "") ){
            git remote remove origin | Out-Null
            git remote add origin git@${keyName}:${userName}/${repoName}.git
    
            if ((git remote get-url --all origin) -eq "git@${keyName}:${userName}/${repoName}.git") {
                Write-Host "Added remote origin : 'git@${keyName}:${userName}/${repoName}.git' to the repository";
            }
        }
        
            
        if ($gpg -ne "") {
            git config --unset user.signingkey | Out-Null
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