Gyroscopic Rings Generator
==========================

Summary
-------
This is a parametric version of the excellent Gyroscopic Keyring by
**gianfranco** found here: https://www.thingiverse.com/thing:1307100

Thanks gianfranco!

I wanted to be able to experiment with the number of rings, spacing between
rings, sizes, etc. so created this parametric version that allows the customizer
in OpenSCAD or the Thingiverse customizer to be used to alter the
model.

The default settings will generate a model that is almost identical to the one
above, but using the customizer, either the one built into OpenSCAD from the
latest development snapshot versions (these are very stable), or the Thingiverse
one, you can modify many settings to generate your own version by:

 * changing the inner ring size and central hole size - this affects the final
   gyro size
 * setting the gap size between the rings
 * setting the thickness of the rings
 * setting the height
 * adding an optional key ring loop - this can also be customized in different
   ways and orientation

With the OpenSCAD customizer (not sure if this can be done with Thingiverse
customizer) you can also get a center sliced view with some transparency in the
rings to get a better view of what the model will look like in the center - this
may help decide if your printer tolerances would allow a good print, or just to
see what the center looks like since you never see it after a print :-)

Designed Details
----------------
Designed in OpenSCAD using the `sphere` function to generate hollow _balls_ that
fit around each other concentrically, and then slicing top and bottom.

Most options are parametric and can be configured via the Customizer built into
the latest OpenSCAD development builds (as of early 2018). Using the customizer
in OpenSCAD makes it easier to test and modify the code.

![OpenSCAD customizer][screenshot1]

I use an external editor for coding, so that is why you do not see the code
panel in the screenshot above.

The code is fairly modular and well commented and should be fairly easy to
extend.



[screenshot1]: images/OpenSCAD-customizer.png "Using the openSCAD customizer to see a center sliced view of a 3 ring gyro."
