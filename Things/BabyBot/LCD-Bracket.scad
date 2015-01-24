/**
 * A bracket to place the BabyBot LCD outside of frame and allow angling for
 * easier viewing.
 *
 * On the OpenHardware (http://help.openhardware.co.za) designed BabyBot 3DP,
 * the optional LCD display is mounted flat in the bottom of the frame. This
 * makes it difficult to read the display when your point of view is at print
 * head or higher level.
 *
 * This bracket makes it possible to move the LCD out of the frame and angle it
 * at any (sane) angle to make it easier to read from above. The bracket is
 * parametrically designed and almost all parts can be adjusted.
 *
 * This file allows for a simulation view where the LCD mount hole in the printer
 * frame, the bracket and the LCD module are put together to see how it will look
 * and fit. THe LCD has a 90deg header at the back that needs to cleat the frame
 * and bracket. The simulation view can be used for that while adjusting parameters
 * for the best fit.
 *
 * To generate the bracket for print, set the 'sim' variable to 0.
 *
 * Parametric design features:
 *  - Frame thickness can be adjusted
 *  - Frame beam width can be ajusted
 *  - Mounting hole diameters can be adjusted
 *  - Mounting tab diameters can be adjusted
 *  - LCD module mount offset diameters can be adjusted
 *  - LCD module tilt angle can be adjusted
 *  - LCD module offset from frame can be adjusted
 *
 *  TODO:
 *   - Refactor all parameters so that they can all be adjusted from one single
 *     lot of global variables.
 *   - Automatically calculate the positioning of the LCD in simulation mode.
 *   - Add an animation mode that will auto rotate the simulation view.
 *   - Allow all colors to be modified
 *
 *   @author: Fitzterra <fitzterra@icave.net>
 *   @date: 19 January 2015
 *   @version: 1.0
 *      
 */

// Set to 1 to simulate, 0 to generate for manufacture
sim = 0;

if(sim==1) {
	color("OrangeRed")
		FrameSample();
	color("LawnGreen")
		Bracket($fn=60);
    // For now these must still be adjusted manually - especially the last value
    // in the Y translation value when adjusting the offsets length.
	translate([7/2-(3/2+1), -3-1.7-28.3, 7/2-(3/2+1)+7/2-1.6])
		rotate([-45, 0, 0])
			LCDBoard();
} else if(sim==0) {
	color("LawnGreen")
		// Rotate it flat on it's back
		rotate([-90, 0, 0])
			Bracket($fn=60);
} else {
    echo("Will try add animation for sim value other than 1 or 0.");
}

/**
 * Module to generate the bracket horizontal offsets to fit the LCD board given
 * the LCD board dimensions, the required offset from the top and some other
 * parameters.
 * 
 * @param angle The tilt angle
 * @param offsT The offset the top hole center must be from the frame top.
 * @param offsD The diameter for the offset pieces
 * @param zero If true, the offsets will be placed at the 0,0,0 position as a
 *        block after drawing them.
 * @param pcbH  Height of the PCB
 * @param pcbW  Width of the PCB
 * @param pcbHD PCB mounting hole diameter
 * @param pcbHS The amount of space between the hole edge and the PCB edge
 */
module Offsets(angle, offsT, offsD=7, zero=true, pcbH=36, pcbW=80, pcbHD=3, pcbHS=1) {
    // Calculate the hole center offset from the edge of the PCB
    pcbHO = pcbHS + pcbHD/2;
    // This is the length from the bottom of the PCB to the center of the top
    // hole. This will be the hypotenuse for the tilt triangle to calculate the
    // position of the top hole center in the XZ plane.
    hypoT = pcbH - pcbHO;
    // And this is the hypotenuse for the bottom hole center
    hypoB = pcbHO;
    // The Z height for the top hole after the tilt
    thZ = cos(angle)*hypoT;
    // The amount of movement in the Y Axis for the top hole after the tilt
    thY = sin(angle)*hypoT;
    // THe top hole X poition. THis is simply it's offset from the X PCB edge
    thX = pcbHO;
    // The Z height for the bottom hole after the tilt
    bhZ = cos(angle)*hypoB;
    // The amount of movement in the Y Axis for the bottom hole after the tilt
    bhY = sin(angle)*hypoB;
    // THe bottom hole X poition. THis is simply it's offset from the X PCB edge
    bhX = pcbHO;

