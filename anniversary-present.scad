/**
 * Anniversary present for my wife.
 *
 * Reflects the sun to show a heart.
 */

/*
Setup
                    Sun
                 .
              .
m          .
i       .
r    .
r .
o    .
r       .
           .
              .
             image

After figuring out the positions of the heart and hex pixels,
plugged the points into the Hungarian Algorithm to find the
minimum correspondence, in order to make the rays as parallel
as possible.
*/


// Angle of the sun in the sky at the moment when I proposed to Chi.
// Determined using this tool:
// https://www.sunearthtools.com/dp/tools/pos_sun.php?lang=en
sun_angle = 19.66;

// One inch in millimeters, plus a small padding.
one_inch = 25.4 + 1;

// Horizontal distance between mirror and image.
image_distance = 1000;

// Vertical height of mirror.
mirror_height = 1000;

/*
Heart layout

    --- y axis --->

  0 1 2 3 4 5 6 7 8 9
0      x       x
1   x     x x     x
2  x       x       x
3  x               x
4    x           x
5      x       x
6        x   x
7          x
*/

heart_center_y = 4.5;
heart_center_x = 3;

heart_positions = [
 [0.25, 2.5 ],
 [1.,   5.  ],
 [0.25, 6.5 ],
 [1.,   1.  ],
 [1.,   4.  ],
 [2.,   4.5 ],
 [1.,   8.  ],
 [2.,   0.5 ],
 [4.,   1.5 ],
 [2.,   8.5 ],
 [3.,   8.25],
 [3.,   0.75],
 [6.,   3.5 ],
 [6.,   5.5 ],
 [4.,   7.5 ],
 [5.,   2.5 ],
 [7.,   4.5 ],
 [5.,   6.5 ],
];

/*
Hexagonal layout

Coordinates below are (x, y)

   --- y axis --->

  0 1 2 3 4 5 6 7 8
0     x   x   x
1
2   x   x   x   x
3
4 x   x       x   x
5
6   x   x   x   x
7
8     x   x   x
*/

hex_center_x = 4;
hex_center_y = 4;

hex_positions = [
 [0, 2],
 [0, 4],
 [0, 6],
 [2, 1],
 [2, 3],
 [2, 5],
 [2, 7],
 [4, 0],
 [4, 2],
 [4, 6],
 [4, 8],
 [6, 1],
 [6, 3],
 [6, 5],
 [6, 7],
 [8, 2],
 [8, 4],
 [8, 6],
];

echo(len(hex_positions));
echo(len(heart_positions));
assert(len(heart_positions) == len(hex_positions), "Invalid positions");

module one_cube(yaw, pitch) {
    echo("yaw:", yaw);
    echo("pitch:", pitch);
    
    rotate([0, yaw, pitch])
        translate([-one_inch, -one_inch, -one_inch])
            cube([one_inch * 2, one_inch * 2, one_inch]);
}

module pillar(hex_x, hex_y, heart_x, heart_y) {
    // Using KITTI IMU coordinate frame.
    dx = image_distance - heart_x;
    dy = heart_y - hex_y;
    dz = mirror_height - hex_x;
    
    // Angle of each mirror.
    yaw = atan2(dy, dx);
    pitch = atan2(dz, dx) - sun_angle;
    
    rad = 0.5 * one_inch;
    rad2 = 0.5 * one_inch / cos(30);
    outer_rad = 2 * (rad2 - rad) + rad;
    
    difference() {
        linear_extrude(10)
            circle(r=outer_rad, $fn=6);
        translate([0, 0, 3])
            difference() {
                linear_extrude(10)
                    circle(r=rad, $fn=6);
                translate([0, 0, 3])
                    one_cube(yaw, pitch);
            }
    }
}

module block(i) {
    hex_x = (hex_positions[i][0] - hex_center_x) * 0.5 * one_inch * cos(30);
    hex_y = (hex_positions[i][1] - hex_center_y) * 0.5 * one_inch;
    heart_x = (heart_positions[i][0] - heart_center_x) * 2 * one_inch;
    heart_y = (heart_positions[i][1] - heart_center_y) * 2 * one_inch;
    translate([hex_x, hex_y, 0])
        pillar(hex_x, hex_y, heart_x, heart_y);
}

for (i = [0:len(hex_positions) - 1]) block(i);