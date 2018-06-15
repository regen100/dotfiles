#!/bin/sh
set -e

package=$(basename "$(pwd)")
name=${package%-*}

yes | sudo mk-build-deps -i
debuild -us -uc -b
cd ..
sudo apt-get purge -y --autoremove "$name-build-deps"
sudo dpkg -i "$name"*.deb || sudo apt-get -fy install
