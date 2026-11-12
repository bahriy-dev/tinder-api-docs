# Preface

Tinder has no public, documented developer API. Even so, for more than a
decade hundreds of developers have studied how the app talks to its own
servers, taken notes and written libraries. That knowledge is now scattered
across dozens of GitHub repositories, old gists and issue threads, and much
of it no longer holds.

This handbook brings that knowledge together. It is more than a list: every
endpoint was compared against at least one piece of **source code**, each
fact is marked with the period it belongs to, and contradictions are called
out explicitly.

## Who this book is for

- **Developers** curious about Tinder's client–server architecture
- **Students** who want to see how a reverse-engineered API evolves over time
- People who want to run small experiments on **their own** account data
- Security and privacy **researchers**

There is nothing here for anyone who wants to create accounts in bulk, unlock
paid features for free or collect other people's data. The reasons are in
[Responsible use and the law](chapters/13-responsible-use.md).

## How to read it

| Your goal | Reading order |
| --- | --- |
| See the big picture | 1 → 2 → 10 → 11 |
| Write a client | 1 → 2 → 3 → 4–9 → 12 |
| Pick an existing library | 11 → Appendix A |
| Look up an endpoint quickly | 10 (reference matrix) |

## Markers

Throughout the book, the freshness of each fact is marked like this:

| Marker | Meaning |
| :---: | --- |
| 🟢 **Current** | Used in at least one client maintained in 2025–2026 |
| 🟡 **Uncertain** | Only seen in 2020–2024 material; it may still work |
| 🔴 **Historical** | Pre-2020 and very likely broken |
| 💳 | Requires a paid subscription (Plus, Gold, Platinum) |

> **Important:** None of the requests in this book were tried against a real
> Tinder account. The material is based on the code and documentation of
> open-source projects. It was last verified on **12 November 2026**.

## Not affiliated with Tinder

Tinder is a trademark of Match Group, LLC. This book is not approved,
endorsed or supported by Match Group and has no connection to it. The name is
used only to identify the system being described.

— Bahri Yilmaz