    // Calculate the length of the top and bottom offsets so it extends into the
    // board.
    tOffs = offsT+5;
    // The bottom offset is the top offset + difference between top and bottom
    // hole centers in the Y plane + some extra to extend into the board
    bOffs = offsT +(thY-bhY) + 5;

    // The zero placement if needed
    zp = (zero==true) ? [offsD/2-pcbHO, -thY-offsT, offsD/2-bhZ] : [0, 0, 0];
    
    /**
     * Sub module to draw the top and bottom offsets once the Y and Z points, and
     * the offset lenghts for top and bottom has been calculated.
     *
     * @param x THe x value to place center to the center of the left of right
     * set of holes.
     */
    module topBotOffsets(x) {
        // Place the offsets, then cut holes for the mounting screws
        difference() {
            union() {
                // Place the top offset
                translate([x, thY, thZ])
                    // The cube is placed centered, but we need to pull it back
                    // in the Y plane just enough to leave so part extending over
                    // the board when we do the final placement
                    translate([0, tOffs/2-5, 0])
                        // The top offset
                        //cube([offsD, tOffs, offsD], center=true, $fn=60);
                        rotate([-90, 0, 0])
                            cylinder(d=offsD, h=tOffs, center=true, $fn=60);
                            
                // Place the bottom offset
                translate([x, bhY, bhZ])
                    // The cube is placed centered, but we need to pull it back
                    // in the Y plane just enough to leave so part extending over
                    // the board when we do the final placement
                    translate([0, bOffs/2-5, 0])
                        // The top offset
                        //cube([offsD, bOffs, offsD], center=true, $fn=60);
                        rotate([-90, 0, 0])
                            cylinder(d=offsD, h=bOffs, center=true, $fn=60);
            }

            // Now the screw cylinders to take subtract from the offsets
            union() {
                translate([x, thY, thZ])
                    rotate([90-angle, 0, 0])
                        cylinder(d=pcbHD, h=(100-angle)*0.3, center=true, $fn=50);
                translate([x, bhY, bhZ])
                    rotate([90-angle, 0, 0])
                    cylinder(d=pcbHD, h=(100-angle)*0.3, center=true, $fn=50);
            }
        }
    }

    // We have everything we need now. Do the zero placement if needed
    translate(zp) {
        // Draw the left and right sets of offsets
        // and slice them at the LCD board placement angle and position.
        difference() {
            union() {
                // First the left side
                topBotOffsets(pcbHO);
                // ...then right side
                topBotOffsets(pcbW-pcbHO);
            }

            // A cube tilted at the PCB angle to slice the offset ends at exactly the
            // position the LCD board will mount to
            rotate([-angle, 0, 0])
                translate([-5, -15, -10])
                    cube([pcbW+10, 15, pcbH+10]);

            // Cut off any pointy exxcess for the bottom offsets
            translate([-5, -15, -10])
                cube([pcbW+10, 15, pcbH+10]);
        }
    }
}

/***
 *
 * Draws the LCD bracket.
 *
 * @param cow The square cutout width in the face place
 * @param coh The square cutout height in the face place
 * @param mhd The mounting holes diameter
 * @param mhox The X offset the mounting holes are from the corners [1]
 * @param mhoz The Z offset the mounting holes are from the corners [1]
 * @param mtd The mounting tab diameter
 *
 * Note 1: All 4 mounting holes are the same X and Z offsets from their
 *         respective corners. The mhox and mhoz parameters are always given as
 *         positive values irrespective of the holes position relative to the
 *         corner. Note that since the face is drawn with height in the Z
 *         direction, the up/down offset parameter for the hole uses Z to
 *         indicate the offset direction.
 */
module Bracket(cow=69, coh=21, mhd=3, mhox=3, mhoz=5, mtd=7) {
	// The frame width is the width of any frame beam.
	fw = mhd;
	// The frame thickness is the thickess for any frame beam.
	ft = 3;
	// Offset for the vertical supports into the cutout area
	vso = 5;
    // The LCD angle
    angle = 45;

