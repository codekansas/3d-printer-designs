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
as possible. Here's the Python code for doing that:

```
import numpy as np
from scipy.optimize import linear_sum_assignment

# Fill in these arrays
heart_positions = np.array(...)
hex_positions = np.array(...)d

cost_matrix = np.linalg.norm(heart_positions[None, :, :] - hex_positions[:, None, :], ord=2, axis=2)
row_ind, col_ind = linear_sum_assignment(cost_matrix)

print(heart_positions[col_ind].tolist())
print(hex_positions[row_ind].tolist())

print(np.linalg.norm(heart_positions - hex_positions, axis=1))
print(np.linalg.norm(heart_positions[col_ind] - hex_positions[row_ind], axis=1))
```

You can verify that the total norm is lower for the new positions.
*/

// Angle of the sun in the sky at the moment when I proposed to Chi.
// Determined using this tool:
// https://www.sunearthtools.com/dp/tools/pos_sun.php?lang=en
sun_angle = 19.66;

// One inch in millimeters, plus a small padding.
one_inch = 25.4 + 1;

// Horizontal distance between mirror and image.
image_distance = 12 * 4 * one_inch;

// Vertical height of mirror.
mirror_height = 12 * 3 * one_inch;

// Distance to the sun (very large).
sun_distance = 100000;

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

heart_positions = [
    [1.0, 1.0],
    [0.5, 2.0],
    [0.75, 3.0],
    [2.5, 0.25],
    [4.0, 1.0],
    [1.5, 4.0],
    [2.5, 5.0],
    [5.0, 1.0],
    [4.5, 2.0],
    [3.5, 6.0],
    [4.5, 7.0],
    [6.5, 0.25],
    [8.0, 1.0],
    [6.5, 5.0],
    [5.5, 6.0],
    [8.5, 2.0],
    [8.25, 3.0],
    [7.5, 4.0],
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

assert(len(heart_positions) == len(hex_positions), "Invalid positions");

function dim_sum(arr, j, i = 0, sum = 0) =
    i == len(arr) ?
        sum :
        dim_sum(arr, j, i + 1, sum + arr[i][j]);

function dim_mean(arr, j) = dim_sum(arr, j) / len(arr);

function unit_vec(v) = let (nm = norm(v)) [v[0] / nm, v[1] / nm, v[2] / nm];

module rotate_by(v) {
    yaw = -atan2(v[1], v[2]);
    pitch = atan2(v[0], v[2]);
    
    rotate([yaw, pitch, 0])
        rotate([0, 0, 0])
            children();
}

module draw_ray(vec) {
    rotate_by(vec) {
        translate([0, 0, norm(vec)])
            sphere(5);
        linear_extrude(norm(vec))
            circle(2, $fn=6);
    }
}

module pillar(hex_x, hex_y, heart_x, heart_y) {
    sun_x = 0;
    sun_y = sin(sun_angle) * sun_distance;
    sun_z = cos(sun_angle) * sun_distance;

    mirror_x = hex_x;
    mirror_y = hex_y;
    mirror_z = 0;

    img_x = heart_x;
    img_y = -mirror_height;
    img_z = image_distance + heart_y;

    // Gets the vector normal to the surface of the mirror.
    sun_vec_full = [sun_x - mirror_x, sun_y - mirror_y, sun_z - mirror_z];
    img_vec_full = [img_x - mirror_x, img_y - mirror_y, img_z - mirror_z];
    sun_vec = unit_vec(sun_vec_full);
    img_vec = unit_vec(img_vec_full);
    norm_vec = [(sun_vec[0] + img_vec[0]) / 2, (sun_vec[1] + img_vec[1]) / 2, (sun_vec[2] + img_vec[2]) / 2];

    /*
    Draws the rays for visualization purposes (very important for debugging).

    draw_ray(sun_vec_full);
    draw_ray(img_vec_full);
    */

    rad = 0.5 * one_inch;
    rad2 = 0.5 * one_inch / cos(30);
    outer_rad = 2 * (rad2 - rad) + rad;

    difference() {
        linear_extrude(9)
        circle(r=outer_rad, $fn=6);
        translate([0, 0, 1])
            difference() {
                linear_extrude(10)
                    circle(r=rad, $fn=6);
                translate([0, 0, 3])
                    rotate_by(norm_vec)
                        translate([-one_inch, -one_inch, -one_inch])
                            cube([one_inch * 2, one_inch * 2, one_inch]);
            }
    }
}

module block(i) {
    hex_center_x = dim_mean(hex_positions, 0);
    hex_center_y = dim_mean(hex_positions, 1);
    heart_center_x = dim_mean(heart_positions, 0);
    heart_center_y = dim_mean(heart_positions, 1);

    hex_x = (hex_positions[i][0] - hex_center_x) * 0.5 * one_inch * cos(30);
    hex_y = (hex_center_y - hex_positions[i][1]) * 0.5 * one_inch;
    heart_x = (heart_positions[i][0] - heart_center_x) * 1.0 * one_inch;
    heart_y = (heart_center_y - heart_positions[i][1]) * 1.0 * one_inch;
    translate([hex_x, hex_y, 0])
        pillar(hex_x, hex_y, heart_x, heart_y);
}

for (i = [0:len(hex_positions) - 1]) block(i);
