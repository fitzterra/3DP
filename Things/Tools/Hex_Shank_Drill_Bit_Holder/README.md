Hex Shank Bits Holder
=====================

This is a remix of the hex bit holder by TBRIshtar on Thingiverse:
http://www.thingiverse.com/thing:241501

This remix mimics the original as close as possible but has the following
features:
 - Almost fully parametric
 - Any number of rows and columns, still keeping the edge rows open on the
   sides. This is nice if the hex shank has the bit size stamped on it.
 - Footer height can be adjusted
 - Wall height can be adjusted
 - Allows easy scaling in the X and Y directions if your printer causes
   the hex holes to be too tight, like mine does.

I use the OpenSCAD fillets lib https://github.com/jfhbrook/openscad-fillets
by jhfbrook for filleting the edges - Thanks jhfbrook!

The `Holder()` module takes all dimensional parameters as arguments, so can
easily be used from other SCAD files.

The original size of the holder by TBRIshtar are the defaults, but simply
override any dimensions you want in subsequent variables of the same name, or
change the originals.

Another quick way to generate STLs for any size is from the command line:

```bash
$ openscad -o output.stl -Dcolumns=7 -Dfoot=3 -D scl=1 bitHolder.scad
```

**Note** when using the command line you must supply the `scl` variable if you
do not want any scaling. This is because the file overrides the default scale
from 1.0 to a scaling I use on my printer. The same goes for `height` and
`foot`.
