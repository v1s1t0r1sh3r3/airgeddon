### 12.0
 - Added 6Ghz partial support (some scans, some attacks, capable adapter detection, etc.)

### 11.30
 - Added Multi-instance support to launch more than one airgeddon at a time
 - Improvements on 5Ghz country code check and 5Ghz band capability detection on adapters
 - Fixed bug to avoid set advanced captive portal on second time if is not desired after setting it previously
 - Now channel is automatically updated on control window during "DoS pursuit mode" for all Evil Twin attacks

### 11.22
 - Possibility to add manually ESSID name for selected hidden networks
 - Improvement on process killing on Evil Twin attacks
 - Add WPS version to network selection menu for WPS networks
 - Reordered networks on network selection menus (standard and WPS), now networks with the strongest received signal will be placed last to avoid scrolling
 - Fixed small bug on Evil Twin captive portal attack for passwords containing more than one space char
 - Fixed Docker routing problem

### 11.21
 - Chinese language translation added (Thank you to "zcbxx")
 - Fixed bug parsing cracked PIN on WPS reaver Pixie Dust attack for newer reaver versions
 - Fixed error on PMKID capturing due hcxdumptool different params for newer versions using bpf filters
 - Fixed error on interfaces and process killing on "DoS pursuit mode"

### 11.20
 - Improvements and fixes on "DoS pursuit mode"
 - Fixed bug on Evil Twin captive portal attack when relative paths used
 - Added Consistent Network Device Naming detection check upon interface selection
 - Fixed bug on filtered WPA scans when pure WPA3 (SAE) present
 - Fixed WPS attacks error message appearing on some Linux distributions
 - Fixed bug in graphics system detection for non-systemd systems
 - Added optional advanced captive portal including vendor logos

### 11.11
 - Custom enterprise certificates creation fix (now sha256) for modern hostapd-wpe versions
 - Fixed Docker distro shown (now Kali based)
 - Fixed PMKID hashcat hash parsing
 - Improvements on graphics system and resolution detection
 - Fixed 5Ghz Evil Twin attacks DoS problems
 - Added 5Ghz country code check 
 - Improvements on OS/distro detection

### 11.10
 - Fixed problem for latest BeEF
 - Fixed broken dependency menu validation
 - Added sponsorship mentions
 - WPS attacks modified to avoid saved sessions messages
 - Adapted conversion for hashcat modern versions

### 11.02
 - Fixed minor bug in minimum length setting while bruteforcing using hashcat
 - Improvement hashcat use forcing it to use -m 22000 instead of old -m 2500 over handshakes cracking for hashcat modern versions
 - Added WSL/WSL2 detection to force exit due to incompatibility
 - Extended compatibility to use lspci 3.8 not accepting 0x
 - Fixed error showing connected clients in Evil Twin captive portal attack

### 11.01
 - Fixed busy ports checks
 - Added PIN to WPS trophy file
 - Fixed Evil Twin route problems for modern mobile devices (Android, Kali Nethunter, etc.)
 - Improvement in missing dependencies plugin to be able to check output when errors occur
 - Adapted WPA/WPA2 attacks (handshake capture, PMKID and Evil Twin captive portal) to work with WPA2/WPA3 mixed networks
 - Fix error launching sslstrip2 using old Bettercap 1.x

### 11.0
 - Improvements in plugins system
 - GPU support for hashcat
 - Keep compatibility for hashcat -m 2500 on new hashcat versions
 - Improvement for busy ports checks on Evil Twin attacks, now show conflicting process
 - Fixed error on captive portal trophy file path when only dir (no file) specified
 - Added CI files to be used in Github actions for Docker automated building

### 10.42
 - Changed airmon compatibility check to fit same method used by airmon
 - VIF support check added before launching Evil Twin attacks
 - airgeddon version shown in title at main menu
 - Fixed arabic scrambled strings and added missing arabic strings to missing dependencies plugin
 - Fixed debug mode malfunction
 - Added busy ports checks on Evil Twin attacks
 - Dockerfile rollback to Arch (ArchStrike image as base) due to Parrot repos problems

### 10.41
 - Fixed error on PMKID hash validation
 - Created an option to avoid Network Manager force killing on Evil Twin attacks
 - Code improvements to allow new kind of arguments based plugins
 - Dsniff Evil Twin captive portal DNS black hole replaced by dnsmasq
 - Dockerfile rollback to Parrot (Parrot Security image as base) to avoid Arch Glibc + Dockerhub automated builds problem

