#! /bin/bash

set -x

# Copy default files if target does not yet exists

if [[ ! -e /opt/fhem/.template_copied_DO_NOT_REMOVE ]]; then
  cd /opt
  tar xvf /usr/local/lib/fhem.tar
  cd fhem-5.6
  cp -rv . /opt/fhem
  chown -R fhem:fhem /opt/fhem
fi

# if `docker run` first argument start with `--` the user is passing fhem launcher arguments
if [[ $# -lt 1 ]] || [[ "$1" == "--"* ]]; then
   cd /opt/fhem
   sudo service sshd start
   perl fhem.pl fhem.cfg "$@"
   exec /bin/bash
fi

# As argument is not fhem, assume user want to run his own process, for sample a `bash` shell to explore this image
exec "$@"
