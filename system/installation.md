###
### mirrors & update
###

sudo pacman -Syyu

sudo rm /var/lib/pacman/sync/*
sudo pacman-key --init
sudo pacman-key --populate
sudo reboot

###
### clash & proxychains
###

sudo pacman -S clash proxychains

sudo sed -i 's/^socks4.*$/socks5    127.0.0.1 7891/' /etc/proxychains.conf

su root
cat << EOF > /etc/systemd/system/clash.service
[Unit]
Description=Clash service
After=network.target

[Service]
Type=simple
User=$USER
ExecStart=/usr/bin/clash
Restart=on-failure
RestartPreventExitStatus=23

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable clash --now

###
### paru & pacman
###

su root
cat << EOF >> /etc/pacman.conf
[archlinuxcn]
SigLevel = Never
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/\$arch
EOF

sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf
sed -i "s/^#ParallelDownloads = .*$/ParallelDownloads = 5/;s/^#Color$/Color/" /etc/pacman.conf
sed -i "s/-j2/-j$(nproc)/;s/^#MAKEFLAGS/MAKEFLAGS/" /etc/makepkg.conf

# git
git config --global user.name "Wang Zhaohui"
git config --global user.email "18811365389@163.com"

###
### system
###

# tap to click
sudo nvim /etc/X11/xorg.conf.d/30-touchpad.conf

Section "InputClass"
    Identifier "touchpad"
    Driver "libinput"
    MatchIsTouchpad "on"
    Option "Tapping" "on"
    Option "TappingButtonMap" "lmr"
EndSection

## monitors & graphic card
sudo pacman -S nvidia nvidia-settings
paru -S optimus-manager optimus-manager-qt
sudo systemctl enable optimus-manager

su
cat /home/zhao/.local/sysbin/setmonitors >> /etc/optimus-manager/xsetup-nvidia.sh
cat /home/zhao/.local/sysbin/setmonitors >> /etc/optimus-manager/xsetup-integrated.sh
cat /home/zhao/.local/sysbin/setmonitors >> /etc/optimus-manager/xsetup-hybrid.sh

###
### config restore
###

git clone https://github.com/zhao-h2o2/dotfiles --recursive
sudo pacman -S stow
cd dotfiles

## shell & X
sudo pacman -R vim
sudo ln -s /usr/bin/nvim /usr/bin/vim
sudo pamcan -S ranger lazygit neovim fzf fd zsh python-pip exa ripgrep
pip install neovim
chsh -s /usr/bin/zsh

stow shell
stow X11
reboot

## fonts
sudo pacman -S adobe-source-han-serif-cn-fonts adobe-source-han-sans-cn-fonts adobe-source-han-mono-cn-fonts
sudo pacman -S noto-fonts-cjk noto-fonts-emoji noto-fonts-extra

stow fonts

## dwm
sudo pacman -S rofi feh
paru -S polybar-dwm-module
paru -S picom-jonaburg-git

stow rofi polybar scripts dunst

paru -S libxft-bgra
git clone https://github.com/zhao-h2o2/dwm
cd dwm
sudo make install

## xmonad
sudo pacman -S xmonad xmonad-contrib haskell-dbus
stow xmonad

## rime
sudo pacman -S fcitx5-im fcitx5-nord fcitx5-rime
paru -S rime-cloverpinyin rime-pinyin-zhwiki
stow rime
sudo vim /usr/share/rime-data/opencc/symbol_word.txt

## gui
sudo pacman -S nordic-theme
sudo pacman -S xcursor-breeze
