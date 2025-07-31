# Contributing

Hi there! We are thrilled that you would like to contribute to this project. Your help is essential for keeping it great.

When contributing to this repository, please first discuss the change you wish to make via issue,
email, or any other method with the owners of this repository before making a change. Please read the Issue Creation Policy shown below before creating it.

Please note we have a [Code of Conduct], please follow it in all your interactions with the project.

---

## Issue Creation Policy

1. Please, consider to contact us on [IRC] channel or [Discord] server before opening an issue. More info at [Wiki Contact Section].
2. Before opening an issue, keep in mind that many of the common questions are already addressed in the [Wiki FAQ Section]. Please avoid asking questions that are already answered there.
3. Filling the issue template with *ALL* the requested info is mandatory. Otherwise, the issue can be marked as "invalid" and closed immediately.
4. Issues must be opened in English.
5. If an issue is opened and more info is needed, `airgeddon` staff will request it. If there is no answer in 7 days or the OP is not collaborating, the issue will be closed.
6. If the issue is not related to airgeddon or the root cause is out of scope, it will be closed. `airgeddon` staff is not a helpdesk support service.
7. Try to be sure that your problem is related to airgeddon and that is not a driver issue. A good practice is always to try to perform the same operation without using `airgeddon` in order to see if the problem or the behavior can be reproduced. In that case, probably the issue should not be created.
8. Don't talk or mention references to other tools. If you want to talk about other similar tools you can do it on their pages/GitHub. `airgeddon` issues are to talk about `airgeddon`.

## Collaborating Translators

1. ALWAYS ask before starting a translation to add a new language. You can do so by contacting us via email at [v1s1t0r.1s.h3r3@gmail.com], through Twitter (X) at [@OscarAkaElvis], via [IRC] channel, or on the [Discord] server. Please reach out to the development team to clarify your intentions. You will then be informed about how to proceed.
2. Translate the strings located in `language_strings.sh`, the existing strings of _language_strings_handling_messages_ function in `airgeddon.sh` and the strings of _missing_dependencies_text_ function in `missing_dependencies.sh` (this last file is in plugins dir).
3. If you want to create a pull request with a new language to be added, at least the 80% of the phrases must be translated and the rest must be done with at least _an automatic-translation_ system and marked with PoT (Pending of Translation) mark. Anyway, always ask first.
4. Remember that pull requests done over master branch will be rejected. Read the git workflow policy first.
5. After verification of and acceptation of the pull request, you can be added as a collaborator on the project to push directly on the repository instead of submitting pull requests.
6. Knowledge about `git` is mandatory (at least basic commands) to push directly into the project repository.

## Collaborating Developers and Plugins Development

#### For direct interaction with the repository (plugins development excluded):

1. First ask ALWAYS before performing a development. Ask the developement team to set what is going to be.
2. Tweak *"AIRGEDDON_DEVELOPMENT_MODE"* variable to "true" for faster development skipping intro and initial checks or change *"AIRGEDDON_DEBUG_MODE"* variable for verbosity.
3. Respect the **4 width tab indentation**, code style and the **UTF-8 encoding**.
4. Use **LF** (Unix) line break type (not CR or CRLF).
5. Use [Shellcheck] to search for errors and warnings on code. (Thanks [xtonousou] for the tip :wink:). To avoid false positive warnings you must launch shellcheck using `-a -x` arguments to follow source files and from the directory where `airgeddon.sh` is. For example: `~# cd /path/to/airgeddon && shellcheck -a -x airgeddon.sh`
6. Increase the version numbers in `airgeddon.sh`, in [Readme] and in [Changelog] to the new version that the script represents. The versioning scheme we use is *X.YZ*. Where:
  - *X* is a major release with a new menu (e.g. WPS menu)
  - *Y* is a minor release with a new feature for an existing menu or a new submenu for an existing feature
  - *Z* is a minor release with new bug fixes, small modifications or code improvements
