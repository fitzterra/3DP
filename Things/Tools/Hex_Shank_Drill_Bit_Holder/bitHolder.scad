/**
 * Remix of hex bit holder by TBRIshtar on Thingiverse:
 * http://www.thingiverse.com/thing:241501
 *
 * This remix mimics the original as close as possible but has the following
 * features:
 *  - Any number of rows and columns, still keeping the edge rows open on the
 *    sides. This is nice if the hex shank has the bit size stamped on it.
 *  - Footer height can be adjusted
 *  - Height can be adjusted
 *  - Allows easy scaling in the X and Y directions if your printer causes
 *    the hex holes to be too tight, like mine does.
 *
 * Author: Fitzterra <fitz_subs@icave.net>  - July 2016
 *
 * License:
 * This work is licensed under the Creative Commons Attribution-ShareAlike 3.0
 * Unported License. To view a copy of this license, visit
 * http://creativecommons.org/licenses/by-sa/3.0/ or send a letter to Creative
 * Commons, PO Box 1866, Mountain View, CA 94042, USA.
 **/

// Fillets library from:
// https://github.com/jfhbrook/openscad-fillets/blob/master/fillets.scad
// Thanks jfhbrook!
use <fillets.scad>;

// Original dimension
rows = 2;       // Number of rows
columns = 5;    // Number of columns
height = 32;    // Height above footer
foot = 3;       // Height of the footer
scl = 1.00;     // Scaling in the X and Y direction - defaults to 1:1

// My overrides
height = 16;    // Don't want it too high
foot = 0.5;     // Like a flat footer
scl = 1.09;     // Works well on my printer


/**
 * Module to generate the hex bit holder
 *
 * Note that this module tries to mimic the original as close as possible and
 * is the reason why the math looks a bit convoluted :-)
 *
 * @param x: num columns
 * @param y: num rows
 * @param f: footer height
 * @param h: height above footer
 **/
module Holder(x=columns, y=rows, f=foot, h=height, s=scl) {
    // Nicely rounded fillets
    $fn=64;

    // Calculate the total width and depth
    w = x*9+1;
    d = y*8.8-2.6;

    // Apply a scaling if needed
    scale([s, s, 1])
        difference() {
            // The main block
            cube([w, d, f+h]);
            // Sink the hex holes
            for(xl=[0:x-1])
                for(yl=[0:y-1])
                    translate([xl*9+5, yl*8.8+3.0, f])
                        cylinder(d=7.8, h=h+1, $fn=6);

            // Fillet the 4 corners
            translate([-0.1, -0.1, -1])
                rotate([0, -90, 180])
                    fil_linear_i(f+h+2, 2.5);
            translate([-0.1, d+0.1, -1])
                rotate([0, -90, 90])
                    fil_linear_i(f+h+2, 2.5);
            translate([w+0.1, -0.1, -1])
                rotate([0, -90, -90])
                    fil_linear_i(f+h+2, 2.5);
            translate([w+0.1, d+0.1, -1])
                rotate([0, -90, 0])
                    fil_linear_i(f+h+2, 2.5);
        }
}


Holder();
