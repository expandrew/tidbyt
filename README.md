# tidbyt

This is my repository for experimenting with Tidbyt development

## Apps

- [**WQXR "What's On?"**](/wqxr/)
  - Show what is currently playing on [WQXR](https://wqxr.org)
- [**All Classical Portland (KQAC) "Now Playing"**](/kqac/)
  - Show what is currently playing on [All Classical Portland (KQAC)](https://allclassical.org)

## Setup

Install [Pixlet](https://tidbyt.dev/docs/build/installing-pixlet):

```zsh
brew install tidbyt/tidbyt/pixlet
```

Log in to Pixlet:

```
pixlet login
```

## Later

- **New York Public Radio**
  - Make a more generic "NYPR What's On?" app that lets you choose from any of the streams on New York Public Radio and show the "What's On" response on the Tidbyt (the API response includes all the different streams, it probably wouldn't be too hard to abstract what I did on the WQXR one above, and remove some of the classical-music-specific things 🤔)
