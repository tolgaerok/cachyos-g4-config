#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
# PS1='[\u@\h \W]\$ '
# ----------- MY CUSTOM ALIAS  ---------------------------------------------------------------------------------------------------------------

BLUE='\033[0;34m'
BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
MAGENTA='\033[0;35m'
NC='\033[0m'
RED='\033[0;31m'
RESET='\033[0m'
YELLOW='\033[0;33m'

# ----- CUSTOM PATHS ------------
export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.npm-global/bin:/usr/games:$PATH"

export LANG=en_AU.utf8
export LANGUAGE=en_AU
export LC_ALL=en_AU.utf8

export PATH=$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH
#source /etc/profile.d/nix.sh
#. /etc/profile.d/nix.sh

# ----- CUSTOM TERMINAL EYE CANDY ---------------------------------------------------
PS1="\[\e[1;m\]┌(\[\e[1;32m\]\u\[\e[1;34m\]@\h\[\e[1;m\]) \[\e[1;m\]➤\[\e[1;36m\] \W \[\e[1;m\] \n\[\e[1;m\]└\[\e[1;33m\]\[\e[5m\]➤\[\e[0m\]  "

banner() {
  clear
  printf "\n%.0s" {1..1}
  echo -e "\e[33m
   _     _                  _____                    _
  | |   (_)_ __  _   ___  _|_   _|_      _____  __ _| | _____
  | |   | | '_ \| | | \ \/ /+| | \ \ /\ / / _ \/ _\` | |/ / __|
  | |___| | | | | |_| |>  < +| |  \ V  V /  __/ (_| |   <\____\

  |_____|_|_| |_|\__,_/_/\_\+|_|   \_/\_/ \___|\__,_|_|\_\___/\e[0m
\e[32m ══════════════════════════════════════════════════════════════════
 ║                       By Tolga Erok                            ║
 ══════════════════════════════════════════════════════════════════
 \e[0m"
}

# SSH Agent
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)" >/dev/null
  ssh-add ~/.ssh/id_ed25519 2>/dev/null
fi


# Browser cache tmpfs aliases
alias chrome='/usr/bin/google-chrome-stable --disk-cache-dir=/tmp/chrome-cache'
alias chromium='/usr/bin/chromium --disk-cache-dir=/tmp/chromium-cache'
alias brave='/usr/bin/brave --disk-cache-dir=/tmp/brave-cache'



alias scrub='
sudo -v && \
echo -e "${YELLOW}\n─── 🔍 Starting Btrfs Scrub... ───────────────────────────────────────────────${NC}" && \
sudo btrfs scrub start -B / && echo "✅ Scrub done." && \
echo -e "${YELLOW}\n─── 🔄 Running Btrfs Balance (dusage=75, musage=75)... ─────────────────────────────${NC}" && \
sudo btrfs balance start -dusage=75 -musage=75 -v / && echo "✅ Balance done." && \
echo -e "${YELLOW}\n─── ✂️ Trimming Filesystems... ─────────────────────────────────────────────────${NC}" && \
sudo fstrim -av && echo "🚀 Trim completed."
'

# alias chrome='google-chrome --disk-cache-dir=/tmp/chrome-cache'
alias nv-yad='cd "/home/tolga/Documents/MEGA/Documents/LINUX/fedora/RPM-BIILD/rpmbuild/SCRIPTS/YAD scripts/" && clear && sudo ./yad-nvidia.sh'
alias po-yad='cd "/home/tolga/Documents/MEGA/Documents/LINUX/fedora/RPM-BIILD/rpmbuild/SCRIPTS/YAD scripts/" && clear && sudo ./yad-post.sh'
alias exe='echo "🔍 Scanning for script files in: $(pwd)" && \
find . -type f \( -name "*.sh" -o -name "*.bash" -o -name "*.service" -o -name "*.timer" -o -name "*.conf" -o -name "*.nix" -o -name "*.txt" \) -print0 | \
while IFS= read -r -d "" file; do
  echo "⚙️  Making executable: $file"
  chmod +x "$file"
done'

alias grub="sudo grub2-mkconfig -o /boot/grub2/grub.cfg"
alias lt="{
  echo '🔧 Enabling USER services/timers...';
  systemctl --user list-unit-files | grep -Ei 'linuxtweaks?|LinuxTweaks?' | awk '{print \$1}' | while read -r unit; do
    echo \"→ Enabling user unit: \$unit\";
    systemctl --user enable --now \"\$unit\";
  done;
  echo '🔧 Enabling SYSTEM services/timers...';
  systemctl list-unit-files | grep -Ei 'linuxtweaks?|LinuxTweaks?' | awk '{print \$1}' | while read -r unit; do
    echo \"→ Enabling system unit: \$unit\";
    sudo systemctl enable --now \"\$unit\";
  done;
  echo '✅ Done.';
}"

alias qnap-test='sshpass -p "ibm450" ssh admin@192.168.0.17 "hostname && whoami && df -h"'
alias qnap='sshpass -p "ibm450" ssh admin@192.168.0.17'
alias scloud='cd Music/SOUNDCLOUD && f() { scdl -l "https://soundcloud.com/$1"; }; f'
alias tolga-fstab="sudo mount -a && sudo systemctl daemon-reload && echo && echo \"Reloading of fstab done\" && echo"
alias mexe='while IFS= read -r -d $'\''\0'\'' f; do
  firstline=$(head -n1 "$f" 2>/dev/null | tr -d "\0")
  if [[ "$firstline" == \#!* ]]; then
    chmod +x "$f"
    printf "\e[1;32m✔\e[0m Made executable: \e[1;33m%s\e[0m\n" "$f"
  fi
done < <(find . -type f -print0)'

alias fastfetch='ff_logo=$(find $HOME/.config/fastfetch/logo/* | /usr/bin/shuf -n 1) && /usr/bin/fastfetch --logo $ff_logo -c $HOME/.config/fastfetch/config.jsonc'

#--- YAD Helper Function ---#
fancy() {
  yad --center --width=400 --height=120 --window-icon=dialog-information --borders=10 \
    --title="LinuxTweaks NVIDIA Installer" --text="$1" --button=gtk-ok:0 --no-buttons &
  YAD_PID=$!
  bash -c "$2"
  kill $YAD_PID
}

# --- Service Status Check ---
check2() {
  # Colors
  RED='\033[0;31m'
  YELLOW='\033[1;33m'
  BLUE='\033[0;34m'
  NC='\033[0m' # No Color

  # Find active network interface (prioritizing wireless or ethernet)
  interface=$(ip -o link show | awk -F': ' '$2 ~ /^(wlp|wlo|wlx|eth|eno)/ && $0 ~ /state UP/ && $0 !~ /NO-CARRIER/ {print $2; exit}')

  if [[ -z "$interface" ]]; then
    echo -e "${RED}Error: No active network interface detected!${NC}"
    return 1
  fi

  echo -e "${BLUE}Restarting CAKE qdisc for interface: ${YELLOW}$interface${NC}"

  echo -e "${BLUE}Verifying qdisc configuration for ${YELLOW}$interface${NC}"
  sudo tc -s qdisc show dev "$interface"

  echo -e "${BLUE}Systemd service statuses:${NC}"
  echo -e "${YELLOW}\n ─── Timers ───────────────────────────────────────────────────${NC}"

  # Check linuxtweaks-flatpak.timer (user)
  timer_line=$(systemctl --user list-timers --no-pager --all | grep linuxtweaks-flatpak.timer || true)
  if [[ -n "$timer_line" ]]; then
    read -r _ next_date next_time _ next_in _ timer_name triggered_service <<<"$timer_line"

    echo -e "${BLUE}  ⏰ Timer:${NC} ${YELLOW}$timer_name (user)${NC}"
    echo -e "${BLUE}  ⏳ Next run:${NC} $next_date $next_time ( ${YELLOW}$next_in${NC} left )"
    echo -e "${BLUE}  🔧 Triggers service:${NC} ${YELLOW}$triggered_service${NC}"
  else
    echo -e "${RED}  ⚠️ No linuxtweaks-flatpak.timer (user) found.${NC}"
  fi

  echo -e "${YELLOW}───────────────────────────────────────────────────────────────${NC}\n"

  # Services and timers to check
  # Format: name:scope (scope = user or system)
  declare -A units=(
    [linuxTweaks - autostart.service]="system"
    [linuxtweaks - cake - resume.service]="system"
    [linuxtweaks - cake.service]="system"
    [linuxtweaks - flatpak.service]="user"
    [linuxtweaks - flatpak.timer]="user"
    [my - preload.service]="system"
    [ntp - check.service]="system"
    [ntp - check.timer]="system"
    [ntp - check - timer - restart.service]="system"
    [preload.service]="system"
    [wsdd - sleep.service]="system"
    [wsdd - starter.service]="system"
    [wsdd.service]="system"
  )

  for service in "${!units[@]}"; do
    scope="${units[$service]}"
    echo -e "${BLUE}Status of ${YELLOW}${service}${NC} (${scope} level)"
    echo -e "${YELLOW}───────────────────────────────────────────────────────────────${NC}"

    if [[ "$scope" == "user" ]]; then
      systemctl --user status "$service" --no-pager
    else
      sudo systemctl status "$service" --no-pager
    fi
    echo ""
  done
}

perm() {
  banner
  MEGA_DIR="/home/tolga/Documents/MEGA"
  USER="tolga"
  GROUP="tolga"

  notify() {
    /usr/bin/notify-send "MEGAsync Setup" "$1" \
      --app-name="MEGA Service" \
      -i mega
    echo -e "\e[1;32m[✔] $1\e[0m"
  }

  echo -e "\e[1;34m=== MEGA Directory Preparation ===\e[0m"

  # Step 1: Create directory if missing
  if [ ! -d "$MEGA_DIR" ]; then
    mkdir -p "$MEGA_DIR"
    notify "Created MEGA directory at $MEGA_DIR"
  else
    notify "MEGA directory already exists"
  fi

  # fix ownership
  sudo chown -R "$USER:$GROUP" "$MEGA_DIR"
  notify "Ownership set to $USER:$GROUP"

  # fix permissions
  chmod -R 774 "$MEGA_DIR"
  notify "Permissions locked down to (774)"

  echo -e "\e[1;34m=== Preparation Complete brother ===\e[0m"
  notify "MEGA folder is ready for sync! Enjoy"
}

check-io() {
  #!/usr/bin/env bash
  # Tolga Erok
  # Purpose: Check & report SSD/NVMe schedulers in style

  echo -e "\e[1;34m=== IO Scheduler Audit: Aurora, Fedora, NixOS && Mint ===\e[0m"

  for dev in /sys/block/*; do
    name=$(basename "$dev")
    sched_file="$dev/queue/scheduler"

    # Skip loopback, RAM, CD-ROM etc.
    [[ ! -f "$sched_file" ]] && continue

    sched=$(cat "$sched_file")
    active=$(echo "$sched" | grep -oP '\[\K[^\]]+')

    # Highlight if active scheduler is not none
    if [[ "$active" != "none" ]]; then
      echo -e "\e[1;31m$name: active scheduler is '$active', should be none\e[0m"
    else
      echo -e "\e[1;32m$name: active scheduler is 'none' ✅\e[0m"
    fi
  done

  echo -e "\e[1;34m=== Audit Complete ===\e[0m"
}

status3() {
  echo -e "\n\033[1;36m🔍 CChecking NVIDIA-related systemd services...\033[0m\n"
  printf "%-30s %-15s %-25s\n" "Service" "Enabled" "Active State"
  printf "%-30s %-15s %-25s\n" "-------" "-------" "-------------"

  for service in nvidia-persistenced nvidia-suspend nvidia-resume nvidia-hibernate; do
    if systemctl is-enabled --quiet "$service"; then
      enabled="\033[1;32menabled 🟢\033[0m"
    else
      enabled="\033[1;33mdisabled 🟡\033[0m"
    fi

    if systemctl is-active --quiet "$service"; then
      active="\033[5;32mactive 🟢\033[0m"
    else
      type=$(systemctl show -p Type --value "$service")
      if [[ "$type" == "oneshot" ]]; then
        active="\033[1;34moneshot (idle) 📌\033[0m"
      else
        active="\033[1;31minactive ❌\033[0m"
      fi
    fi

    printf "%-30s %-15b %-25b\n" "$service" "$enabled" "$active"
  done

  echo -e "\n\033[1;36m🔧 System & NVIDIA Info:\033[0m"

  # GPU Model
  gpu_model=$(lspci | grep -i vga | grep -i nvidia | sed 's/.*VGA compatible controller: //' | cut -d'[' -f1)

  # Driver Type & Version
  # Detect NVIDIA driver properly
  if lsmod | grep -q '^nvidia'; then
    driver_type="Proprietary NVIDIA (loaded)"
    driver_ver=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader | head -n1)
  elif modinfo nvidia &>/dev/null; then
    driver_type="Proprietary NVIDIA (module present)"
    driver_ver=$(modinfo nvidia | grep ^version: | awk '{print $2}')
  elif modinfo nouveau &>/dev/null; then
    driver_type="Open-source Nouveau"
    driver_ver=$(modinfo nouveau | grep ^version: | awk '{print $2}')
  else
    driver_type="Unknown"
    driver_ver="N/A"
  fi

  kernel_ver=$(uname -r)
  de="${XDG_CURRENT_DESKTOP:-${DESKTOP_SESSION:-${GDMSESSION}}}"
  de=${de,,}
  session_type="${XDG_SESSION_TYPE:-unknown}"
  . /etc/os-release
  os_name_version="$NAME $VERSION"

  # Output system info
  printf "%-30s %s\n" "GPU Model:" "$gpu_model"
  printf "%-30s %s\n" "Driver Type:" "$driver_type"
  printf "%-30s %s\n" "Driver Version:" "$driver_ver"
  printf "%-30s %s\n" "Kernel Version:" "$kernel_ver"
  printf "%-30s %s (%s)\n" "Desktop Env:" "$de" "$session_type"
  printf "%-30s %s\n" "OS:" "$os_name_version"

  # NVIDIA SMI info
  echo -e "\n\033[1;35m━━━━━━━━━━ NVIDIA SMI STATUS ━━━━━━━━━━\033[0m"
  if command -v nvidia-smi &>/dev/null; then
    printf "%-20s %-25s %-10s %-10s %-10s\n" "Driver" " Model" "GPU Load" "Temp °C" "Power W"
    nvidia-smi --query-gpu=driver_version,name,utilization.gpu,temperature.gpu,power.draw \
      --format=csv,noheader,nounits | while IFS=',' read -r drv name util temp watt; do
      printf "%-20s %-25s %-10s %-10s %-10s\n" "$drv" "$name" "$util%" "$temp°C" "$watt W"
    done
  else
    echo -e "\033[1;31m❌ nvidia-smi not available.\033[0m"
  fi

  echo -e "\n\033[0;36m📌 Note: 'oneshot (idle)' means the service triggers during suspend/resume only.\033[0m\n"
}

mynix() {
  echo "🔎 checking nix channels..."

  # check if nixpkgs exists and if multiple entries exist
  channel_count=$(nix-channel --list | grep -c '^nixpkgs ')
  if [ "$channel_count" -ne 1 ]; then
    echo "⚠️  nixpkgs channel missing or duplicated. auto-fixing..."
    nix-channel --remove nixpkgs 2>/dev/null
    rm -rf ~/.nix-defexpr/channels ~/.nix-defexpr/channels_root
    nix-channel --add https://channels.nixos.org/nixpkgs-unstable nixpkgs
  fi

  echo "📦 updating nix channels..."
  if nix-channel --update; then
    echo "🚀 upgrading all nix packages..."
    nix-env -u '*' || echo "⚠️ nix-env upgrade failed"
  else
    echo "⚠️ nix-channel update failed — skipping package upgrade"
  fi

  echo "🧹 cleaning up store..."
  # nix-collect-garbage -d

  echo "✅ mynix complete"
}

upt-1() {
  uptime=$(cut -d ' ' -f 1 /proc/uptime | cut -d '.' -f 1)

  mo=$((uptime / 2592000))
  w=$(((uptime % 2592000) / 604800))
  d=$(((uptime % 604800) / 86400))
  h=$(((uptime % 86400) / 3600))
  m=$(((uptime % 3600) / 60))

  kernel=$(uname -r)
  load=$(cut -d ' ' -f 1-3 /proc/loadavg)
  load1=$(echo $load | cut -d ' ' -f1)

  if (($(echo "$load1 <= 1.0" | bc -l))); then
    load_emoji="🟢 [good]"
  elif (($(echo "$load1 <= 2.0" | bc -l))); then
    load_emoji="🟡 [average]"
  else
    load_emoji="🔴 [slow]"
  fi

  uptime_str=""
  [ $mo -gt 0 ] && uptime_str+="$mo month$([ $mo -ne 1 ] && echo "s" || echo "") "
  [ $w -gt 0 ] && uptime_str+="$w week$([ $w -ne 1 ] && echo "s" || echo "") "
  [ $d -gt 0 ] && uptime_str+="$d day$([ $d -ne 1 ] && echo "s" || echo "") "
  uptime_str+="$h h $m m"

  printf "    🕒 uptime: %s | load avg: %s %s\n" "$uptime_str" "$load" "$load_emoji"
  printf "    🖥️  kernel: %s\n" "$kernel"
  echo

  if command -v lsb_release >/dev/null 2>&1; then
    mint_ver=$(lsb_release -d | cut -f2)
  else
    mint_ver="unknown"
  fi

  echo "    🧭 ubuntu version and cpu architecture:"
  echo "    🐧 $mint_ver "

  cpu_flags=$(grep -m1 'flags' /proc/cpuinfo)
  if [[ $cpu_flags == *"avx2"* && $cpu_flags == *"bmi"* && $cpu_flags == *"fma"* ]]; then
    echo "    ⚙️  cpu supports: amd64v3 (avx avx2 fma bmi) "
  elif [[ $cpu_flags == *"avx"* ]]; then
    echo "    ⚙️  cpu supports: amd64v2 only"
  else
    echo "    ⚙️  cpu supports: baseline amd64 only"
  fi

  echo
}

upt() {
  uptime=$(cut -d ' ' -f 1 /proc/uptime | cut -d '.' -f 1)
  mo=$((uptime / 2592000))
  w=$(((uptime % 2592000) / 604800))
  d=$(((uptime % 604800) / 86400))
  h=$(((uptime % 86400) / 3600))
  m=$(((uptime % 3600) / 60))
  kernel=$(uname -r)
  load=$(cut -d ' ' -f 1-3 /proc/loadavg)
  load1=$(echo $load | cut -d ' ' -f1)
  if (($(echo "$load1 <= 1.0" | bc -l))); then
    load_emoji="🟢 [good]"
  elif (($(echo "$load1 <= 2.0" | bc -l))); then
    load_emoji="🟡 [average]"
  else
    load_emoji="🔴 [slow]"
  fi
  uptime_str=""
  [ $mo -gt 0 ] && uptime_str+="$mo month$([ $mo -ne 1 ] && echo "s" || echo "") "
  [ $w -gt 0 ] && uptime_str+="$w week$([ $w -ne 1 ] && echo "s" || echo "") "
  [ $d -gt 0 ] && uptime_str+="$d day$([ $d -ne 1 ] && echo "s" || echo "") "
  uptime_str+="$h h $m m"
  printf "    🕒 uptime: %s | load avg: %s %s\n" "$uptime_str" "$load" "$load_emoji"
  printf "    🖥️  kernel: %s\n" "$kernel"
  echo

  # Detect OS distribution properly
  if command -v lsb_release >/dev/null 2>&1; then
    os_ver=$(lsb_release -d | cut -f2)
  elif [ -f /etc/os-release ]; then
    os_ver=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d'"' -f2)
  elif [ -f /etc/lsb-release ]; then
    source /etc/lsb-release
    os_ver="$DISTRIB_DESCRIPTION"
  else
    os_ver="unknown"
  fi

  echo "    🧭 OS distribution and cpu architecture:"
  echo "    🐧 $os_ver"
  cpu_flags=$(grep -m1 'flags' /proc/cpuinfo)
  if [[ $cpu_flags == *"avx2"* && $cpu_flags == *"bmi"* && $cpu_flags == *"fma"* ]]; then
    echo "    ⚙️  cpu supports: amd64v3 (avx avx2 fma bmi)"
  elif [[ $cpu_flags == *"avx"* ]]; then
    echo "    ⚙️  cpu supports: amd64v2 only"
  else
    echo "    ⚙️  cpu supports: baseline amd64 only"
  fi
  echo
}

syspec() {
  clear
  echo
  echo "🧭 system overview"
  echo "─────────────────────────────"

  # distro and base
  if command -v lsb_release >/dev/null 2>&1; then
    mint_ver=$(lsb_release -d | cut -f2)
  else
    mint_ver="unknown"
  fi
  echo "🐧 $mint_ver "

  # kernel
  kernel=$(uname -r)
  echo "🖥️  kernel: $kernel"

  # cpu and architecture
  cpu_model=$(grep -m1 'model name' /proc/cpuinfo | cut -d ':' -f2- | xargs)
  cpu_flags=$(grep -m1 'flags' /proc/cpuinfo)
  if [[ $cpu_flags == *"avx2"* && $cpu_flags == *"bmi"* && $cpu_flags == *"fma"* ]]; then
    cpu_arch="⚙️  cpu supports: amd64v3 (avx avx2 fma bmi)"
  elif [[ $cpu_flags == *"avx"* ]]; then
    cpu_arch="⚙️  cpu supports: amd64v2 only"
  else
    cpu_arch="⚙️  cpu supports: baseline amd64 only"
  fi
  echo "🧠 cpu: $cpu_model"
  echo "$cpu_arch"

  # shells and versions
  echo
  echo "💀 shells installed:"
  [ -x "$(command -v bash)" ] && echo "   🌀 bash $(bash --version | head -n1 | awk '{print $4}')"
  [ -x "$(command -v zsh)" ] && echo "   🧩 zsh $(zsh --version | awk '{print $2}')"
  [ -x "$(command -v nix-shell)" ] && echo "   ❄️  nix-shell installed" || echo "   ❄️ nix-shell not found"

  # filesystem info
  echo
  echo "🗂️  filesystem info:"
  df -h --output=source,fstype,size,used,avail,target | awk 'NR==1 || /^\/dev/ {printf "   %-25s %-8s %-6s %-6s %-6s %-s\n",$1,$2,$3,$4,$5,$6}'

  # fstab overview
  echo
  echo "📄 fstab entries:"
  grep -vE '^#|^$' /etc/fstab | awk '{printf "   %-25s %-15s %-10s %-20s\n",$1,$2,$3,$4}'

  # swap
  echo
  echo "💾 swap info:"
  if command -v swapon >/dev/null 2>&1; then
    swapon --show | awk 'NR==1 {printf "   %-25s %-10s %-10s %-5s\n",$1,$2,$3,$4} NR>1 {printf "   %-25s %-10s %-10s %-5s\n",$1,$2,$3,$4}'
  else
    echo "   swapon not found"
  fi

  # zram
  echo
  echo "🌀 zram devices:"
  if command -v zramctl >/dev/null 2>&1; then
    zramctl | awk 'NR==1 {next} {printf "   %-10s %-8s %-8s %-8s %-s\n",$1,$2,$3,$4,$5}'
  else
    echo "   zramctl not available"
  fi

  # block devices
  echo
  echo "🧱 block devices:"
  lsblk -o NAME,TYPE,FSTYPE,SIZE,MOUNTPOINTS | awk '{printf "   %-10s %-8s %-8s %-8s %-s\n",$1,$2,$3,$4,$5}'

  echo
}

clear && echo && fortune | sed "s/^/    /" | lolcat && echo && upt
# check-browser-cache
sysctl (){

sudo sysctl -a | grep -E 'vm.swappiness|vm.vfs_cache_pressure|vm.dirty_|vm.min_free_kbytes|net.core.netdev_max_backlog|net.core.somaxconn|net.core.rmem|net.core.wmem|tcp_rmem|tcp_wmem|tcp_fastopen|tcp_congestion_control|default_qdisc|fs.file-max|inotify|max_user_watches|aio-max-nr|sched_autogroup_enabled'

}

# ═══════════════════════════════════════════════════════════════════════════════
# tmpfs RAM Optimization for LMDE7
# tolga erok
# Updated: 1 December 2025
# Version: 7
# Redirects temp files, caches, and build directories to /tmp (tmpfs in RAM)
# Only includes variables that applications actually respect, well, thats my theory
# ═══════════════════════════════════════════════════════════════════════════════

# ─── Core System Temp ──────────────────────────────────────────────────────────
export TMPDIR=/tmp

# CRITICAL: XDG_CACHE_HOME is NOT set - Cinnamon needs ~/.cache for sessions!
# Setting this breaks suspend/resume!

# ─── Node.js/npm (i have this) ───────────────────────────────────────────────
export npm_config_cache=/tmp/npm-cache

# ─── Python (i have this) ────────────────────────────────────────────────────
export PIP_CACHE_DIR=/tmp/pip-cache

# ─── NVIDIA GPU (i have this) ────────────────────────────────────────────────
export __GL_SHADER_DISK_CACHE_PATH=/tmp/nvidia_shader
export CUDA_CACHE_PATH=/tmp/cuda_cache

# ─── Compression Tools (system-wide) ───────────────────────────────────────────
export GZIP_TMPDIR=/tmp/gzip
export XZ_TMPDIR=/tmp/xz

# ─── Browser Caches ────────────────────────────────────────────────────────────
# Chrome/Firefox: Already configured via desktop launchers
# Currently using: /tmp/chrome-cache and /tmp/firefox-cache

# ─── Create Required Directories ───────────────────────────────────────────────
_create_tmpfs_dirs() {
    local dirs=(
        "$npm_config_cache"
        "$PIP_CACHE_DIR"
        "$__GL_SHADER_DISK_CACHE_PATH"
        "$CUDA_CACHE_PATH"
        "$GZIP_TMPDIR"
        "$XZ_TMPDIR"
        "/tmp/chrome-cache"
        "/tmp/firefox-cache"
        "/tmp/chromium-cache"
        "/tmp/brave-cache"
    )

    for dir in "${dirs[@]}"; do
        [[ -n "$dir" ]] && mkdir -p "$dir" 2>/dev/null && chmod 1777 "$dir" 2>/dev/null
    done
}

# ─── Status Display ────────────────────────────────────────────────────────────
_show_tmpfs_status() {
    [[ $- != *i* ]] && return
    [[ $SHLVL -gt 1 ]] && return

    local BOLD='\033[1m'
    local CYAN='\033[0;36m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[1;33m'
    local RESET='\033[0m'

    echo -e "${BOLD}${CYAN}╔═══════════════════════════════════════════════╗${RESET}"
    echo -e "${BOLD}${CYAN}║ Tolga's tmpfs RAM Optimization (Session-Safe) ║${RESET}"
    echo -e "${BOLD}${CYAN}╚═══════════════════════════════════════════════╝${RESET}"
    echo ""

    printf "${GREEN}%-25s${RESET} %s\n" "System Temp:" "$TMPDIR"
    printf "${GREEN}%-25s${RESET} %s\n" "npm Cache:" "$npm_config_cache"
    printf "${GREEN}%-25s${RESET} %s\n" "Python pip:" "$PIP_CACHE_DIR"
    printf "${GREEN}%-25s${RESET} %s\n" "NVIDIA Shader:" "$__GL_SHADER_DISK_CACHE_PATH"

    echo ""
    printf "${YELLOW}Desktop Cache:${RESET} ~/.cache ${GREEN}(on disk - preserves sessions ✓)${RESET}\n"
    echo ""
    echo -e "${CYAN}tmpfs: ${GREEN}8GB${RESET} | ${CYAN}Usage: ${GREEN}$(df -h /tmp | awk 'NR==2 {print $5}')${RESET}"
    echo -e "${BOLD}${CYAN}════════════════════════════════════════════${RESET}"
}

# ─── Execute ───────────────────────────────────────────────────────────────────
_create_tmpfs_dirs
_show_tmpfs_status
unset -f _create_tmpfs_dirs _show_tmpfs_status

# ═══════════════════════════════════════════════════════════════════════════════
# NOTES: (learnt the hardway)
#
# ✓ XDG_CACHE_HOME is NOT set - this preserves Cinnamon session state
# ✓ Suspend/resume will work correctly
# ✓ Window positions and workspaces will be saved
#
# What's optimized:
#   - npm installs (Node.js packages)
#   - pip installs (Python packages)
#   - NVIDIA shader compilation
#   - Browser caches (Chrome/Firefox)
#   - System compression (gzip/xz)
#
# /tmp is cleared on reboot - never store important files there!
# Current allocation: 8GB (configured in /etc/fstab)
# ═══════════════════════════════════════════════════════════════════════════════

#check-browser-cache

echo "" && echo ""
