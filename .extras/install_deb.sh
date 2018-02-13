#!/bin/sh
set -e

package=$(basename "$(pwd)")
name=${package%-*}

yes | mk-build-deps -i
debuild -us -uc -b
cd ..
apt-get purge -y --autoremove "$name-build-deps"
dpkg -i "$name"*.deb || apt-get -fy install
