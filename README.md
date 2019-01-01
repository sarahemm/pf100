# pf100
Ruby tool to communicate via USB with Microlife PF100 meter

Only tested on Mac OS, but should work cross-platform.
<<<<<<< HEAD
Connect meter, run tool, get data. Data is left in the meter unless specifically requested to delete after the download.

=======
Connect meter, run tool, get data. Data is currently not deleted out of meter, so you need to manually delete it once it's downloaded (arrows held together until CLR appears, then press power button).
```
>>>>>>> 2ab2464bbf68dd4f47d122b91730ca7ed6d93f5d
Usage: ./get-pf100 [options]
    -o, --outfile [OUTFILE]          File to write records to
                                     (defaults to stdout)
    -s, --setup                      Perform USB device setup
                                     (required before first run on some platforms)
    -d, --delete                     Delete records from meter after download
    -h, --help                       Show this message
```