### 10.40
 - Removed deprecated route command
 - Fixed error on WPS PINs found in database counter
 - Sslstrip Evil Twin attack replaced by Bettercap-Sslstrip2 Evil Twin attack, sslstrip dependency removed
 - Fixed error on Evil Twin attacks when tmux and Bettercap 2.x used
 - Fixed wrong username shown on asleap decryption after capture for Enterprise Evil Twin attack
 - Fixed freezing while trying to resume reaver session

### 10.31
 - Fixed error of no returning to DoS menu after fail on handshake capture for Evil Twin Captive portal attack
 - Fixed error of no returning to Evil Twin main menu for some special situations on BeEF attack
 - Removed deprecated hcxpcaptool, replaced by hcxpcapngtool
 - Replaced old PMKID hash format to be used in hashcat, from 16800 to 22000
 - Improved responsive behaviour of Evil Twin Captive Portal web page
 - Compatibility extended to Bettercap 2.x (>=2.28) for sslstrip2/BeEF Evil Twin attack

### 10.30
 - Fixed error on internet interface selection menu when no number provided
 - Fixed BeEF error due forced config file changes for some versions
 - Fixed weird error for endless loop while capturing handshake on some devices
 - Fixed terminal freeze problem when Ctrl+C pressed on path prompt
 - Fixed Network Manager problem on fake AP used for Evil Twin attacks
 - Arabic language translation added (Thank you to "darthvader-htb")

### 10.21
 - Improved hostapd-wpe config for some conflicting Linux
 - Dockerfile migrated to Arch (ArchStrike image as base) to avoid Debian based missing packages problem
 - After PMKID capturing, now additionally can transform captured file into .cap aircrack-ng file format

### 10.20
 - Big language strings array now loaded only once and printing system changed. Speed highly improved
 - Fixed problem for handshake detection on captured files containing only handshake (without pmkid)
 - Missing dependencies plugin adapted to install some special (missing on repos due retirement) packages
 - Dockerfile adapted to work flawlessly with the deprecated retired packages

### 10.11
 - Fixed error on PMKID capturing due hcxdumptool different params for different versions
 - Added feature to detect captured PMKID while capturing Handshake
 - Integration of PMKID on Evil Twin Captive Portal

### 10.10
 - PMKID capture feature
 - PMKID offline decryption feature
 - Tested compatibility with Manjaro Linux
 - Fixed error on auto_update plugin on some Linux distros

### 10.01
 - Removed deprecated ifconfig and iwconfig commands and dependencies
 - Fixed error on enterprise certificates validation
 - Added autoselection for secondary interface if only one existing
 - Airmon compatibility check system refactored
 - Fixed error in default paths trophy files for Ettercap/Bettercap

### 10.0
 - Added plugins system
 - Added example plugin: Missing dependencies auto-installation for some distros (Kali, Parrot, BlackArch)
 - Improvements for Evil Twin on captive portal detection for newer devices
 - Missing 5Ghz channels added
 - Github pull request template added and issue templates updated
 - Fixed error on hex2ascii conversion for some WEP passwords

### 9.23
 - Fixed error printing hints
 - Fixed problem with default values on options file creation

### 9.22
 - Improved certificates validations and error messages
 - Removed useless internet access DNS resolution method for captive portal Evil Twin, now pure dnsspoof
 - Fixed exit on tmux launch if tmux not installed
 - Added more charset combinations for hashcat bruteforce attacks
 - Fixed length problem on hashcat bruteforce decryption attacks
 - Fixed handshake capture menu error
 - Compatibility extended to Pentoo Linux
 - Removed unneeded expect (unbuffer) dependency
 - Added tab autocompletion for every path input

### 9.21
 - Fixed non-closing windows on some "DoS pursuit mode" attacks
 - Added retrocompatibility for mdk3, added option in .airgeddonrc file to handle it
 - Fixed bug on WEP all-in-one attack (Fake Auth) for SSIDs containing spaces
 - Fixed repeated enterprise plain passwords captured on trophy files
 - Added custom certificates creation for enterprise attacks
 - Fixed error on BeEF attack using tmux

### 9.20
 - Added option to use tmux instead of xterm (Thank you to "xpz3")
 - Added WPS null PIN attack (reaver)

