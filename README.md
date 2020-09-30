# airgeddon [![Version-shield]](https://raw.githubusercontent.com/v1s1t0r1sh3r3/airgeddon/master/CHANGELOG.md) [![Bash4.2-shield]](http://tldp.org/LDP/abs/html/bashver4.html#AEN21220) [![License-shield]](https://raw.githubusercontent.com/v1s1t0r1sh3r3/airgeddon/master/LICENSE.md) [![Docker-shield]](https://hub.docker.com/r/v1s1t0r1sh3r3/airgeddon/) [![Paypal-shield]](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=7ELM486P7XKKG) [![Cryptocurrencies-shield]](https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Contributing-&-Code-of-Conduct)

> This is a multi-use bash script for Linux systems to audit wireless networks.

![Banner]

---

All the needed info about how to "install | use | enjoy" `airgeddon` is present at [Github's Wiki].

- *I.Content & Features*
  - [Home]
  - [Features]
  - [Screenshots]
  - [Wallpapers]


- *II. Requirements*
  - [Requirements]
  - [Compatibility]
	 - [Cards and Chipsets]
	 - [Wayland]
	 - [Consistent Network Device Naming]
	 - [Kali Nethunter]
  - [Essential Tools]
  - [Optional Tools]
	 - [BeEF Tips]
	 - [Hashcat Tips]
	 - [Bettercap Tips]
  - [Update Tools]
  - [Internal Tools]
  - [Known incompatibilities]


- *III. Getting started*
  - [Installation & Usage]
  - [Options]
  - [Docker]
	 - [Linux]
	 - [Mac OSX]
	 - [Windows]
  - [Other Sources]
  - [FAQ & Troubleshooting]


- *IV. Project & Development*
  - [Plugins system]
	 - [Plugins development]
	 - [Plugins Hall of Fame]
  - [Supported Languages]
  - [Contributing & Code of Conduct]
  - [Changelog]
  - [Disclaimer & License]
  - [Contact]


- *V. Acknowledgments & References*
  - [Hat Tip To]
  - [Inspiration]

[Banner]: https://raw.githubusercontent.com/v1s1t0r1sh3r3/airgeddon/master/imgs/banners/airgeddon_banner.png "We will conquer the earth!!"
[Github's Wiki]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki

[Home]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki
[Features]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Features
[Screenshots]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Screenshots
[Wallpapers]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Wallpapers
[Requirements]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Requirements
[Compatibility]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Compatibility
[Cards and Chipsets]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Cards%20and%20Chipsets
[Wayland]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Wayland
[Consistent Network Device Naming]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Consistent%20Network%20Device%20Naming
[Kali Nethunter]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Kali%20Nethunter
[Essential Tools]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Essential%20Tools
[Optional Tools]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Optional%20Tools
[BeEF Tips]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/BeEF%20Tips
[Hashcat Tips]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Hashcat%20Tips
[Bettercap Tips]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Bettercap%20Tips
[Update Tools]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Update%20Tools
[Internal Tools]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Internal%20Tools
[Known incompatibilities]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Known%20incompatibilities
[Installation & Usage]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Installation%20&%20Usage
[Options]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Options
[Docker]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Docker
[Linux]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Docker%20Linux
[Mac OSX]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Docker%20Mac%20OSX
[Windows]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Docker%20Windows
[Other Sources]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Other%20Sources
[FAQ & Troubleshooting]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/FAQ%20&%20Troubleshooting
[Plugins system]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Plugins%20System
[Plugins development]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Plugins%20Development
[Plugins Hall of Fame]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Plugins%20Hall%20of%20Fame
[Supported Languages]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Supported%20Languages
[Contributing & Code of Conduct]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Contributing-&-Code-of-Conduct
[Changelog]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Changelog
[Disclaimer & License]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Disclaimer%20&%20License
[Contact]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Contact
[Hat Tip To]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Hat%20Tip%20To
[Inspiration]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Inspiration

[Version-shield]: https://img.shields.io/badge/version-10.21-blue.svg?style=flat-square&colorA=273133&colorB=0093ee "Latest version"
[Bash4.2-shield]: https://img.shields.io/badge/bash-4.2%2B-blue.svg?style=flat-square&colorA=273133&colorB=00db00 "Bash 4.2 or later"
[License-shield]: https://img.shields.io/badge/license-GPL%20v3%2B-blue.svg?style=flat-square&colorA=273133&colorB=bd0000 "GPL v3+"
[Docker-shield]: https://img.shields.io/docker/cloud/automated/v1s1t0r1sh3r3/airgeddon.svg?style=flat-square&colorA=273133&colorB=a9a9a9 "Docker rules!"
[Paypal-shield]: https://img.shields.io/badge/donate-paypal-blue.svg?style=flat-square&colorA=273133&colorB=b008bb "Paypal"
[Cryptocurrencies-shield]: https://img.shields.io/badge/donate-cryptocurrencies-blue.svg?style=flat-square&colorA=273133&colorB=f7931a "Cryptocurrencies"