    /***
     *
	 * Inner module to create a cross beam. THe beam will have two circles with
	 * holes at the ends to fit over the mounting holes in the face.
	 * 
	 * @param w The beam width. This should be the width between the mounting
	 *          hole centers in the face. Default is to calculate this from the
	 *          cutout w and the mounting hole X offset.
	 * @param h The beam height. Default is the frame width.
	 * @param t The beam thickess. Default is the frame thickess.
	 * @param hd The mounting hole diameter.
	 * @param td The tab diameter
     */
	module XBeam(w=cow+mhox*2, h=fw, t=ft, hd=mhd, td=mtd) {
		// The beam. We move it right and up so left mounting tab does not
        // cross the Z or X axis.
		translate([td/2, 0, td/2-hd/2])
			cube([w, t, h]);
		// A mounting tab at each end of the beam. The tabs are drawned at the
		// center position and all 3 axiss of each tab needs to be adjusted.
		for(i=[[td/2, t/2, td/2],
			   [w+td/2, t/2, td/2] ]) {
			// Position it
			translate(i)
				// The mount tab and hole. The tab will be drawn standing up, so
				// we need to rotate it on the X axis
				rotate([90, 0, 0])
					// The tab
					cylinder(h=t, d=td, center=true);
		}
	}

    /**
     * The frame consists of the cross and vertical beams, the mounting tabs and
     * LCD board mounting offsets. It is made a module so we can cut the mounting
     * holes out later.
     */
    module Frame() {
        // The top beam
        translate([0, 0, coh+mhoz*2])
            XBeam();
        // Bottom beam
            XBeam();
        // Two vertical support beams
        for(i=[ [mtd/2-fw/2+cow/4, 0, mtd/2],
                [mtd/2-fw/2+cow*3/4+2*mhox, 0, mtd/2] ]) {
            // Do positioning
            translate(i)
                // THe support
                cube([fw, ft, coh+mhoz*2]);
        }

        // Add the offsets at 0,0,0 but move it slightly in on the Y axis to
        // overlap the frame to ensure the bracket is manifold/watertight at the
        // frame/offsets intersection
        translate([0, 0.1, 0])
            Offsets(angle, vso);

        // Calculate the height of the top LCD mounting holes center Z postion, using
        // the distance between the centers of the face mounting hole as the
        // hypotenuse to the tilt angle triangle. To get the correct height, half
        // mounting tab diameter must also be added
        thZ = cos(angle)*(coh+mhoz*2) + mtd/2;
        // Extend the top mounting offsets to be flush with the back of the bracket.
        // This only needs to be done for the top offsets since the bottom offsets
        // fits flush against the bottom mounting tabs.
        for(i=[ [mtd/2, ft/2, thZ],
                [mtd/2+cow+2*mhox, ft/2, thZ] ]) {
            translate(i)
                rotate([-90, 0, 0])
                    cylinder(d=mtd, h=ft, center=true);
        }

        // Calculate the length of the support from the top bracket mounting tab to
        // top mounting offset. This is the length between the mounting tab hole
        // center and the thZ hole center calculated above.
        tsl = (mtd/2+coh+mhoz*2) - thZ;
        // If this is more than half a mounting tab diameter, add supports
        echo("tsl: ", tsl);
        if(tsl>0) {
            for(i=[ [0, 0, thZ],
                    [cow+2*mhox, 0, thZ] ]) {
                translate(i)
                cube([mtd, ft, tsl]);
            }
        }
    }

    /**
     * Cylinders as screws to be used to subtract holes from frame.
     */
    module FrameHoles() {
        hdp = 6; // Mounting hole depth
        // Add screw holes in the mounting tabs
        for(i=[ [0+mtd/2, -hdp/2+ft+1, 0+mtd/2],
                [0+mtd/2, -hdp/2+ft+1, coh+2*mhoz+mtd/2],
                [cow+2*mhox+mtd/2, -hdp/2+ft+1, coh+2*mhoz+mtd/2],
                [cow+2*mhox+mtd/2, -hdp/2+ft+1, 0+mtd/2] ]) {
            translate(i)
                rotate([-90, 0, 0])
                    cylinder(d=mhd, h=hdp, center=true);
        }
    }

    // Make the frame and then cut out the mounting holes. Also move the final
    // bracket forward by the frame thickness
    translate([0, -ft, 0])
        difference() {
            Frame();
            FrameHoles();
        }

}

