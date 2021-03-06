# how to build new packages and upload to php-osx.liip.ch

The best thing is to have virtual machines with OS X 10.6 and OS X 10.8 with just the needed tools installed. This is mainly XCode from the AppStore, but additionally I installed homebrew with the following packages:

    autoconf        automake        bash-completion git             rpl             wget

(If you're at Liip ask chregu for the images)

Then checkout

    git clone git@github.com:liip/build-entropy-php.git
and

    git clone git@github.com:liip/php-osx.git

preferably in the same parent directory.

Now go into the build-entropy-php directory, checkout a branch and try compiling it with

    sudo bash build-php.sh

this may take a while (up to an hour the first time).

For another branch, clean the build with

    sudo bash deletePeclSources.sh

This will delete all PHP stuff and the extensions, so that you don't have to recompile everything (like icu und libxml) for the next run, if you want a totally clean build, delete /usr/local/php5 and src/* as well.

When you're finished compiling, go to the _php-osx_ directory and call

    bash create_package.sh

This should package and upload all necesseary files.

## The branches

We currently support four PHP versions, 5.3, 5.4, 5.5 and 5.6.  Unfortunately I wasn't able to have a compilation process which can target 10.6, 10.7 and 10.8/9 and 10.10. Therefor you have to compile every version twice. Once for 10.6/7 and once for 10.8, on two different virtual machines with 10.6 and 10.8 (we may ditch older OS Versions one day, and I don't update 10.6/7 every time)

The in total 10 branches are

* 5_3_snowleopard (end of life)
* 5_4_snowleopard
* 5_5_snowleopard
* 5_3_mountainlion (end of life)
* 5_4_mountainlion
* 5_5_mountainlion
* 5_6_mountainlion
* 5_4_yosemite
* 5_5_yosemite
* 5_6_yosemite

Since 5.3 is end of life, we don't upgrade that anymore, except for very special reasons

## Doing a new PHP version

If there's a new PHP version (watch http://php.net/), then you have to do the following

* checkout the right branch in _build-entropy-php_
* adjust the config variable "version" in build-php.pl to the new version (around line 40)
* run _sudo bash deletePeclSources.sh_
* run _sudo bash build-php.sh_
* go to _../php-osx/_ and run _bash create_package.sh_
* repeat for every major version and on both OS

## Merging stuff

If you change something besides the PHP version number, you have to be careful with merging it correctly. Don't just change it in every branch and commit, do it the following way (idea taken from https://wiki.php.net/vcs/gitworkflow)

First, make the adjustements in the _5_5_mountainlion_ branch, commit it and then

    git checkout 5_6_mountainlion
    git merge --log --no-ff 5_5_mountainlion

and on 10.6, we merge from the same PHP version branch from the mountainlion branches (not from the version "below")

    git checkout 5_5_snowleopard
    git merge --log --no-ff origin/5_5_mountainlion

and the same for 10.10

    git checkout 5_5_yosemite
    git merge --log --no-ff origin/5_5_mountainlion
    git checkout 5_6_yosemite
    git merge --log --no-ff origin/5_6_mountainlion
    git checkout 7_0_yosemite
    git merge --log --no-ff origin/5_6_yosemite


This way, we can keep the logs somehow clean and can make sure, everything is merged correctly and everywhere.

This makes for noisy logs somehow, but with

    git log --no-merges

it suddenly is much clearer again (or even better in pretty colors:

     git log --graph --pretty=format:'%Cred%h%Creset %C(cyan)%an%Creset -%C(blue)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative --no-merges

)


## Community feedback and communication

### Twitter

* Tweet as @php_osx, if you do a new release
* Follow on twitter, if someone mentions @php_osx and asks for something

### Github

* Watch https://github.com/liip/php-osx/issues for new issues

### Stackoverflow

* Check http://stackoverflow.com/questions/tagged/php+osx from time to time, if there are any questions there.



