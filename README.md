# Bootstrap

## Usage

**Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don’t want or need. Don’t blindly use my settings unless you know what that entails. Use at your own risk!

To install these dotfiles without Git (assumed as this this is designed for setting up a new machine):

```bash
# download
cd; curl -L https://github.com/PleaseStopAsking/bootstrap/tarball/main | tar -xzv --strip-components 1

# invoke
./init.sh "gitName" "gitEmail"
```

When complete, there are a handful of remaining tasks left to complete manually until I can automate these as well.

### Sign-in & Configure

- 1Password

- Configure accounts
  - System Preferences > Internet Accounts
    - Apple ID
    - Email Provider
      - enable mail, notes and reminders

- Install SF Mono font
  - <https://developer.apple.com/fonts/>

- Rectangle
  - Import config from [here](/configs/RectangleConfig.json)

- Hidden Bar
  - Move icons as necessary

- Configure misc settings
  - System Preferences > General
    - Prefer Tabs: always
  - Dock & Menu Bar
    - Control Center
  - Extensions
    - Remove unused

- Setup PowerShell

  ```powershell
  ./init.ps1
  ```

- VSCode
  - Sign-in via GitHub to sync settings and extensions

- Docker
  - Sign-in to DockerHub
  - Enable experimental features
  - Enable auto download of updates
  - Enable Compose V2

- Remote Desktop Connection
  - Credentials
  - Gateways
  - Hosts

- Safari
  - Settings
  - Install extensions
    - 1Password
    - Capitol One Eno

- Brave Browser
  - Settings
  - Import Bookmarks
  - Install extensions
    - 1Password
    - My Apps Secure Sign-in Extension
  - Enable SSO
  
    ```bash
    # variables
    DOMAINS="*.example.com, example.okta.com"
    USER="user@example.com"

    # create kerberos ticket
    kinit $USER

    # configure brave allowlists
    defaults write com.brave.Browser AuthNegotiateDelegateAllowlist $DOMAINS
    defaults write com.brave.Browser AuthServerAllowlist $DOMAINS
    ```

- Setup Azure access

  ```powershell
  Connect-AzAccount

  # rename contexts to easier to use names as necessary
  Rename-AzContext -SourceName 'preChange' -TargetName 'postChange'

  ```

- Setup AWS access

  ```powershell
  # create profiles for each environment/account
  Set-AWSCredential -AccessKey ExampleAccessKey -SecretKey ExampleSecretKey -StoreAs <program_account_user>
  ```

- Setup Postman
  - Export data dump from existing setup
  - Import into new system

- Setup RDM
  - Export connections from existing setup
  - Import into new system
