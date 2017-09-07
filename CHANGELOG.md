### 7.21
 - Italian language translation added (Thank you to "salu90")
 - Tested compatibility with Parrot 3.7 and Fedora 26
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
 - Fixed bug while checking for NetworkManager's version on some linux distributions
 - Tested compatibility with Kali Linux 2017.1 and Parrot 3.5
 - Dockerfile updated

### 7.0
 - New WEP attacks menu
 - Added All-in-One WEP attack
 - Fixed bug on Handshake capture validations

### 6.21
 - Improved chipset detection, lsusb added to internal tools
 - Improved internet checking. Now more methods, not only icmp
 - Fixed error executing airgeddon after auto-update on some distros
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
 - Network selection menues now colorized
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
 - Zhao Chunsheng algorithm integrated (computepin)
 - Stefan Viehböck algorithm integrated (easybox)
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
 - Fixed bug writing handshake files on some paths
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
 - Fixed bug restarting Network Manager using debug mode on some distros
 - Suggestion added about possible packet names after failing a dependency check

### 4.01
 - Fixed bug cleaning temp files for Evil Twin attack

### 4.0
 - Evil Twin attack added: Only AP to sniff with external sniffer
 - Created under construction message for non finished menu options
 - README.md beautified
 - Screen resolution correction feature added for some distros
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
 - Bug fixed after putting card in monitor mode and the card name changed on some distros
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
 - Cleaning handshake files now perform some checks to avoid corruption file problem
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
 - "No check kill needed" feature added while putting card in monitor mode for some distros
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
 - French language translation added (Thank you to "Kcdtv")
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
 - Compatibility check at beginning to support more distros
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
