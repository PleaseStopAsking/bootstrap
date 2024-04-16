# Bootstrap

## Usage

**Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don’t want or need. Don’t blindly use my settings unless you know what that entails. Use at your own risk!

To install these dotfiles without Git (assumed as this this is designed for setting up a new machine):

```bash
# download
cd; curl -L https://github.com/PleaseStopAsking/bootstrap/tarball/main | tar -xzv --strip-components 1

# invoke for personal machine
./init.sh "configs/brewfile-personal" "Michael Hatcher" "replaceme@example.com" "Michael MacBook Air"

# invoke for work machine
./init.sh "configs/brewfile-work" "Michael Hatcher" "mhatcher@esri.com"
```

When complete, there are a handful of remaining tasks left to complete manually until I can automate these as well.

### Sign-in & Configure

- 1Password

- Configure accounts
  - System Preferences > Internet Accounts
    - Apple ID
    - Email Provider
      - enable mail only

- Install SF Mono font
  - <https://developer.apple.com/fonts/>

- Rectangle
  - Import config from [here](/configs/RectangleConfig.json)

- Hidden Bar
  - Move icons as necessary
  - Launch at Login

- Itsycal
  - Launch at Login
  - First day of week: `Monday`
  - Hide Icon
  - Format: `E MMM d h:mm a`

- Configure misc settings
  - Finder
    - Always open in list view: `Enabled`
    - Browser in list view: `Enabled`
    - Calculate all sizes: `Enabled`
    - Use as Defaults: `True`
    - Sidebar Items
      - Favorites
        - Applications
        - Documents
        - Downloads
        - Movies
        - Music
        - Pictures
      - iCloud
        - iCloud Drive
        - Shared
      - Locations
        - Connected Servers
  - Control Center
    - Menu Bar Only
      - Clock
        - Show Date: `Never`
        - Show the day of the week: `Disabled`
        - Style: `Analog`
      - Spotlight
        - `Don't Show in Menu Bar`
    - Recent documents, applications, and servers: `None`
  - Desktop & Dock
    - Widgets
      - Show Widgets: `Disabled`
    - Windows
      - Prefer tabs when opening documents: `always`
  - Lock Screen
    - Require password after screen saver begins or display is turned off: `Immediately`

- Setup PowerShell (`work only`)

  ```powershell
  ./init.ps1
  ```

- VSCode
  - Sign-in via GitHub to sync settings and extensions

- Docker
  - Sign-in to DockerHub
  - Settings
    - General
      - Start Docker Desktop when you sign in to your computer: `Disabled`
      - Open Docker Dashboard when Docker Desktop starts: `Disabled`
      - Send usage statistics: `Disabled`
    - Resources
      - CPU Limit: `4`
      - Memory Limit: `4GB`
      - Swap: `1GB`
    - Software Updates
      - Automatically check for updates: `Enabled`
      - Always download updates: `Enabled`
    - Notifications: `Disabled`

- Remote Desktop Connection (`work only`)
  - Credentials
  - Gateways
  - Hosts

- Safari
  - Settings

- Setup Azure access (`work only`)

  ```powershell
  Connect-AzAccount

  # rename contexts to easier to use names as necessary
  Rename-AzContext -SourceName 'preChange' -TargetName 'postChange'

  ```

- Setup AWS access (`work only`)

  ```powershell
  # create profiles for each environment/account
  Set-AWSCredential -AccessKey ExampleAccessKey -SecretKey ExampleSecretKey -StoreAs <program_account_user>
  ```

- Setup Postman (`work only`)
  - Export data dump from existing setup
  - Import into new system

- Setup SSH Key (`only required if a new key is needed`)
  - Create a new SSH key-pair in 1Password
  - Export the public key to your local machine and rename it to something more descriptive
  - Upload key to GitHub
  - Copy key to each host its needed on
  
    ```bash
    # uses -f as ssh-copy-id can fail if matching private key is not found beside public key
    ssh-copy-id -f -i ~/Downloads/personal.pub user@host
    ```

  - Delete local copy of public key from new system
  - Enable 1Password SSH Agent
  - Configure `~/.ssh/config`

    ```bash
    # remove all leading whitespace from last line when copying into terminal or will fail
    tee ~/.ssh/config <<EOF
    Host *
      IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      ServerAliveInterval 60
      ServerAliveCountMax 240
    
    Host exampleName01
      HostName 192.168.4.46
      User foo
      ForwardAgent yes

    Host exampleName02
      HostName 192.168.4.71
      User foo
      ForwardAgent yes
    EOF
    ```
