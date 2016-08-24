#airgeddon
This is a multi-use bash script for Linux systems to audit wireless networks.<br/>
<img src="https://raw.githubusercontent.com/v1s1t0r1sh3r3/airgeddon/master/imgs/airgeddon_banner.png" title="We'll conquer the earth!!"/>

#Features
- Interface mode switcher (Monitor-Managed).<br/>
- DoS over wireless networks with different methods.<br/>
- Assisted Handshake file capture.<br/>
- Cleaning and optimizing Handshake captured files.<br/>
- Offline password decrypt on WPA/WPA2 captured files (dictionary, bruteforce and rule based).<br/>
- Evil Twin attacks: Only AP to sniff with external sniffer and Evil Twin with integrated sniffing. Coming soon with sslstrip and captive portal mode.<br/>
- Compatibility with many Linux distros (see requirements section).<br/>
- Easy targeting and selection in every section.<br/>
- Drag and drop files on console window for entering file paths.<br/>
- Dynamic screen resolution detection and windows auto-sizing for optimal viewing.<br/>
- Controlled Exit. Cleaning tasks and temp files. Option to keep monitor mode if desired.<br/>
- Multilanguage support and autodetect OS language feature (see supported languages section).<br/>
- Help hints in every zone/menu for easy use.<br/>
- Auto-update. Script checks for newer version if possible.

#Requirements
Bash version 4.0 or later needed.<br/>
<br/>
Tested on these compatible Linux distros:<br/>
*-Kali 2.0, 2016.1 and arm versions (Raspberry Pi)*<br/>
*-Wifislax 4.11.1 and 4.12*<br/>
*-Backbox 4.5.1 and 4.6*<br/>
*-Parrot 2.2.1 and 3.1.1*<br/>
*-Blackarch 2016.01.10 and 2016.04.28*<br/>
*-Cyborg Hawk 1.1*<br/>
*-Debian 7 (Wheezy) and 8 (Jessie)*<br/>
*-Ubuntu/Xubuntu 15.10, 16.04 and 16.04.1*<br/>
*-OpenSUSE Leap 42.1*<br/>
*-CentOS 6 and 7*<br/>
*-Gentoo 20160514 and 20160704*<br/>
*-Fedora 24*<br/>
*-Red Hat 7 (Maipo)*<br/>
*-Arch 4.6.2-1*<br/>
*-Raspbian 7 (Wheezy) and 8 (Jessie) (Raspberry Pi)*<br/>
*-OpenMandriva LX3*<br/>
<br/>
It's already available in <a href="https://archstrike.org/wiki" target="_blank">ArchStrike</a> repositories used by some distros based on Arch Linux.<br/>
Repositories versions will have auto-update feature disabled in order to avoid breaking dependencies. There is a var at the beginning of the file, *"auto_update"* can be set to 0 to turn off the auto-update feature.<br/>
<br/>
Anyway, can be used with any Linux distro if you have installed the tools what script needs. The script checks for them at the beginning.<br/>
<br/>
We will enumerate the categories and tools. The format will be: "command -> possible package name". The command can be included in different packages depending of the distro.<br/>
<br/>
Essential tools: <- *the script doesn't work if you don't have installed all of them*
```
iwconfig -> wireless-tools
iw -> iw
awk -> awk / gawk
airmon-ng -> aircrack-ng
airodump-ng -> aircrack-ng
aircrack-ng -> aircrack-ng
xterm -> xterm
```
Optional tools: <- *not necessary to work, only needed for some features*
```
wpaclean -> aircrack-ng
crunch -> crunch
aireplay-ng -> aircrack-ng
mdk3 -> mdk3
hashcat -> hashcat
hostapd -> hostapd
dhcpd -> isc-dhcp-server / dhcp-server / dhcp
iptables -> iptables
ettercap -> ettercap / ettercap-text-only / ettercap-graphical
etterlog -> ettercap / ettercap-text-only / ettercap-graphical
```
Update tools: <- *not necessary to work, only used for auto-update*<br/>
```
curl -> curl
```
Internal tools: <- *these are internally checked. Not necessary to work, good to have*<br/>
```
xdpyinfo -> x11-utils / xdpyinfo / xorg-xdpyinfo
ethtool -> ethtool
lspci -> pciutils
rfkill -> rfkill
```
Is highly recommended to have the internal tools installed. They improve functionality and performance. For example, xdpyinfo allow the script to detect the desktop resolution in order to print windows in a better way.

#Known incompatibilities
Impossible compatibility for Mac OSX at the moment. Some reasons:<br/>
*-Bash version* <- it can be avoided upgrading to 4 or later, this is not the real problem :)<br/>
*-Aircrack suite* <- this suite for OSX doesn't support airodump and aireplay<br/>
*-Wireless tools* <- iwconfig doesn't exists for OSX, and airport command can't be used. It generates very different outputs<br/>

Incompatible with OpenBSD and FreeBSD. They are Unix systems but they have some differences with Linux:<br/>
*-Bash* <- They have no bash. It can be installed, this is not the real problem<br/>
*-Wireless tools* <- iwconfig doesn't exists for these systems, they use ifconfig instead and it generates very different outputs

#Disclaimer
This script must be used only for educational purposes and Pen testing.<br/>
Use it only on your own networks.<br/>
We are not responsible of its use.<br/>
This script is under GPLv3 (or later) License.

#Use
Under some distros like Kali Linux must be launched only using bash (not sh). Example `bash /path/airgeddon.sh`<br/>
Under Wifislax Linux and others, it can be launched using bash or sh. Example `sh /path/airgeddon.sh`<br/>
If you launch the script using sh and a *"Syntax error"* appears, launch it with bash instead of sh.<br/>

#Supported Languages
English, Spanish, French, Catalan and Portuguese.

#Project Collaboration
You can join the project:<br/>
-Translations to other languages are welcome.<br/>
-More distros support compatibility.<br/>
-New features.<br/>
-Testing and feedback is needed too.<br/>
<br/>
*For collaborating translators:*<br/>
You can take the strings to translate from the code or you can ask me directly by mail. I'll inform you how to proceed.<br/>
<br/>
*For collaborating developers:*<br/>
Debug mode was implemented for faster development skipping intro and initial checks. Use it setting var *"debug_mode"* to 1<br/>
Please, respect the code style and the UTF-8 files format only using at the end of the lines LF (not CRLF).<br/>
<br/>
*For beta testers:*<br/>
You can download the master version or the beta testing version from the development branch called `dev`

#Changelog
See <a href="https://github.com/v1s1t0r1sh3r3/airgeddon/blob/master/changelog.txt" target="_blank">Changelog</a> file to review changes.

#Special Thanks to
Thanks to the "Spanish pen testing crew", the Wifislax staff, the seguridadwireless.net and wifi-libre.com forum people that helped me.<br/>
<br/>
**Kcdtv** for French translations, beta testing, suggestions about new features and support received since the beginning.<br/>
**USUARIONUEVO** for helping me to improve the script, suggestions about new features and for the support received.<br/>
**El padrino** for Catalan translations.<br/>
**Beans** for Portuguese translations.<br/>
<br/>
Thank you too to other authors who inspired me with their scripts:<br/>
*vk496 -> Linset*<br/>
*MI1 -> Airstorm*<br/>
*MatToufoutu -> Ap-fucker*<br/>
*Coeman76 -> Handshaker*

#Donate
If you enjoyed the script, feel free to give a donation. Invite me a coffee sending me a fraction of a bitcoin:<br/>
*3HcTA8H91oPRcd5eu1uJf165sbknQtUSzU*