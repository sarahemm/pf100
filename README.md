# pf100
Ruby tool to communicate via USB with Microlife PF100 meter

Only tested on Mac OS, but should work cross-platform.
Connect meter, run tool, get data. Data is left in the meter unless specifically requested to delete after the download.

Usage: ./get-pf100 [options]
    -o, --outfile [OUTFILE]          File to write records to
                                     (defaults to stdout)
    -s, --setup                      Perform USB device setup
                                     (required before first run on some platforms)
    -d, --delete                     Delete records from meter after download
    -h, --help                       Show this message

