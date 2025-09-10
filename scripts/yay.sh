git clone https://aur.archlinux.org/yay.git ~/git/yay

pushd ~/git/yay > /dev/null
makepkg -s --noconfirm
popd > /dev/null

PKG=$(ls -t ~/git/yay/*.pkg.tar.zst | grep -v -- "-debug" | head -n1)
sudo pacman -U --noconfirm "$PKG"