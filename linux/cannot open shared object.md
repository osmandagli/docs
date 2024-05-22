First locate the package 

    find / -name package_name.so

after finding the package location add this location to LD_LIBRARY_PATH

    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/path/to/object