7. Split your commits into parts. Each part represents a unique change on files.
8. Direct push to [Master] is not allowed. Pull Requests to [Master] are not allowed. Should be done over [Dev] or any other branch. They require revision and approvement. Read the git workflow policy first. 
9. All the development and coding must be in English.

*Be sure to merge the latest from "upstream" before submitting a pull request!*

#### For plugins development:

1. Read carefully the [Wiki Plugins Development Section].
2. Plugins Pull Requests will never be accepted. Plugins MUST be external to this repository.
3. Develop your plugin following the guidelines and using the plugin template to keep the needed structure.
4. If you want to add your plugin to [Wiki Plugins Hall of Fame Section], follow the instructions explained there. Don't open an issue.

We also have a private Telegram group for *trusted collaborators* for more agile discussion about developments, improvements, etc. 
To be added on it, you must first prove that you are a *trusted collaborator* through your contributions.
Anything can be also discussed on public [IRC] channel or [Discord] server. More info at [Wiki Contact Section].

## WPS PIN Database Collaborators

1. Send MAC of the BSSID and the default PIN to [v1s1t0r.1s.h3r3@gmail.com]. If you are going to push directly into the repository, keep reading the next points and remember about the git workflow policy.
2. Remember that all PINs must be 8 digits and must be working PINs (verified that they work).
3. Add PINs ordered by the key in the associative array located in the `known_pins.db` file. (Keys are the first 6 BSSID digits).
4. Update the `pindb_checksum.txt` file with the calculated checksum of the already modified database file using `md5sum` tool.

*PINs should be from devices that generate generic ones.*

## Beta Testers

1. Download the main version from the [Master] branch or the beta testing version from the development branch called [Dev]. Temporary branches may be existing for specific features that can also be tested.
2. Report any issues or bugs via [IRC] channel, [Discord] server, or submit GitHub issue requests [here] after reading the Issue Creation Policy.

## Git Workflow Policy

1. Direct push to [Master] is not allowed.
2. Pull Requests to [Master] are not allowed.
3. Usually, commits and pull requests should be done on [Dev] branch. If you have any doubt, don't hesitate to ask first.
4. Temporary branches may be existing for specific features, be pretty sure that the branch you are going to commit on is the right one. Ask first if you have any doubt.
5. Any branch will be finally merged to [Dev], there it will be reviewed and tested deeply before being merged to [Master].
6. All merges from [Dev] to [Master] are a new `airgeddon` release. This merges to [Master] will be performed and reviewed exclusively by [v1s1t0r]/[OscarAkaElvis].

---

## Donate or buy merchandising

If you enjoyed the script, feel free to donate. Support the project through PayPal or sending a fraction any of the cryptocurrencies listed below. Any amount, not matter how small (1, 2, 5 $/€) is welcome.

Another way to contribute is buying some merchandising (mugs, T-shirts, etc.). A little portion of each payment (after deducting material, printing and shipping) will be to support the project. Check the [merchandising-online-shop].

<table>
  <tr>
    <td>
      <b>PayPal</b>: <em>v1s1t0r.1s.h3r3&#64;gmail.com</em> <br/>
      <b>Bitcoin</b>: <em>bc1qymhcwsdmw0rn773czet7dv220a4u9fn0278r76</em> <br/>
      <b>Bitcoin Cash</b>: <em>1GspqR87pn8569etY1Qfs3amUGQo9S5a1w</em> <br/>
      <b>BAT</b>: <em>0x1b844e8251Db6A938813466Cf033FAF70c7c94bB</em> <br/>
      <b>Ethereum</b>: <em>0xaEf16Ffbd03A742Ab6DAB8Bd60C6014726099583</em> <br/>
      <b>Litecoin</b>: <em>ltc1q3ncz8gxzvzuekupatpm29k6u3c26cf78tw3zjx</em> <br/>
      <b>Pi</b>: <em>GBWAREEMQJ6VRPXOH2UTXUYSQSKQDJLNKHSDUCBUJVWC2CFIASAZ6I5T</em>
    </td>
  </tr>
