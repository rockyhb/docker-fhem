#! /bin/bash

set -e

# Copy files from /usr/share/fhem/ref into /opt/fhem
# So the initial FHEM-HOME is set with expected content. 
# Don't override, as this is just a reference setup, and use from UI 
# can then change this, upgrade plugins, etc.
copy_reference_file() {
	f=${1%/} 
	echo "$f" >> $COPY_REFERENCE_FILE_LOG
    rel=${f:23}
    dir=$(dirname ${f})
    echo " $f -> $rel" >> $COPY_REFERENCE_FILE_LOG
	if [[ ! -e /opt/fhem/${rel} ]] 
	then
		echo "copy $rel to FHEM_HOME" >> $COPY_REFERENCE_FILE_LOG
		mkdir -p /opt/fhem/${dir:23}
		cp -r /usr/share/fhem/ref/${rel} /opt/fhem/${rel};
	fi; 
}
export -f copy_reference_file
echo "--- Copying files at $(date)" >> $COPY_REFERENCE_FILE_LOG
find /usr/share/fhem/ref/ -type f -exec bash -c "copy_reference_file '{}'" \;

# if `docker run` first argument start with `--` the user is passing fhem launcher arguments
if [[ $# -lt 1 ]] || [[ "$1" == "--"* ]]; then
   cd /opt/fhem
   exec perl fhem.pl fhem.cfg "$@"
fi

# As argument is not fhem, assume user want to run his own process, for sample a `bash` shell to explore this image
exec "$@"
