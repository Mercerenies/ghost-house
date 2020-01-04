#!/usr/bin/perl

use strict;
use warnings;
use 5.010;

use Image::PNG::Libpng qw(read_png_file);

# unpack_pixel($pixel)
#
# Returns a list of R, G, B, A
sub unpack_pixel {
    my $pixel = shift;
    my $r = ord substr $pixel, 0, 1;
    my $g = ord substr $pixel, 1, 1;
    my $b = ord substr $pixel, 2, 1;
    #my $a = ord substr $pixel, 3, 1;
    return ($r, $g, $b);
}

# average_color($filename)
#
# Returns an integer 0xRRGGBBAA.
sub average_color {
    my $filename = shift;
    my $png = read_png_file($filename);
    my $rows = $png->get_rows();
    my ($rs, $gs, $bs) = (0, 0, 0);
    my $count = 0;
    for my $row (@$rows) {
        for (my $index = 0; $index + 3 <= length $row; $index += 3) {
            my $pixel = substr $row, $index, 3;
            my ($r, $g, $b) = unpack_pixel($pixel);
            print "$pixel\n";
            $rs += $r ** 2;
            $gs += $g ** 2;
            $bs += $b ** 2;
            $count += 1;
        }
    }
    my $r = int sqrt($rs / $count);
    my $g = int sqrt($gs / $count);
    my $b = int sqrt($bs / $count);
    return $r * 16777216 + $g * 65536 + $b * 256 + 255;
}

# ///// I'm making assumptions about the channels that just aren't
# true (note that the DebugGreenBox image has no alpha channel, which
# puts a wedge in some things. Test with that picture too)

printf "%#x\n", average_color('./Furniture/DebugGreenBox/DebugGreenBox.png');

