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

- Install software
  - sops@v3.7.3 (`work only`)

- Configure accounts
  - System Preferences > Internet Accounts
    - Apple ID
    - Email Provider
      - enable mail only

- Install SF Mono font
  - <https://developer.apple.com/fonts/>

- Itsycal
  - Launch at Login
  - First day of week: `Monday`
  - Hide Icon
  - Format: `E MMM d h:mm a`

- Configure misc settings
  - Finder
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

- Safari
  - Settings

- Setup Azure access (`work only`)

  ```powershell
  Connect-AzAccount

  # rename contexts to easier to use names as necessary
  Rename-AzContext -SourceName 'preChange' -TargetName 'postChange'

  ```

- Setup SSH Key (`only required if a new key is needed`)
  - Create a new SSH key-pair
  - Upload key to GitHub
  - Copy key to each host its needed on
  
    ```bash
    # uses -f as ssh-copy-id can fail if matching private key is not found beside public key
    ssh-copy-id -f -i ~/Downloads/personal.pub user@host
    ```

  - Delete local copy of public key from new system
  - Configure `~/.ssh/config`

    ```bash
    # remove all leading whitespace from last line when copying into terminal or will fail
    tee ~/.ssh/config <<EOF
    Host *
      AddKeysToAgent yes
      UseKeychain yes
      IdentityFile ~/.ssh/id_ed25519
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
