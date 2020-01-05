#!/usr/bin/perl

use strict;
use warnings;
use 5.010;

use Image::PNG::Libpng qw(read_png_file);
use Image::PNG::Const qw(PNG_TRANSFORM_EXPAND PNG_COLOR_TYPE_RGB_ALPHA);
use File::Find qw(find);
use JSON qw(encode_json);

# unpack_pixel($pixel)
#
# Returns a list of R, G, B, A
sub unpack_pixel {
    my $pixel = shift;
    my $r = ord substr $pixel, 0, 1;
    my $g = ord substr $pixel, 1, 1;
    my $b = ord substr $pixel, 2, 1;
    my $a = ord substr($pixel, 3, 1) . chr 1; # Default to 1 if not provided
    return ($r, $g, $b, $a);
}

# average_color($filename)
#
# Returns an integer 0xRRGGBBAA.
sub average_color {
    my $filename = shift;
    my $png = read_png_file($filename, transforms => PNG_TRANSFORM_EXPAND);
    my $rows = $png->get_rows();
    my ($rs, $gs, $bs) = (0, 0, 0);
    my $count = 0;
    my $alpha_exists = ($png->get_channels() == 4);
    my $increment = $alpha_exists ? 4 : 3;
    for my $row (@$rows) {
        for (my $index = 0; $index + $increment <= length $row; $index += $increment) {
            my $pixel = substr $row, $index, $increment;
            my ($r, $g, $b, $a) = unpack_pixel($pixel);
            $rs += $r ** 2 * $a;
            $gs += $g ** 2 * $a;
            $bs += $b ** 2 * $a;
            $count += $a;
        }
    }
    my $r = int sqrt($rs / $count);
    my $g = int sqrt($gs / $count);
    my $b = int sqrt($bs / $count);
    return $r * 16777216 + $g * 65536 + $b * 256 + 255;
}

my @files;
my %hash;

sub wanted {
    my $name = $File::Find::name;
    push @files, $name if $name =~ /\.png$/;
}

find { wanted => \&wanted, no_chdir => 1 }, './Furniture';
for my $filename (@files) {
    my $color = average_color($filename);
    $filename =~ m[/(\w*)\.png$];
    $hash{$1} = $color;
}

#printf "%#.8x\n", average_color('./Furniture/LongBookshelf/LongBookshelf.png');

say encode_json \%hash;