/***
 * Draws a sample of the part of theframe where the bracket will be attached to.
 * This helps visually seeing where the bracket will go and the angle.
 *
 * @param h The sample height
 * @param w The sample width
 * @param t The frame thickness
 * @param cow The square cutout width
 * @param coh The square cutout height
 * @param mhd The mounting holes diameter
 * @param mhox The X offset the mounting holes are from the corners [1]
 * @param mhoz The Z offset the mounting holes are from the corners [1]
 * @param td The diameter for the mounting tab for the bracket      [2]
 *
 * Note 1: All 4 mounting holes are the same X and Z offsets from their
 *         respective corners. The mhox and mhoz parameters are always given as
 *         positive values irrespective of the holes position relative to the
 *         corner. Note that since the face is drawn with height in the Z
 *         direction, the up/down offset parameter for the hole uses Z to
 *         indicate the offset direction.
 * Note 2: These parameters are only needed if the sample faceplate needs to be
 *         offset so that the mounting bracket can always be drawn at 0,0,0 but
 *         the sample faceplate made to fit behind the bracket. See the noOffset
 *         variable inside the module.
 */
module FrameSample(h=50, w=100, t=2, cow=69, coh=21, mhd=3.5, mhox=3, mhoz=5, td=7) {
	// Set this to 1 to NOT offset the face to fit the bracket.
	noOffset = 0;

	// Do we offset the face so the bracket drawn at 0, 0, 0 aligns with the face
	// plate sample?
	brackefOffset = (noOffset==1) ? [0,0,0] : [-(w-cow-2*mhox-td)/2, 0, -(h-coh-2*mhoz-td)/2];

	// Optionally offset the face
	translate(brackefOffset)
		// Faceplate sample is a plate with a cutout and mounting holes
		difference() {
			// The plate
			cube([w, t, h]);
			// The square hole in the plate. We overlap the cutout by 1mm back
			// and front of the plate (y-axis) to ensure faces are cut through.
			translate([(w-cow)/2, -1, (h-coh)/2])
				// The +2 on the y-axis is for the overlap - see above.
				cube([cow, t+2, coh]);
			// The 4 mounting holes - loop through their respective offsets from
			// the corners.
			for(i = [ [(w-cow)/2-mhox, 0, (h-coh)/2-mhoz], // Bottom left
					  [(w-cow)/2-mhox, 0, (h-coh)/2+coh+mhoz],
					  [(w-cow)/2+cow+mhox, 0, (h-coh)/2+coh+mhoz],
					  [(w-cow)/2+cow+mhox, 0, (h-coh)/2-mhoz] ]) {
				// Position the cylinder - but still upright at the moment
				translate(i)
					// Rotate it flat with the face plate
					rotate([90, 0, 0])
						// But now it is in front of the face place, so move it
						// back into the place but overlap 1mm so we cut through
						// the face cleanly. Note the cylinder is made 2mm deeper
						// as well. Because of the rotate, we need to move the Z
						// axis to move have it actually move in the Y axis on
						// drawing!
						translate([0, 0, -t-1])
							cylinder(d=mhd, h=t+2, $fn=50);
			}
		}
}

/***
 * The LCD Display
 *
 * @param PCBOnly If true, then only the PCB will be drawn. This can be used to
 *        cut/intersect sections where the LCD should be mounted to.
 * @param ssl Screw Stub length. If PCBOnly is true, screw stubs are automatically
 *        added. This parameters sets the overall length for the screw stubs.
 * @param ssd Screw Stub Diameter. See ssl for more info.
 */
module LCDBoard(PCBOnly=false, ssl=6, ssd=3) {
	$fn = 50;
	pcbT = 1.7;	// PCB Thickness
	lcdT = 6.8; // LCD Thickness

	/***
     * The main PCB with the gold plated mounting through holes.
     */
	module MainPCB() {
		// Dimensions
		w = 80;	// Width
		h = 36;	// Height
		t = pcbT;	// Thickness
		hd = 3;	// Hole diameter
		ho = 1 + hd/2;	// Hole center offset from corners	

		difference() {
			union() {
				color("ForestGreen")
					// The board
					cube([w, t, h]);
				// Add the gold plated holes
				// The hole positions for each corner
				for(i=[ [ho, 0, ho],
						[ho, 0, h-ho],
						[w-ho, 0, h-ho],
						[w-ho, 0, ho] ]) {
					// Position it
					translate(i) {
						// Move it back to behind the X Axis
						translate([0, t/2, 0])
							// Rotate it upright
							rotate([90, 0, 0])
								// The Gold plating with 0.1mm on both sides thicker
								// than PCB
								color("Gold")
									cylinder(h=t+0.2, d=ho*2-0.05, center=true);
					}
				}
			}
			// Now the mounting holes
			// The hole positions for each corner
			for(i=[ [ho, 0, ho],
					[ho, 0, h-ho],
					[w-ho, 0, h-ho],
					[w-ho, 0, ho] ]) {
				// Position it
				translate(i) {
					// Move it back to behind the X Axis
					translate([0, t/2, 0])
						// Rotate it upright
						rotate([90, 0, 0])
							// Hole slightly higher than gold cylinder to ensure
							// it punches through faces.
							cylinder(h=t+2, d=hd, center=true);
				}
			}
		}

