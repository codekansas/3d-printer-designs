/**
 * Napkin rings, originally designed for our engagement party.
 *
 * All measurements are in millimeters.
 *
 * Parameters:
 *   - outer_diam: Outer diameter.
 *   - inner_diam: Inner diameter.
 *   - text_size: Size of the text.
 *   - text_spacing: Spacing between letters.
 *   - text_thickness: Thickness of the letters.
 */

outer_diam = 48;
inner_diam = 38;

text_size = 10;
text_spacing = 0.8;
text_thickness = 1;

module curvedText(txt, r, size, spacing, valign="baseline", font) {
    a = 180 * size * spacing / (PI * r);
    for (i = [0:len(txt) - 1])
        rotate([0, 0, -(i + 0.5) * a])
        translate([0, r + text_thickness])
        rotate([90, 0, 0])
        linear_extrude(text_thickness * 2)
            text(txt[i], size=size, halign="center", valign=valign, $fn=32, font=font);
}

mirror([1, 0, 0]) {
    difference() {
        sphere(d=outer_diam);
        translate([0, 0, -outer_diam])
            cylinder(h=outer_diam * 2, d=inner_diam);
    }
    translate([0, 0, -text_size / 2])
        curvedText("Chi & Ben", outer_diam / 2, text_size, text_spacing);
}
