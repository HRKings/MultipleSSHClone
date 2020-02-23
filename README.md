# Multiple SSH Git

This is a small set of script utilities to manage a repository with a specific git SSH key, email and GPG key

You only need to execute the script (assuming that your execution policies allow that) or copy and paste the contents of the scripts to your PowerShell profile, which I find easier and recommend, for the examples I will be using this method, so I don't have to type the path to the individual scripts

You will need a keys.json in the same folder that your scripts are, following the structure:
```JSON
{
    "<SSH_KEY_NAME>" : {
        "email" : "<YOUR_EMAIL>",
        "gpg_id" : "<YOUR_GPG_ID>"
    }
}
```
Just add more than one SSH key name and you are all set up. The SSH key name should be the same in your config file in ~/.ssh, if you don't use GPG, just leave an empty string and the script will ignore it

The ~/.ssh config file should be structure as follows:
```
# Account 1
Host <SSH_KEY_NAME>
 HostName <GIT_HOST>
 User git
 IdentitiesOnly yes
 IdentityFile <PATH_TO_YOUR_SSH_KEY>
```
Obs.: The GIT_HOST needs to be a git host provider like *github*.*com* for example

Add more than one block like the this and you are ready to use the scripts

## Initializing

To initialize a repository is very simple, first you will need to have the repository already created in your host, like GitHub for example, and second you will need to navigate to the folder where the repository will be initialized and issue the following command:

```powershell
PS:\> Git-Init <SSH_KEY_NAME> <GIT_USER> <REPO_NAME>
```

For example:
```powershell
PS:\> Git-Init personal_github HRKings MultipleSSHGit
```

This will clone the repository, add the GPG key if you have one, and add the origin url from the user *HRKings* and repository *MultipleSSHGit* automatically

Now you can use it normally and even do a commit without having to configure the origin first

## Cloning

```powershell
PS:\> Git-Clone <SSH_KEY_NAME> <GIT_USER> <REPO_NAME>
```

For example:
```powershell
PS:\> Git-Clone personal_github HRKings MultipleSSHClone
```

This will clone the repository named *MultipleSSHClone* from the user *HRKings* using the SSH key named *personal_github*, it will automatically navigate to the freshly cloned repository folder and add your email and GPG key (if you have one)