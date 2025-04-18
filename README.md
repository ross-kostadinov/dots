# Ubuntu System Setup Script

A Bash script to automate the setup of an Ubuntu server with secure SSH settings, Docker, Vim, Tmux, and plugin managers. It **prompts** you for a username, password, SSH port, and public key during installation.

## Features

1. **User Creation**

    - Prompts for a **new username** (with sudo privileges)
    - Sets the **same password** for that user and `root`
    - Disables password-based SSH logins once the script completes

2. **SSH Configuration**

    - Prompts for an **SSH port** (defaults to 22 if not provided, though you can enter any port)
    - **Disables** socket-based SSH activation if present, in favor of the ssh.service
    - Backs up and edits `/etc/ssh/sshd_config` to:
        - Use your specified SSH port
        - Disable **root login**
        - Disable **password authentication**
        - Enable **public key authentication**
    - Installs the **public key** you provide for the new user
    - **Validates** the new SSH config (`sshd -t`) before restarting, reverting to the backup if invalid

3. **Docker Installation**

    - Uses the official Docker convenience script from `get.docker.com`
    - Installs Docker, Git, Vim, and Tmux
    - Adds the new user to the `docker` group

4. **Vim & Tmux Setup**

    - Copies any local `.tmux.conf`, `.vimrc`, and (optionally) `.vimrc.plug` from the same directory as the script into the new user’s home directory
    - Installs the [Tmux Plugin Manager (TPM)](https://github.com/tmux-plugins/tpm)
    - Installs [Vim-Plug](https://github.com/junegunn/vim-plug) in the user’s `~/.vim/autoload/`

5. **Automatic Cleanup/Validation**
    - Removes the SSH backup only if the test passes
    - Halts and reverts the config if the SSH test fails

## Requirements

- **Ubuntu** (tested on recent LTS, but should work on other Debian-based distros)
- **Root** or **sudo** privileges
- **Internet connectivity** (the script downloads Docker, Tmux/Vim plugin managers, etc.)

## Usage

1. **Clone** the repository or download the script and place it in a directory, optionally alongside any configuration files (`tmux.conf`, `vimrc`, `.vimrc.plug`):

    ```bash
    git clone https://github.com/your-username/your-repo.git
    cd your-repo
    ```

2. **Make the script executable**:

    ```bash
    chmod +x setup.sh
    ```

3. **Run the script** as root or with sudo:

    ```bash
    sudo ./setup.sh
    ```

4. **Follow the prompts**:

    - **Username**: Choose the name of the new sudo user.
    - **Password**: Enter (and confirm) the password for that new user. The same password applies to the `root` account.
    - **SSH Port**: Specify a port to use for SSH (e.g., 6066).
    - **Public Key**: Paste your **SSH public key** for secure key-based logins.

5. **Wait** for the script to finish. It will install Docker, Git, Vim, Tmux, configure SSH, and place your config files in `/home/<new_user>`.

6. **Switch to the new user** and **complete** Tmux & Vim plugin setups:
    ```bash
    sudo su - <new_user>
    ```
    - In **Vim**: Run `:PlugUpdate` (or `:PlugInstall`) to fetch any plugins defined in `.vimrc` (and `.vimrc.plug`, if you’re splitting configs).
    - In **Tmux**: Press **Ctrl + a + I** (that is, hold `Control`, press `a`, then `I`) to install plugins.
        - Reload Tmux config with **Ctrl + a + r** or `tmux source ~/.tmux.conf`.

## Usage (Only copy configs)

**Vim**

- Install Vim-Plug plugin manager:

1. Download **Vim-Plug**

    ```bash
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    ```

2. Enter Vim with **vim** and type:
    ```bash
    :PlugUpdate
    ```

**Tmux**

- Install Tmux plugin manger:

1. Clone **TPM**

    ```bash
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ```

2. Install the plugins

    - Enter Tmux with **tmux** and inside press **Ctrl + a + I**

3. Source the config file (.tmux.conifg)
    - Use **Ctrl + a + r** or type:
    ```bash
    tmux source ~/.tmux.conf
    ```

## Notes & Warnings

- **SSH Changes**:

    - This script **disables password authentication** in SSH and **disallows root login** by default.
    - If you rely on password logins, ensure you **keep your newly created user’s SSH key** safe.
    - Make sure your **firewall** or **cloud security group** is configured to allow the new SSH port you specified.

- **Security Implications**:

    - By publishing your script publicly, note that if you include a public key, anyone can see it. Using your own private key for access is fine (public keys are, by nature, public). If you want to keep your key private, do **not** commit it here.

- **Review Before Production**:
    - This script makes significant changes (installing packages, altering SSH configuration). Always review it and test on a non-production server if you’re unsure.

## Troubleshooting

- **SSH Service Fails to Restart**:

    - The script will revert to the original config if `sshd -t` reports an error.
    - Check `/etc/ssh/sshd_config.bak.<timestamp>` or run `journalctl -xeu ssh`.

- **Plugin Issues**:
    - **Vim**: Check `~/.vim/plugged` for installed plugins; ensure your `.vimrc` references them correctly.
    - **Tmux**: Plugins install in `~/.tmux/plugins/`; see logs if an installation fails.

## Contributing

1. **Fork** the repo.
2. **Create** a new feature branch: `git checkout -b feature/something`
3. **Commit** your changes.
4. **Push** to your fork: `git push origin feature/something`
5. **Open** a pull request on GitHub.

## License

(Include a license here, e.g., MIT, Apache 2.0, GPL)
