# homebrew-apache-arrow

This homebrew tap adds versioned support for apache-arrow recipes, since the SDK's for ruby and other languages can have restrictive dependencies on the version of these libraries, and the pace of the release schedule coupled with homebrew packaging can mean that the version you need is no longer supported by mainline homebrew.

## Install

```sh
brew tap fluxfederation/homebrew-apache-arrow

# this takes quite a while to compile
brew install apache-arrow@8
brew install apache-arrow-glib@8
```

## Usage

If you are having issues installing libraries dependent on these (i.e. rubygems) that fail compiling native extensions against newer arrow libraries, unlink the newer unversioned stock homebrew packages like so:

View installed versions:

```sh
brew list | grep arrow
apache-arrow
apache-arrow-glib

brew info apache-arrow

==> apache-arrow: stable 10.0.1 (bottled), HEAD
Columnar in-memory analytics layer designed to accelerate big data
https://arrow.apache.org/
/usr/local/Cellar/apache-arrow/10.0.0 (558 files, 177.8MB) *
  Poured from bottle on 2022-11-09 at 11:52:39
From: https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/apache-arrow.rb
License: Apache-2.0
==> Dependencies
Build: boost ✘, cmake ✘, llvm ✘
Required: aws-sdk-cpp ✘, brotli ✔, bzip2 ✔, glog ✔, grpc ✘, lz4 ✔, openssl@1.1 ✔, protobuf ✘, rapidjson ✔, re2 ✘, snappy ✔, thrift ✔, utf8proc ✔, z3 ✘, zstd ✔
==> Options
--HEAD
	Install HEAD version
==> Analytics
install: 21,396 (30 days), 38,178 (90 days), 60,200 (365 days)
install-on-request: 3,747 (30 days), 9,397 (90 days), 24,575 (365 days)
build-error: 0 (30 days)
```

Unlink newer build, and link version 8:

```sh
brew unlink apache-arrow-glib
brew unlink apache-arrow

# If the compile succeed, but linking failed, no need to re-compile just link it so gem install detects this version
brew link apache-arrow@8
brew link apache-arrow-glib@8
```
