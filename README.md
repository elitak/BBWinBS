## BusyBox Windows BootStrapper

This is a simple script stub that will allow you to distribute a single .bat file, in which is embedded a bash script that will be interpreted by a mingw32 busybox.exe. If busybox.exe is not distributed alongside this file, it will attempt to fetch and store it in %TEMP%, from ipfs, via https.

To use:
  1. Add your bash code to the bottom of the file.
  2. Rename the file
  3. (Optional) Bundle the .bat, busybox.exe, and any other collateral into a self-extracting, auto-executing archive. This can be done with a makefile + p7zip + the windows PE32 exe stub distributed as part of 7zip. (I may commit that here later)
  4. Distribute.

### License
Licensed under GPLv3.