### 9.11
 - Fixed error shown on enterprise attacks for some wifi cards
 - Fixed BeEF error due forced config file changes on BeEF 0.4.7.1 and 0.4.7.2 versions
 - Added ipv6 support for BeEF
 - Options .airgeddonrc file now also updated on automatic update keeping user's preferences

### 9.10
 - Mdk3 replaced by Mdk4
 - Fixed some minor bugs on enterprise plain text captured password process
 - Fixed minor bug forcing interface mode change after smooth enterprise attack
 - Tested compatibility with Wifislax 64-2.x and Kali 2019.x
 - Fixed dependency problem to avoid use of xxd
 - Routing rules adapted to work with nftables

### 9.01
 - Improvements on options environment var system
 - Minor fixes for ARM devices
 - Fixed iptables (nf_tables) problem

### 9.0
 - New WPA/WPA2 enterprise attacks menu
 - New WPA/WPA2 enterprise offline decryption menu
 - Compatibility extended to Linux Mint 18.x
 - Flag system for options based on fallback substitution variables (config file, command line and menus)
 - Fixed error on hashcat bruteforce decryption attacks regarding length

### 8.12
 - Fixed error on WPS attacks for strange chars in some SSIDs
 - Tested compatibility with Kali 2018.3/4, Fedora 28, Backbox 5.x and BlackArch 2018.06.01
 - Added prompt symbol for every user interaction
 - Improved regex for BSSID check
 - Changes on contributing policies
 - Github pull request template added and issue templates updated
 - Added Wayland graphic system support (Thank you to "fr0xk")
 - Fixed print error on flying saucer intro for some terminals

### 8.11
 - Turkish language translation added (Thank you to "UN5T48L3")
 - Extended cards compatibility. Now airmon non compatible cards can be used
 - Fixed error on captive portal for some SSID strange chars
 - Fixed error showing SSIDs containing spaces on WPS network selection menu
 - Fixed error on chipset detection for some cards

### 8.10
 - WPS decrypted networks now have trophy file
 - Tested compatibility with Kali 2018.2, Ubuntu 18.04 and Parrot 4.x
 - Controlled error for unsupported Bettercap 2.x version
 - Automatic check added on Handshake capture (Thank you to "IwraStudios")
 - Fixed card detection bug on some Linux

### 8.01
 - German language translation added (Thank you to "hamperfait")
 - Filters enabled on scannings based on menu or kind of attack
 - WPS PIN database now is updated on startup updates too
 - Return option now always at position 0 on all menus
 - Removed --weak--hash-threshold option for hashcat 4.0.0 or higher
 - Tested compatibility with Parrot 3.11
 - Fixed aspect of network selection menu when network power is equal to -1

### 8.0
 - Added 5Ghz full support (scans, attacks, card detection, etc.)
 - Tested compatibility with Kali 2018.1, BlackArch 2017.12.11, Fedora 27, Gentoo 20180206, OpenSUSE 42.3 and Parrot 3.10
 - Fixed error setting ESSID on some wash versions while scanning
 - Fixed error on secondary interface selection menu for "DoS pursuit mode"

### 7.23
 - Fixed error in Docker container on some host O.S.
 - Fixed error message on offline Arcadyan PIN algorithm calculation
 - Polish language translation added (Thank you to "dodg3rmaq")
 - Added "DoS pursuit mode" on DoS attacks (including DoS used on Evil Twin attacks) to avoid AP channel hopping
 - Tested compatibility with Parrot 3.9, BlackArch 2017.08.30 and Kali 2017.3

### 7.22
 - Fixed error caused by Bettercap. Bug: https://github.com/evilsocket/bettercap/issues/356
 - Arcadyan WPS PIN generation algorithm integrated
 - Tested compatibility with Kali 2017.2 and Parrot 3.8
 - WPS Bully bruteforce attack modified to use --sequential (-S) argument
 - Added WPS offline PIN generation and database menu option

### 7.21
 - Italian language translation added (Thank you to "salu90")
 - Tested compatibility with Parrot 3.7, Fedora 26 and Wifislax 64-1.1
 - Improved check for root permissions, now mandatory
 - Fixed bug for some menu inputs using special chars. Now sanitized
 - Code improvements, removed new shellcheck warnings
 - Fixed bug launching BeEF Evil Twin attack twice

