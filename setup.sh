#!/usr/bin/env bash
#
# setup.sh
#
# This script will:
#   1. Prompt for username, password, SSH port, and a public key.
#   2. Create that user (with sudo privileges) and set the same password for root.
#   3. Disable systemd socket for ssh (if enabled) and configure ssh to:
#      - Use the specified port
#      - Install the provided public key
#      - Disable password authentication
#      - Disallow root login
#   4. Test SSH configuration with `sshd -t`. Revert if invalid.
#   5. Install Docker + Git/Vim/Tmux. Add the new user to the docker group.
#   6. Copy local .tmux.conf, .vimrc, .vimrc.plug (if present) into the user's home directory.
#   7. Install Tmux Plugin Manager (TPM) and Vim-Plug.
#   8. Provide final instructions.
#

set -e  # Exit immediately on any error

#######################################
# 1. Ensure the script is run as root
#######################################
if [[ $EUID -ne 0 ]]; then
  echo "Please run as root (or use sudo)."
  exit 1
fi

#######################################
# 2. Prompt for required inputs
#######################################
read -p "Enter the username to create: " TARGET_USER

read -s -p "Enter password for user '$TARGET_USER' (and root): " USERPASS
echo
read -s -p "Confirm password: " USERPASS_CONFIRM
echo
if [[ "$USERPASS" != "$USERPASS_CONFIRM" ]]; then
  echo "Passwords do not match. Exiting."
  exit 1
fi

read -p "Enter the SSH port to use: " SSH_PORT

read -p "Enter the public key for $TARGET_USER: " PUBLIC_KEY

#######################################
# 3. Create user if it doesn't exist
#######################################
if ! id -u "$TARGET_USER" &>/dev/null; then
  echo "Creating user '$TARGET_USER'..."
  adduser --gecos "" --disabled-password "$TARGET_USER"
fi

# Set password for the new user
echo "$TARGET_USER:$USERPASS" | chpasswd

# Add to sudo group
usermod -aG sudo "$TARGET_USER"

# Set root password to the same
echo "root:$USERPASS" | chpasswd

#######################################
# 4. SSH Configuration
#######################################
echo "Configuring SSH..."

SSH_CONFIG="/etc/ssh/sshd_config"
TIMESTAMP="$(date +%F-%T)"
SSH_BACKUP="${SSH_CONFIG}.bak.${TIMESTAMP}"

# 4.1 Disable socket-based SSH if enabled, enable ssh.service
if systemctl is-enabled ssh.socket &>/dev/null; then
  echo "Disabling socket-based SSH..."
  systemctl disable --now ssh.socket
  systemctl enable --now ssh
fi

# 4.2 Backup current sshd_config
cp "$SSH_CONFIG" "$SSH_BACKUP"
echo "Backed up $SSH_CONFIG to $SSH_BACKUP"

# 4.3 Change the SSH port
if grep -Eq "^[#]*\s*Port\s+22" "$SSH_CONFIG"; then
  sed -i "s|^[#]*\s*Port\s\+22|Port $SSH_PORT|g" "$SSH_CONFIG"
else
  if grep -Eq "^[#]*\s*Port\s+" "$SSH_CONFIG"; then
    sed -i "s|^[#]*\s*Port\s\+.*|Port $SSH_PORT|g" "$SSH_CONFIG"
  else
    echo "Port $SSH_PORT" >> "$SSH_CONFIG"
  fi
fi

# Disable password authentication
sed -i 's/^[#]*\s*PasswordAuthentication\s\+yes/PasswordAuthentication no/g' "$SSH_CONFIG"
if ! grep -q "^PasswordAuthentication no" "$SSH_CONFIG"; then
  echo "PasswordAuthentication no" >> "$SSH_CONFIG"
fi

# Disable root login
sed -i 's/^[#]*\s*PermitRootLogin\s\+.*/PermitRootLogin no/g' "$SSH_CONFIG"
if ! grep -q "^PermitRootLogin no" "$SSH_CONFIG"; then
  echo "PermitRootLogin no" >> "$SSH_CONFIG"
fi

# Enable pubkey authentication
sed -i 's/^[#]*\s*PubkeyAuthentication\s\+.*/PubkeyAuthentication yes/g' "$SSH_CONFIG"
if ! grep -q "^PubkeyAuthentication yes" "$SSH_CONFIG"; then
  echo "PubkeyAuthentication yes" >> "$SSH_CONFIG"
fi

#######################################
# 4.4 Add the user's public key
#######################################
USER_HOME="/home/$TARGET_USER"

