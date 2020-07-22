#!/usr/bin/perl

use strict;
use warnings;
use 5.010;
use autodie;
use File::Temp qw(tempfile);
use File::Copy;

# Run this to update all of the RoomTileset.tres resource names, using
# information from RoomTypes.Tile.

my @names;

open my $fh, '<', './RoomTypes/RoomTypes.gd';
while (<$fh>) {
    if (/enum Tile/../}/) {
        for my $name (split /,/) {
            $name =~ s/=\s*\d+//g;
            $name =~ s/^\s+|\s+$//g;
            next if $name =~ /^$/ or $name =~ /[^A-Za-z0-9]/;
            push @names, $name
        }
    }
}
close $fh;

open my $oldfh, '<', './RoomTileset/RoomTileset.tres';
my ($newfh, $tmpfile) = tempfile();
my $index = 0;
while (<$oldfh>) {
    if (m{^(\d+)/name\s+=\s+"(\w+)"}) {
        my $name;
        if ($index < +@names) {
            $name = sprintf("%.3d_%s", $index, $names[$index]);
        } else {
            $name = sprintf("%.3d_resource", $index);
        }
        $index++;
        s/"\w+"/"$name"/;
    }
    print $newfh $_;
}
close $newfh;
copy($tmpfile, './RoomTileset/RoomTileset.tres');
