# BabyBot LCD Bracket

A bracket to place the BabyBot LCD outside of the frame and allow placing the
LCD at and angle for easier viewing.

On the [OpenHardware](http://help.openhardware.co.za) designed **BabyBot 3DP**,
the optional LCD display is mounted flat in the bottom of the frame. This makes
it difficult to read the display when your point of view is at print head or
higher level. This is normally the case when the printer in placed on a
workbench or table.

This bracket makes it possible to move the LCD out of the frame and angle it at
any (*sane*) angle to make it easier to read from above. The bracket is
parametrically designed and almost all parts can be adjusted.

The [OpenSCAD](www.openscad.org) file allows for a simulation view where a part
of the printer front face, this bracket and the LCD module are put together to
see how it will look and fit. The LCD has a 90° header, with connector pins, at
the back that needs to clear the frame and bracket. The simulation view can be
used to visually inspect that it does, while adjusting parameters for the best
fit.

To generate the bracket for print, set the `sim` variable to 0.

## Parametric design features:
 * Frame thickness can be adjusted
 * Frame beam width can be adjusted
 * Mounting hole diameters can be adjusted
 * Mounting tab diameters can be adjusted
 * LCD module mount offset diameters can be adjusted
 * LCD module tilt angle can be adjusted
 * LCD module offset from frame can be adjusted

## TODO:
 * Refactor all parameters so that they can all be adjusted from one single lot
   of global variables.
 * Automatically calculate the positioning of the LCD in simulation mode.
 * Add an animation mode that will auto rotate the simulation view.
 * Allow all colors to be modified