echo "Adding public key to $USER_HOME/.ssh/authorized_keys..."
mkdir -p "$USER_HOME/.ssh"
chmod 700 "$USER_HOME/.ssh"
# Append the provided public key
echo "$PUBLIC_KEY" >> "$USER_HOME/.ssh/authorized_keys"
chmod 600 "$USER_HOME/.ssh/authorized_keys"
chown -R "$TARGET_USER":"$TARGET_USER" "$USER_HOME/.ssh"

#######################################
# 5. Test new SSH configuration
#######################################
echo "Testing new SSH configuration with 'sshd -t'..."
if ! sshd -t; then
  echo "SSH configuration test FAILED. Reverting to backup."
  mv "$SSH_BACKUP" "$SSH_CONFIG"
  exit 1
fi

echo "SSH configuration is valid. Removing backup..."
rm -f "$SSH_BACKUP"

# Restart SSH with the new settings
systemctl restart ssh
echo "SSH restarted successfully with port $SSH_PORT."

#######################################
# 6. Install Docker + dependencies
#######################################
echo "Installing Docker, Git, Vim, Tmux..."

apt-get update -y
apt-get install -y curl git vim tmux

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Add user to docker group
usermod -aG docker "$TARGET_USER"

rm -f get-docker.sh
echo "Docker installation complete."

#######################################
# 7. Copy config files (.tmux.conf, .vimrc, .vimrc.plug)
#    if present, into $TARGET_USER's home
#######################################
echo "Setting up config files for '$TARGET_USER'..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# .tmux.conf
if [[ -f "$SCRIPT_DIR/.tmux.conf" ]]; then
  cp "$SCRIPT_DIR/.tmux.conf" "$USER_HOME/.tmux.conf"
  chown "$TARGET_USER":"$TARGET_USER" "$USER_HOME/.tmux.conf"
  echo "Copied .tmux.conf to $USER_HOME/.tmux.conf"
else
  echo "Warning: .tmux.conf not found in the current directory."
fi

# .vimrc
if [[ -f "$SCRIPT_DIR/.vimrc" ]]; then
  cp "$SCRIPT_DIR/.vimrc" "$USER_HOME/.vimrc"
  chown "$TARGET_USER":"$TARGET_USER" "$USER_HOME/.vimrc"
  echo "Copied .vimrc to $USER_HOME/.vimrc"
else
  echo "Warning: .vimrc not found in the current directory."
fi

# .vimrc.plug (optional)
if [[ -f "$SCRIPT_DIR/.vimrc.plug" ]]; then
  cp "$SCRIPT_DIR/.vimrc.plug" "$USER_HOME/.vimrc.plug"
  chown "$TARGET_USER":"$TARGET_USER" "$USER_HOME/.vimrc.plug"
  echo "Copied .vimrc.plug to $USER_HOME/.vimrc.plug"
else
  echo "Warning: .vimrc.plug not found in the current directory."
fi

#######################################
# 8. Install Tmux Plugin Manager (TPM) & Vim-Plug for user
#######################################
echo "Installing Tmux Plugin Manager and Vim-Plug for '$TARGET_USER'..."

# Tmux Plugin Manager (TPM)
sudo -u "$TARGET_USER" git clone https://github.com/tmux-plugins/tpm "$USER_HOME/.tmux/plugins/tpm" || true

# Vim-Plug
sudo -u "$TARGET_USER" bash -c "curl -fLo $USER_HOME/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" || true

#######################################
# 9. Final instructions
#######################################
echo "-----------------------------------------------"
echo "Setup complete!"
echo
echo " - User '$TARGET_USER' has sudo privileges."
echo " - SSH is on port $SSH_PORT, root login/password auth disabled."
echo " - Docker is installed; '$TARGET_USER' is in the docker group."
echo " - .tmux.conf, .vimrc, and optional .vimrc.plug are in $USER_HOME."
echo " - Tmux Plugin Manager (TPM) and Vim-Plug have been installed."
echo
echo "Next steps for '$TARGET_USER':"
echo "1) Switch to user '$TARGET_USER':  sudo su - $TARGET_USER"
echo "2) In Vim, install or update plugins:"
echo "   vim"
echo "   :PlugUpdate"
echo
echo "3) In Tmux, install plugins:"
echo "   tmux"
echo "   (Press Ctrl + a + I to install plugins.)"
echo
echo "4) To reload tmux.conf, press Ctrl + a + r or run:"
echo "   tmux source ~/.tmux.conf"
echo "-----------------------------------------------"
