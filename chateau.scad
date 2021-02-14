module turret() {
    cylinder(h=15, r1=7, r2=10);
    translate([0, 0, 15])
        cylinder(h=25, r=10);
    translate([0, 0, 40])
        cylinder(h=10, r1=10, r2=0);
}

module triangle(wid=20, leng=20, hei=10, offset=0) {
    polyhedron(points=[
        [0, 0, 0],
        [0, leng, 0],
        [wid, leng, 0],
        [wid, 0, 0],
        [wid / 2, offset, hei],
        [wid / 2, leng - offset, hei],
    ],
    faces=[
        [3, 2, 1, 0],
        [0, 1, 5, 4],
        [3, 4, 5, 2],
        [3, 0, 4],
        [1, 2, 5]
    ], convexity=1);
}

module roof(leng) {
    triangle(wid=20, leng=leng, hei=10, offset=10);
    translate([0, 10 + leng / 2, 0])
        rotate([0, 0, -90])
            triangle(offset=2);
}

module building() {
    cube([20, 60, 30]);
    translate([0, 80, 0])
        rotate([0, 0, -90])
            cube([20, 60, 30]);
    translate([0, -20, 0])
        cube([60, 20, 30]);
    translate([0, -20, 30])
        roof(100);
    translate([0, 0, 30])
        rotate([0, 0, -90])
            roof(60);
    translate([0, 80, 30])
        rotate([0, 0, -90])
            roof(60);
}

module door() {
    translate([-2, 0, 0])
        rotate([0, 90, 0])
            linear_extrude(10)
                circle(5);
}

module doors() {
    door();
    translate([0, 30, 0])
        door();
    translate([0, 60, 0])
        door();
}

module window() {
    translate([-1, 0, 10])
        rotate([0, 90, 0])
            linear_extrude(2)
                square(5);
}

module buildings() {
    translate([0, 0, 10])
        union() {
            difference() {
                building();
                translate([0, 12.5, 10])
                    window();
                translate([0, 42.5, 10])
                    window();
            }
            translate([0, -20, 0])
                turret();
            translate([0, 80, 0])
                turret();
            translate([60, -20, 0])
                turret();
            translate([60, 80, 0])
                turret();
            doors();
        }
}

module grounds() {
    difference() {
        linear_extrude(height=10) {
            hull() {
                translate([0, -20, 0])
                    circle(r=10);
                translate([0, 80, 0])
                    circle(r=10);
                translate([100, -20, 0])
                    circle(r=10);
                translate([100, 80, 0])
                    circle(r=10);
            }
        }
        translate([80, -25, 8])
            linear_extrude(height=10) {
                rotate([0, 0, 90])
                    text("Chateau de Le Bolté", font="Liberation Sans:style=Italic", size=9);
            }
    }
}

module fountain() {
    translate([50, 30, 10])
        union() {
            cylinder(r=20, h=5);
            difference() {
                cylinder(r=20, h=10);
                cylinder(r=17, h=20);
            }
            cylinder(r=3, h=13);
        }
}

module bush() {
    sphere(r=4);
    translate([0, 0, 2])
        sphere(r=3);
    translate([0, 0, 4])
        sphere(r=2);
}

module bushes() {
    translate([85, 20, 10])
        bush();
    translate([85, 40, 10])
        bush();
    translate([105, 20, 10])
        bush();
    translate([105, 40, 10])
        bush();
    translate([95, 20, 10])
        bush();
    translate([95, 40, 10])
        bush();
}

module chateau() {
    buildings();
    grounds();
    fountain();
    bushes();
}

chateau();

// roof(60);

// triangle();
