/**
 * Design for a bookend, with holes for airplants, pencils, etc.
 *
 * Parameters:
 *  - height: The total height.
 *  - width: The width of each block.
 *  - padding: The padding between the holes and the edge.
 */

height = 120;
width = 40;
padding = 10;

module col(h, sph=false) {
    difference() {
        cube([width, width, h]);
        if (sph)
            translate([width / 2, width / 2, h])
                sphere(d=width - padding);
        else
            translate([width / 2, width / 2, padding])
                cylinder(h, d=width - padding);
    }
}

module strut(h) {
    translate([width / 2, 0, 0])
        difference() {
            polyhedron(
                points=[
                    [width / 2, -width, 0],
                    [width / 2, 0, 0],
                    [-width / 2, 0, 0],
                    [-width / 2, -width, 0],
                    [0, 0, -width],
                ],
                faces=[
                    [0,1,4],
                    [1,2,4],
                    [2,3,4],
                    [3,0,4],
                    [1,0,3],
                    [2,1,3],
                ]
            );
            translate([0, -width / 2, 0])
                sphere(d=width - padding);
        }
}


col(height);
translate([width, 0, 0])
    col(2 * height / 3);
translate([width * 2, 0, 0])
    col(height / 3, true);
translate([0, -width, 0])
    col(2 * height / 3);
translate([width, -width, 0])
    col(height / 3, true);
translate([0, -2 * width, 0])
    col(height / 3, true);
