# go-install

[![Build Status](https://travis-ci.com/mscribellito/go-install.svg?branch=main)](https://travis-ci.com/mscribellito/go-install)

PowerShell script to automate the installation and removal of single user Go.

Tested on:
* Windows 10

## Install

```.\GoInstall.ps1```

## Install Specific Go Version

Pass the `-Version` parameter to the script including the version you want to install:

```.\GoInstall.ps1 -Version 1.15```

## Remove

Pass the `-Remove` parameter to the script:

```.\GoInstall.ps1 -Remove```

## Notes

By default, the script will create `.go` and `go` folders in your user profile directory and add the necessary environment variables.

`~\.go` is the directory where Go will be installed to.

`~\go` is the default workspace directory.
