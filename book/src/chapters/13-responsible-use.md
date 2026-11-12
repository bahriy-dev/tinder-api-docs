# Responsible use and the law

Tinder's API is private. Using it puts you in a grey area at best. This
chapter sums up the rules this book is built on and the legal framework to
keep in mind. **This is not legal advice.**

## Five rules

1. **Only your own account.** Use your own session and act on your own data.
   Never use someone else's token, and never create accounts for automation.
2. **Respect other people's privacy.** Profiles, photos and messages belong to
   real people who never agreed to be in your dataset. Don't scrape, store,
   publish or train models on them.
3. **Don't get around protections.** Don't try to beat CAPTCHAs, rate
   limits, phone verification or paywalls. When the API says stop (`403`,
   `429`, CAPTCHA), stop.
4. **No spam, no deception.** Don't send automated messages that pretend to
   be a person. Don't run mass-like or mass-message bots.
5. **Keep it small.** Personal experiments, learning and security research
   with responsible disclosure. Those are the only uses this book supports.

## Terms of Use

Tinder's [Terms of Use](https://policies.tinder.com/terms) restrict
automated access to the service outside the official apps. Accounts used
with unofficial clients can be suspended or permanently banned, and bans are
often tied to the phone number. Read the current terms yourself.

## Data protection

If you process personal data obtained through the API, data protection law
may apply to you too:

| Region | Law | Key point |
| --- | --- | --- |
| EU / EEA | **GDPR** | Sexual orientation and biometric data are special categories (Art. 9). The household exemption is read narrowly. |
| United Kingdom | **UK GDPR** + Data Protection Act 2018 | Same special-category rules as the GDPR |
| California | **CCPA / CPRA** | Categories of sensitive personal information and consumer rights |
| Türkiye | **KVKK** (Law No. 6698) | Data about sex life and biometric data are special categories (Art. 6). Processing them without explicit consent is prohibited as a rule. |

Every profile on a dating app indirectly reveals something about the
person's sexual orientation. That makes **not storing other people's data**
a legal requirement in most cases, not just an ethical choice.

## What this book deliberately leaves out

| Topic | Why |
| --- | --- |
| Account creation, `onboarding` details | Creating accounts programmatically is almost only used for fake or bulk accounts |
| CAPTCHA solving | A direct bypass of a protection |
| Unblurring "Likes You" | Bypasses a paid feature and reveals other people's photos without consent |
| Free Passport (location tricks) | Bypasses a paid feature |
| Mass-like and mass-message bots | Spam that degrades other people's experience |
| Profile scraping and building datasets | Privacy violations and GDPR / KVKK exposure |

## Reporting vulnerabilities

If you find a security vulnerability in Tinder, report it **privately**
through [Tinder's security page](https://www.gotinder.com/security) or Match
Group's bug bounty program. Don't publish working exploit code that exposes
other users.

Some projects call themselves "research" or a "proof of concept" while their
code turns out to bypass paid features. Judge a project by **what it does**,
not by what it calls itself.