</table>

<br/>

<div align="center">
    <a href="https://www.paypal.com/paypalme/airgeddon"><img src="https://raw.githubusercontent.com/v1s1t0r1sh3r3/airgeddon/master/imgs/banners/paypal_donate.png" alt="PayPal" title="PayPal"/></a>
    <a href="https://www.buymeacoffee.com/v1s1t0r"><img src="https://raw.githubusercontent.com/v1s1t0r1sh3r3/airgeddon/master/imgs/banners/buymeacoffee.png" alt="Buy me a coffee" title="Buy me a coffee"/></a>
</div>

<br/>

<div align="center">
  <table>
    <tr>
      <td>
        Bitcoin QR code:
      </td>
      <td>
        Bitcoin Cash QR code:
      </td>
      <td>
        BAT QR code:
      </td>
    </tr>
    <tr>
      <td>
        <img src="https://raw.githubusercontent.com/v1s1t0r1sh3r3/airgeddon/master/imgs/banners/bitcoin_qr.png" alt="Bitcoin" title="Bitcoin"/>
      </td>
      <td>
        <img src="https://raw.githubusercontent.com/v1s1t0r1sh3r3/airgeddon/master/imgs/banners/bitcoincash_qr.png" alt="Bitcoin Cash" title="Bitcoin Cash"/>
      </td>
      <td>
        <img src="https://raw.githubusercontent.com/v1s1t0r1sh3r3/airgeddon/master/imgs/banners/bat_qr.png" alt="BAT" title="BAT"/>
      </td>
    </tr>
    <tr>
      <td>
        Ethereum QR code:
      </td>
      <td>
        Litecoin QR code:
      </td>
      <td>
        Pi QR code:
      </td>
    </tr>
    <tr>
      <td>
        <img src="https://raw.githubusercontent.com/v1s1t0r1sh3r3/airgeddon/master/imgs/banners/ethereum_qr.png" alt="Ethereum" title="Ethereum"/>
      </td>
      <td>
        <img src="https://raw.githubusercontent.com/v1s1t0r1sh3r3/airgeddon/master/imgs/banners/litecoin_qr.png" alt="Litecoin" title="Litecoin"/>
      </td>
      <td>
        <img src="https://raw.githubusercontent.com/v1s1t0r1sh3r3/airgeddon/master/imgs/banners/pi_qr.png" alt="Pi" title="Pi"/>
      </td>
    </tr>
  </table>
</div>

---

## Discord Server Boosting

You can also contribute using your Nitro Boosts on our [Discord] server. After boosting, your name will appear as a _Server Booster_ contributor there. Check [Wiki Contact Section] for more info about how to join to it.

<!-- MDs -->
[Readme]: README.md
[Changelog]: CHANGELOG.md
[Code of Conduct]: CODE_OF_CONDUCT.md

<!-- Github -->
[Shellcheck]: https://github.com/koalaman/shellcheck "shellcheck.hs"
[Here]: https://github.com/v1s1t0r1sh3r3/airgeddon/issues/new/choose
[Master]: https://github.com/v1s1t0r1sh3r3/airgeddon/tree/master
[Dev]: https://github.com/v1s1t0r1sh3r3/airgeddon/tree/dev
[xtonousou]: https://github.com/xtonousou "xT"
[v1s1t0r]: https://github.com/v1s1t0r1sh3r3
[OscarAkaElvis]: https://github.com/OscarAkaElvis
[Wiki Contact Section]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Contact
[Wiki FAQ Section]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/FAQ%20&%20Troubleshooting
[Wiki Plugins Development Section]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Plugins%20Development
[Wiki Plugins Hall of Fame Section]: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Plugins%20Hall%20of%20Fame

<!-- Other -->
[@OscarAkaElvis]: https://twitter.com/OscarAkaElvis
[Discord]: https://discord.gg/sQ9dgt9
[IRC]: https://web.libera.chat/
[merchandising-online-shop]: https://airgeddon.creator-spring.com/
