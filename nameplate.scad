/**
 * Writes out some embossed text.
 */

module base() {
    square([55, 30]);
}

module embossed() {
    translate([2, 20, 0])
        text("Benjamin", 8);
    translate([2, 10, 0])
        text("Bolte", 8);
    translate([2, 2, 0])
        text("678-561-3132", 6);
}

linear_extrude(height=3) base();
linear_extrude(height=5) embossed();
