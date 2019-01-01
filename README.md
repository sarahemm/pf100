# pf100
Ruby tool to communicate via USB with Microlife PF100 meter

Only tested on Mac OS, but should work cross-platform.
Connect meter, run tool, get data. Data is currently not deleted out of meter, so you need to manually delete it once it's downloaded (arrows held together until CLR appears, then press power button).
```
Usage: ./get-pf100 [options]
    -o, --outfile [OUTFILE]          File to write records to
                                     (defaults to stdout)
    -s, --setup                      Perform USB device setup
                                     (required before first run on some platforms)
    -h, --help                       Show this message
```