### 7.2
 - Improved chipset detection
 - New language and options menu
 - Colorization, auto-update and startup language autodetection now can be enabled/disabled persistently from menu
 - Language can be set permanently from menu even for next startup after an update
 - New check using xset internal tool to check for a working X window system in order to avoid uncontrolled xterm errors

### 7.11
 - Added hccapx support for hashcat 3.40 or higher
 - Decrypted hashcat trophy files beautified
 - Added confirm questions before attacks if no target selected
 - WPA/WPA2 decrypted files using aircrack now have trophy file
 - Some outputs colorized using ccze

### 7.1
 - Added default choice for some yes/no question. Regexp improved
 - Tested compatibility with Backbox 4.7 and Parrot 3.6
 - Improved curl and wget methods. Now autodetect if http proxy is set and needed
 - WPS Reaver attacks modified. Removed --auto (-a) argument causing problems on some Reaver versions
 - Dockerfile updated

### 7.02
 - Improved internet checking. Now ip address and host based methods
 - Internet checking function splitted. Now separated from repository access
 - Fixed error shown when handling interfaces without MAC address
 - Tested compatibility with Ubuntu 17.04

### 7.01
 - Fixed bug while changing interface mode if the destination interface name is in use
 - Removed util-linux dependency for rev use
 - The existing iptables rules before the launch of airgeddon are now restored upon exiting if modified
 - Fixed bug while checking for NetworkManager's version on some Linux distributions
 - Tested compatibility with Kali Linux 2017.1 and Parrot 3.5
 - Dockerfile updated

### 7.0
 - New WEP attacks menu
 - Added All-in-One WEP attack
 - Fixed bug on Handshake capture validations

### 6.21
 - Improved chipset detection, lsusb added to internal tools
 - Improved internet checking. Now more methods, not only icmp
 - Fixed error executing airgeddon after auto-update on some Linux distributions
 - Added LICENSE.md and README.md files to Kali package

### 6.2
 - Docker support added
 - Default save path system detecting if executed in Docker container

### 6.12
 - Fixed bug on network detection
 - Fixed bug causing strange behaviour on some Linux handling optional_tools array

### 6.11
 - Optional MAC spoofing added for all Evil Twin attacks
 - Spoofed MAC addresses restored on exit

### 6.1
 - Network selection menus now colorized
 - Language strings now in a separated file for easy handling and translating
 - Validation and self-downloading system for new language strings file

### 6.01
 - Shebang changed to a more portable one `#!/usr/bin/env bash`
 - New extra-verbose debug mode added
 - README.md major modifications
 - Added CONTRIBUTING.md
 - Unexpected errors on wash scanning are controlled now
 - Improved distro detection for some arm Linux

### 6.0
 - New system for possible tool aliases checking the requirements
 - Evil Twin attack added: Bettercap-Sslstrip2 and BeEF browser exploitation framework
 - Option to manage custom BeEF location if manually installed and not found. Script polymorphism rewriting itself to make it persistent even after updates
 - README.md beautified
 - Colors changed. Now blocking errors in red
 - License and changelog files updated to markdown format
 - Updated minimum bash version check (v4.2)
 - Tested compatibility with OpenSUSE 42.2 and Parrot 3.4.1
 - Fixed error trying to download PIN db file on WPS attacks when curl isn't installed

### 5.14
 - Timeout changed while searching for "bad FCS" to avoid problems in old systems
 - WPS Reaver attacks modified to use --no-nacks (-N) argument
 - Github issue template updated
 - Check added to skip intro if not enough window size
 - Tested compatibility with BlackArch 2016.12.29

### 5.13
 - WPS default timeouts changed
 - WPS parameterizable timeouts, users can decide how many seconds for each WPS attack
 - More traps handled. Auto restore managed mode on interface after SIGINT/SIGHUP

### 5.12
 - Fixed bug for wash scanning on reaver 1.5.3. Now new method works for all versions because the version doesn't care anymore

### 5.11
 - Custom PIN, bruteforce and Pixie Dust WPS attacks integrated in new parser system
 - Fixed bug for wash scanning on custom reaver 1.5.4 for Wifislax
 - Some code improvements

### 5.1
 - Integrated online PIN database for "known WPS PINs attack" (reaver and bully)
 - Zhao Chunsheng WPS PIN generation algorithm integrated (ComputePIN)
 - Stefan Viehböck WPS PIN generation algorithm integrated (EasyBox)
 - Some language strings changed
 - Fixed bug showing selected charset for hashcat v3.0 on bruteforce offline decrypt attack