        // If we do the PCB only, then we allso add screw posts that could
        // be used to create holes into the surface the board is being
        // mounted on.
        if(PCBOnly==true) {
            // The hole positions for each corner
            for(i=[ [ho, 0, ho],
                    [ho, 0, h-ho],
                    [w-ho, 0, h-ho],
                    [w-ho, 0, ho] ]) {
                // Position it
                translate(i) {
                    // Move it back to behind the X Axis
                    translate([0, ssl/2-1, 0])
                        // Rotate it upright
                        rotate([90, 0, 0])
                            // The screw stub
                            color("Silver")
                                cylinder(h=ssl, d=ssd, center=true);
                }
            }
        }
	}

	/**
     * A very simple LCD simulation. Not to scale, only to determine fit.
     */
	module LCD() {
		w = 71; // Width
		h = 24; // Height
		t = 6.8;    // Thickness/Depth
        dd = 2; // Depth the display is sunk into the frame
		fw = 5;	// Frame width around display

        // Do the black frame block and then cut out the the bit to show the
        // sunken display
		difference() {
			color("Black") {
				cube([w, t, h]);
			}
            // The sunken display bit.
			translate([fw, -1, fw])
				cube([w-fw*2, dd, h-2*fw]);
		}
	}

	/***
     * The control PCB sitting behind the display.
     *
     * Only the blue trimpot and the angled headers are show since this is all
     * that is needed to determine the outer extremes of the board.
     */
	module ControlPCB() {
		w = 41.5;   // PCB width
		h = 19.9;   // and height
		t = 1.5;    // and thickness

		
		// PCB
		color("DarkGreen")
			cube([w, t, h]);
		// Trimpot
		translate([7.3, t, 8])
			color("SteelBlue")
				cube([6.8, 4.7, 6.8]);
		// 4 Pin header, after rotation it sits below the X axis, so we need to
		// move it up by the num pins (4) times the pitch (2.54) plus the amount
		// of space to the bottom of the PCB.
		translate([0, t, 5.25+4*2.54])
			rotate([-90, 0, 0])
				Header90(4);
		// 2 Pin header on the other side
		translate([w, t, 8.15])
			rotate([90, 0, 180])
				Header90(2);
	}
	
	/***
     * Draws a 90° angled header with the number of pins specified.
	 *
	 * @param pins The number of pins to add to the header.
     * @param p Pin pitch
     * @param v Vertival pin len above spacer block
     * @param h Horizontal pin length
     * @param s The pin size - it is assumed the width and depth are the same
     *          (square pin)
	 *
	 * See the HeaderPin90 module for the meaning of he other parameters.
     */
	module Header90(pins, p=2.54, v=1.6, h=7, s=0.67) {

        /***
         * Sub-Module: A single 90° angled header.
         */
        module HeaderPin90(p, v, h, s) {
            // The plastic spacer on the board sized from the pitch
            color("Black")
                cube(p, center=true);
            //  The Pin
            color("Gold") {
                // Upright bit
                translate([0, 0, v])
                    cube([s, s, p], center=true);
                // Horizontal bit
                translate([-(h/2), 0, v+p/2])
                    cube([h, s, s], center=true);
                // Curve at bend
                translate([0, 0, v+p/2])
                    rotate([90, 0, 0])
                        cylinder(h=s, d=s, , center=true, $fn=20);
            }
        }

		// Move the header to have the spacer bottom left coner start at 0,0,0
		translate([p/2, p/2, p/2])
			// Place each pin, stepping pitch size on the Y Axis
			for(i=[0:pins-1]) {
				translate([0, i*p, 0])
					HeaderPin90(p, v, h, s);
			}
	}

	// The main PCB
	MainPCB();
    // Do not draw the other parts if only the PCB is required.
    if(PCBOnly==false) {
        // Add the LCD
        translate([4.5, -lcdT, 5.3])
            LCD();
        // Add the rear control board
        translate([6, 3, 15.8])
            ControlPCB();
    }
	
}
