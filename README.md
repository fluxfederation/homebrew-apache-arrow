# homebrew-apache-arrow

This homebrew tap adds versioned support for apache-arrow recipes, since the SDK's for ruby and other languages can have restrictive dependencies on the version of these libraries, and the pace of the release schedule coupled with homebrew packaging can mean that the version you need is no longer supported by mainline homebrew.

## Usage

```sh
brew tap fluxfederation/homebrew-apache-arrow

# this takes quite a while to compile
brew install apache-arrow@8
brew install apache-arrow-glib@8
```