### 5.01
 - WPS bruteforce PIN attacks (reaver and bully)
 - New system for arm architecture detection
 - Compatibility extended to Parrot arm version on Raspberry Pi
 - Some WPS attacks improvements
 - Compatibility extended for hashcat v3.0 or higher

### 5.0
 - WPS attacks menu added
 - WPS scanning based on wash tool. Self-parametrization to avoid "Bad FCS" problem
 - WPS Custom PIN association
 - WPS Pixie Dust attacks integrated with reaver and bully
 - Some code improvements

### 4.32
 - Some code improvements and refactors. Warnings removed based on shellcheck tool
 - README.md small modifications
 - Fix on language menu selecting greek language
 - Fixed problem on renew_ifaces_and_macs_list function when there are interfaces without MAC (like some tunnel interfaces)

### 4.31
 - Now optionally on Evil Twin captive portal attack you can choose between to have internet access or to use a "dns trick"
 - Fixed bug writing Handshake files on some paths
 - Added possibility to get back to Evil Twin main menu from the internet interface selection menu

### 4.3
 - Evil Twin attack added: captive portal
 - Some language strings changed
 - Now initial forwarding state is restored on exit
 - Fix for Linux which change interface name to a very different name while getting back to managed from monitor mode

### 4.22
 - Portuguese translation updated (Thank you to "Luan")
 - Paypal donate button added on README.md
 - Bitcoin hash changed and bitcoin donate button added on README.md
 - Tested compatibility with Kali Linux 2016.2

### 4.21
 - Greek language translation added (Thank you to "xtonousou")

### 4.2
 - Evil Twin attack added: with integrated sniffing using sslstrip
 - Evil Twin control window beautified and optimized for small windows

### 4.11
 - Russian language translation added (Thank you to "MiAl")

### 4.1
 - Evil Twin attack added: with integrated sniffing
 - Log parsing for Evil Twin attack with sniffing

### 4.03
 - Some compatibility improvements for Raspberry Pi Raspbian Linux
 - Additional check for systems which use airmon-zc, now checks for lspci to avoid errors
 - Compatibility extended to OpenMandriva Linux
 - Compatibility extended to Kali arm version on Raspberry Pi

### 4.02
 - New windows sizes calculation method for better viewing even in small resolutions. Dynamic system
 - Fixed bug restarting Network Manager on Arch Linux
 - Fixed bug restarting Network Manager using debug mode on some Linux distributions
 - Suggestion added about possible packet names after failing a dependency check

### 4.01
 - Fixed bug cleaning temp files for Evil Twin attack

### 4.0
 - Evil Twin attack added: Only AP to sniff with external sniffer
 - Created under construction message for non finished menu options
 - README.md beautified
 - Screen resolution correction feature added for some Linux distributions
 - Some minor improvements and bugfixes

### 3.44
 - Screen resolution detection for optimal windows viewing
 - Some language strings changed
 - Deleted ods translations file. It was impractical

### 3.43
 - Function created to generate dynamic separators on menus
 - Some language strings changed

### 3.42
 - Compatibility extended to Arch Linux
 - Compatibility extended to Raspbian Linux for Raspberry Pi
 - Additional check for systems which use airmon-zc, now checks for ethtool to avoid errors
 - Portuguese language translation added
 - Auto-update can be disabled using a var (useful for repositories versions)
 - Auto change language feature can be disabled using a var

### 3.41
 - Show network cards chipset while selecting interface
 - Some language strings changed
 - License updated to GPL3+
 - Added Open Document SpreadSheet for easy translation to be used by collaborating translators
 - System of prefixes and colors for hints and strings pending of translation [PoT]

### 3.4
 - Improved regexp to get new interface names after a change
 - Fixed bug managing paths containing blank spaces
 - New feature, drag and drop files on console window to entering file paths
 - New offline decrypting attacks based on cpu hashcat (dictionary, bruteforce and rule based)
 - Debug mode for faster development skipping intro and initial checks
 - Bash version check improved for future versions
 - Exit script code changes to differentiate when script was interrupted

### 3.34
 - Ascii art intro added on script startup (animated flying saucer!!)
 - Bug fixed after putting card in monitor mode and the card name changed on some Linux distributions
 - Compatibility extended to Gentoo, Fedora and Red Hat Linux

