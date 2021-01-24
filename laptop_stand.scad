/**
 * A laptop stand, for holding the laptop vertically while plugged into a monitor.
 *
 * All measurements are in millimeters.
 *
 * Parameters:
 *   - lwid: Laptop width.
 *   - lhei: Laptop height.
 *   - ldep: Laptop depth.
 *   - slen: Stand length.
 *   - sswid: Width of base of stand uprights.
 *   - sstap: Taper percent of stand uprights.
 *   - suhei: Height of stand uprights.
 *   - sbwid: Width of the stand (long direction).
 *   - sthi: Thickness of all parts of the stand.
 *   - butwid: Buttress width.
 *   - butfact: Factor between buttress height and uptight height.
 *   - padding: Slot padding.
 */

// Laptop dimensions.
lwid = 304.1;
lhei = 212.4;
ldep = 15;

// Stand long dimensions.
slen = 200;
sswid = 60;
sstap = 0.6;
suhei = 100;
sbwid = 60;

// Stand thickness.
sthi = 10;

// Buttress dimensions.
butwid = 10;
butfact = 0.7;

// Additional padding factor for slot.
padding = 1;

module baseCorner() {
    polyhedron(
        points=[
            [0, 0, 0],
            [sbwid, sswid * (1 - sstap), 0],
            [sbwid, sswid * sstap, 0],
            [0, sswid, 0],
            [0, 0, sthi],
            [sbwid, sswid * (1 - sstap), sthi],
            [sbwid, sswid * sstap, sthi],
            [0, sswid, sthi],
        ],
        faces=[
            [0, 1, 2, 3],
            [4, 5, 1, 0],
            [7, 6, 5, 4],
            [5, 6, 2, 1],
            [6, 7, 3, 2],
            [7, 4, 0, 3],
        ]
    );
}

module buttress() {
    translate([0, (sswid + butwid) / 2, sthi])
        rotate([90, 0, 0])
            linear_extrude(butwid)
                polygon(
                    points=[
                        [0, 0],
                        [0, suhei*butfact],
                        [sbwid*butfact, 0],
                    ]);
}

sbtranslate = ldep + (2 * (padding + sthi)) + sbwid;

// Prints the four base corners.
translate([sbwid, 0, 0])
    mirror([1, 0, 0]) {
        baseCorner();
        buttress();
    }
translate([sbwid, slen - sswid, 0])
    mirror([1, 0, 0]) {
        baseCorner();
        buttress();
    }
translate([sbtranslate, slen - sswid, 0]) {
    baseCorner();
    buttress();
}
translate([sbtranslate, 0, 0]) {
    baseCorner();
    buttress();
}

// Prints the inside.
translate([sbwid, 0, 0, ])
    cube([ldep + (2 * (padding + sthi)), slen, sthi]);

module standUpright() {
    polyhedron(
        points=[
            [0, 0, 0],
            [sthi, 0, 0],
            [sthi, sswid, 0],
            [0, sswid, 0],
            [0, sswid * (1 - sstap), suhei],
            [sthi, sswid * (1 - sstap), suhei],
            [sthi, sswid * sstap, suhei],
            [0, sswid * sstap, suhei],
        ],
        faces=[
            [0, 1, 2, 3],
            [4, 5, 1, 0],
            [7, 6, 5, 4],
            [5, 6, 2, 1],
            [6, 7, 3, 2],
            [7, 4, 0, 3],
        ]
    );
}

// Prints the four uprights.
translate([sbwid, 0, sthi])
    standUpright();
translate([sbwid + ldep + (2 * padding + sthi), slen - sswid, sthi])
    standUpright();
translate([sbwid + ldep + (2 * padding + sthi), 0, sthi])
    standUpright();
translate([sbwid, slen - sswid, sthi])
    standUpright();
