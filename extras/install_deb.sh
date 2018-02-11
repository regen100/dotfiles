#!/bin/sh
set -e

package=$(basename "$(pwd)")
name=${package%-*}

apt-get install -y --no-install-recommends devscripts equivs
yes | mk-build-deps -i
debuild -us -uc -b
cd ..
apt-get purge -y --autoremove "$name-build-deps" devscripts equivs
dpkg -i "$name"*.deb || apt-get -fy install
