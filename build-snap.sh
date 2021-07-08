#!/bin/bash
# Script to clean up and rebuild a snap locally.
# This rebuilds everything from scratch: if you want a faster method
# that doesn't do a clean start, just run "snapcraft".

# Name of the snap as seen in the store
export snapname="lethean-daemon"

# If the command we run is namespaced, optionally add it here
#export commandname=".COMMANDNAME"

# If there are interfaces defined to connect, optionally list them here
# interfaces=(home removable-media)

# We can build in lxd or multipass
# lxd options:
#export SNAPCRAFT_BUILD_ENVIRONMENT=lxd

# multipass options
export SNAPCRAFT_BUILD_ENVIRONMENT=multipass
export SNAPCRAFT_BUILD_ENVIRONMENT_MEMORY=8G
export SNAPCRAFT_BUILD_ENVIRONMENT_CPU=4

# Remove any previous versions of the snap we may have installed
sudo snap remove $snapname

# Remove the entire snap directory for this app so it's definitely clean
rm -rf $HOME/snap/$snapname

# If the snap contains any daemons which run as root, the files will be in
# the root home snap folder, so clean that too
#sudo rm -rf /root/snap/$snapname

# Ensure we're building cleanly
snapcraft clean

# Remove parts folder, as often this has root owned files in it
# This shouldn't be necessary :()
sudo rm -rf ./parts
if [ $? -eq 0 ];
then
  # Start the build
  snapcraft | tee -a buildlog.txt
  if [ $? -eq 0 ];
  then
    # Install the snap which was built
    sudo snap install $snapname*.snap --dangerous
    if [ $? -eq 0 ];
    then
      # Connect any interfaces which may be needed
      for i in ${interfaces[@]}; do
        snap connect $snapname:$i
      done
      # Run the snap
      echo "snap run ${snapname}${commandname}"
    else
      echo "Install failed"
    fi
  else
    echo "Snapcraft failed"
  fi
else
  echo "Clean failed"
fi
