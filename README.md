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
- Dozer
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
  - Install extensions
    - 1Password
    - Capitol One Eno
  - Enable SSO
  
      ```bash
      # create kerberos ticket
      init user@example.com

      # configure brave allowlists
      defaults write com.brave.Browser AuthNegotiateDelegateAllowlist "*.example.com, example.okta.com"
      defaults write com.brave.Browser AuthServerAllowlist "*.example.com, example.okta.com"
      ```