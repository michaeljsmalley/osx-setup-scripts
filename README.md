OS X Deployment Scripts
=======================

These scripts automate the installation of XCode and Command Line Tools on
a vanilla OS X machine running OS X 10.7 / 10.8.

Usage
-----

The install and uninstall scripts can be run individually, or the `bootstrap`
script can be used, which is intended to call all of the other install scripts.

Prerequisites
-------------

To use these scripts, create a file named `config` in the script directory that
looks like so:

```bash
webserver="http://yourserver.com/pathtodirectorywithsoftware/"
```

The required software to place on this webserver in the above directory is:

 * **Xcode**
    * xcode4520418508a.dmg
 * **Command Line Tools (Lion)**
    * xcode452cltools10_76938212a.dmg
 * **Command Line Tools (Mountain Lion)**
    * xcode452cltools10_86938211a.dmg
