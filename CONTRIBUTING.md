# Contributing

Hi there! We are thrilled that you would like to contribute to this project. Your help is essential for keeping it great.

When contributing to this repository, please first discuss the change you wish to make via issue,
email, or any other method with the owners of this repository before making a change.
If an issue is opened and more info is needed, `airgeddon` staff will request it. If there is no answer in 7 days, the issue will be closed.

Please note we have a code of conduct, please follow it in all your interactions with the project.

---

## Collaborating Translators

1. Update the date under shebang.
2. Translate the strings located in `language_strings.sh`.
3. Ask by mail [v1s1t0r.1s.h3r3@gmail.com] if you have any doubt. You'll be informed about how to proceed.
4. You can be added as a collaborator on the project.
5. Knowledge about `git` is not mandatory but is really appreciated to push directly into the project repository.

## Collaborating Developers

1. Tweak *"debug_mode"* variable to "1" for faster development skipping intro and initial checks or to "2" for verbosity and the skips mentioned before.
2. Respect the **2 width tab indentation**, code style and the **UTF-8 encoding**.
3. Use **LF** (Unix) line break type (not CR or CRLF).
4. Use [Shellcheck] to search for errors and warnings on code. (Thanks [xtonousou] for the tip :wink:). To avoid false positive warnings you must launch shellcheck using `-x` argument to follow source files and from the directory where `airgeddon.sh` is. For example: `cd /path/to/airgeddon && shellcheck -x airgeddon.sh`
5. Increase the version numbers in `airgeddon.sh`, in [Readme] and in [Changelog] to the new version that the script represents. The versioning scheme we use is *X.YZ*. Where:
  - *X* is a major release with a new menu (e.g. WPS menu)
  - *Y* is a minor release with a new feature for an existing menu or a new submenu for an existing feature
  - *Z* is a minor release with new bug fixes, small modifications or code improvements
6. Update the date on `.sh` and `.db` files under shebang, if appropriate.
7. Split your commits into parts. Each part represents a unique change on files.
8. Direct push to [Master] is not allowed.
9. Pull Requests to [Master] are not allowed. Should be done over [Dev] or any other branch. They require revision and approvement.
10. All the development and coding must be in English.

*Be sure to merge the latest from "upstream" before making a pull request!*

We also have a private Telegram group for *trusted collaborators* for more agile discussion about developments, improvements, etc. 
To be added on it you must prove first you are a *trusted collaborator* with your contributions.

## WPS PIN Database Collaborators

1. Send MAC of the BSSID and the default PIN to [v1s1t0r.1s.h3r3@gmail.com]. If you are going to push directly into the repository, keep reading the next points.
2. Add PINs ordered by the key in the associative array located in the `known_pins.db` file. (Keys are the first 6 BSSID digits).
3. Update the `pindb_checksum.txt` file with the calculated checksum of the database file using `md5sum` tool.
4. Update the date under shebang.

*PINs should be from devices that generate generic ones.*

## Beta Testers

1. Download the master version or the beta testing version from the development branch called [Dev]. Temporary branches may be existing for specific features that can be tested too.
2. Report any issues or bugs by mail [v1s1t0r.1s.h3r3@gmail.com] or submit issue requests [Here].

---

## Code of Conduct

### Our Pledge

In the interest of fostering an open and welcoming environment, we as
contributors and maintainers pledge to making participation in our project and
our community a harassment-free experience for everyone, regardless of age, body
size, disability, ethnicity, gender identity and expression, level of experience,
nationality, personal appearance, race, religion, or sexual identity and
orientation.

### Our Standards

Examples of behavior that contributes to creating a positive environment
include:

* Using welcoming and inclusive language
* Being respectful of differing viewpoints and experiences
* Gracefully accepting constructive criticism
* Focusing on what is best for the community
* Showing empathy towards other community members

Examples of unacceptable behavior by participants include:

* The use of sexualized language or imagery and unwelcome sexual attention or
advances
* Trolling, insulting/derogatory comments, and personal or political attacks
* Public or private harassment
* Publishing others' private information, such as a physical or electronic
  address, without explicit permission
* Other conduct which could reasonably be considered inappropriate in a
  professional setting

### Our Responsibilities

Project maintainers are responsible for clarifying the standards of acceptable
behavior and are expected to take appropriate and fair corrective action in
response to any instances of unacceptable behavior.

Project maintainers have the right and responsibility to remove, edit, or
reject comments, commits, code, wiki edits, issues, and other contributions
that are not aligned to this Code of Conduct, or to ban temporarily or
permanently any contributor for other behaviors that they deem inappropriate,
threatening, offensive, or harmful.

### Scope

This Code of Conduct applies both within project spaces and in public spaces
when an individual is representing the project or its community. Examples of
representing a project or community include using an official project e-mail
address, posting via an official social media account, or acting as an appointed
representative at an online or offline event. Representation of a project may be
further defined and clarified by project maintainers.

### Enforcement

Instances of abusive, harassing, or otherwise unacceptable behavior may be
reported by contacting us at [v1s1t0r.1s.h3r3@gmail.com]. All
complaints will be reviewed and investigated and will result in a response that
is deemed necessary and appropriate to the circumstances. The project team is
obligated to maintain confidentiality with regard to the reporter of an incident.
Further details of specific enforcement policies may be posted separately.

Project maintainers who do not follow or enforce the Code of Conduct in good
faith may face temporary or permanent repercussions as determined by other
members of the project's leadership.

### Attribution

This Code of Conduct is adapted from the [Contributor Covenant][Homepage], version 1.4,
available at [http://contributor-covenant.org/version/1/4][Version]

---

## Donate

If you enjoyed the script, feel free to donate. Support the project through Paypal or sending a fraction of a bitcoin:

<table>
  <tr>
    <td>
      Paypal: <em>v1s1t0r.1s.h3r3&#64;gmail.com</em> <br/>
      Bitcoin: <em>1AKnTXbomtwUzrm81FRzi5acSSXxGteGTH</em>
    </td>
  </tr>
</table>

[![Paypal][Paypal]](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=7ELM486P7XKKG)
&nbsp;
[![Bitcoin][Bitcoin]](https://blockchain.info/address/1AKnTXbomtwUzrm81FRzi5acSSXxGteGTH)

Bitcoin QR code:

[![BitcoinQR][BitcoinQR]](https://blockchain.info/address/1AKnTXbomtwUzrm81FRzi5acSSXxGteGTH)

<!-- MDs -->
[Readme]: README.md
[Changelog]: CHANGELOG.md

<!-- Code of Conduct -->
[Homepage]: http://contributor-covenant.org
[Version]: http://contributor-covenant.org/version/1/4/

<!-- Github -->
[Shellcheck]: https://github.com/koalaman/shellcheck "shellcheck.hs"
[Here]: https://github.com/v1s1t0r1sh3r3/airgeddon/issues/new
[Master]: https://github.com/v1s1t0r1sh3r3/airgeddon/tree/master
[Dev]: https://github.com/v1s1t0r1sh3r3/airgeddon/tree/dev
[xtonousou]: https://github.com/xtonousou "xT"

<!-- Images -->
[Paypal]: /imgs/banners/paypal_donate.png "Show me the money!"
[Bitcoin]: /imgs/banners/bitcoin_donate.png "Show me the money!"
[BitcoinQR]: /imgs/banners/bitcoin_qr.png "Show me the money!"
