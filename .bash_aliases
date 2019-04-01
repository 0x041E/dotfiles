alias pacaur='pacaur --color auto'
alias pacman='pacman --color auto'

alias up='cd ..'

alias ls='ls --color=auto'
alias ls='ls --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias ll='ls -l --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias la='ls -la --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias lsl='ls --color=auto -lah'

alias mv='mv -i'
alias cp='cp -i --preserve=all --reflink=auto' # confirm overwrites
alias rm='rm -i'

alias grep='grep --color=tty -d skip' # skip recursing into directories
alias ps='ps aux'
alias df='df -h'
alias free='free -h'
alias cal='cal -m -3'

#alias wine32='WINEARCH=win32 WINEPREFIX=~/.wine32 wine'
alias wine32arch='WINEARCH=win32 WINEPREFIX=~/.wine32'
alias steam-wine='wine ~/.wine/drive_c/Program\ Files\ \(x86\)/Steam/Steam.exe -no-cef-sandbox >/dev/null 2>&1 &'
alias xephyrserver='Xephyr -br -ac -noreset -screen 1280x700 :1'
alias TwitterDownloader='wine32arch wine /Data/programovani/VS/TwitterPicDownloader/TwitterPicDownloader/bin/Release/TwitterPicDownloader.exe'
alias osudir='cd /System/Users/Vitek/AppData/Local/osu\!'
#alias runsteam=LD_PRELOAD='/usr/$LIB/libstdc++.so.6 /usr/$LIB/libgcc_s.so.1 /usr/$LIB/libxcb.so.1' primusrun steam
alias rmbadsteamlibs='find ~/.steam/root/ \( -name "libgcc_s.so*" -o -name "libstdc++.so*" -o -name "libxcb.so*" \) -print -delete'
alias rmbadsteamlibslocal='find ~/.local/share/Steam/ \( -name "libgcc_s.so*" -o -name "libstdc++.so*" -o -name "libxcb.so*" \) -print -delete'
alias rmbadsteamgpg='find ~/.steam/root/ -name "libgpg-error.so*" -print -delete'
alias blank_off='xset -dpms; xset s off;'
alias blank_on='xset s on; xset +dpms'

alias alzip='wine32arch wine "C:\Program Files\ESTsoft\ALZip\ALZipCon.exe"'