### 3.33
 - Bug fixed relaunching script after donwload a new version
 - Credits beautified
 - Known compatible distros unified in one array
 - "No check kill needed" feature method changed. Now based on Network Manager version
 - Changes on rfkill method

### 3.32
 - Bash version check simplified
 - Bug with long interface names fixed
 - Changed trap management, now with buffered messages
 - Curl removed from essential tools. Now the script performs a separated check for update tools only used for auto-update
 - Compatibility extended to CentOS Linux

### 3.31
 - Check for root permissions after failed essential tools check
 - Improved missing optional tools detection method and integration with menus
 - Menu separator lines extracted to functions

### 3.3
 - SIGTSTP trap now handled
 - Minimum bash version check (v4)
 - Some language strings changed
 - Non Linux OS check added (Solaris, FreeBSD, OSX)
 - Compatibility extended to OpenSUSE Linux
 - README.md updated about Mac OSX incompatibility
 - Improved OS language detection method
 - Fixed bug in auto-update

### 3.23
 - Compatibility extended to Cyborg Hawk Linux
 - Needed tools divided, essential and optional. Script can run now with essential tools even without some of the optional tools
 - Changed "No check kill needed" feature method. Now improved for Kali and Wifislax future versions
 - Bug fixed while checking for updates on slow connections
 - README.md beautified

### 3.22
 - Cleaning Handshake files now perform some checks to avoid corruption file problem
 - Capture files are checked before cracking looking for Handshakes and easy targeting
 - Fixed bug checking existence of files

### 3.21
 - Auto-update feature. Script checks for newer version
 - Some language strings changed

### 3.2
 - New offline password decrypt menu
 - Aircrack option to perform dictionary/bruteforce attacks against capture files
 - Removed autoclean after capturing a Handshake file
 - Changed version var to airgeddon_version for future version check (auto-update feature)

### 3.11
 - Optional autoclean captured Handshake file feature
 - Some language strings changed

### 3.1
 - Restoring initial state of cards on exit feature
 - "No check kill needed" feature added while putting card in monitor mode for some Linux distributions
 - Fixed bug checking tools

### 3.02
 - Cleaning tasks on exit
 - Minor code refactor
 - Some language strings changed
 - Hint method improved

### 3.01
 - Handshake tools menu added
 - Handshake capture feature
 - Handshake cleaning/optimizing feature
 - Random helping hints added (regarding the script zone)

### 3.0
 - New menus, new structure
 - New Handshake features preparation (not working yet in this revision)
 - Code normalization

### 2.33
 - Catalan language translation added (Thank you to "El Padrino")

### 2.32
 - Autodetect OS language feature added
 - Some language strings changed

### 2.31
 - French language translation added (Thank you to "kcdtv")
 - Only one network autoselect bug fixed

### 2.3
 - Compatibility extended to Parrot, Blackarch and Backbox Linux
 - Essential tools check improved
 - Distro compatibility check improved
 - Iwconfig use fix based on version
 - Pink color added

### 2.23
 - Read "pause" functions now integrated with language strings
 - Title generator extracted to function
 - Improvements on colors
 - Changelog order changed. New changes now upper

### 2.22
 - Minor print fail in ascii art at credits fixed
 - Disclaimer and requirements updated
 - Some typo errors fixed
 - Changes on compatibility check structure
 - Ubuntu and Debian Linux compatibility check added

### 2.21
 - Wifislax 64bits compatibility bug fixed
 - Removed version from README.md file

### 2.2
 - Changes to manage Wifislax airmon command in a better way

### 2.11
 - More color features
 - Compatibility check minor bug fixed

### 2.1
 - Compatibility check at beginning to support more Linux distributions
 - Changelog file added to project

### 2.03
 - Interface detection method changed
 - Fixed bug for Kali 2016.1

### 2.02
 - Menu titles improvement
 - Converted to UTF-8 enconding. Special spanish chars bug fixed
 - Some minor code improvements

### 2.01
 - Multilanguage support feature included
 - English and Spanish languages added

### 2.0
 - Code restructuration
 - WIDS confusion attack added
 - Old attacks menu included
 - Traps managing feature

### 1.03
 - Secondary xterm windows added
 - Explore for targets feature included
 - Code improvements

### 1.02
 - Improved echo messages and colors
 - Aireplay deauth attack included
 - Monitor and managed options added

### 1.01
 - Detect distro functionality included
 - Kali and Wifislax Linux compatibility
 - Rfkill added

### 1.0
 - Initial commit
