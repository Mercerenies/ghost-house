#!/usr/bin/perl

use strict;
use warnings;
use 5.010;

FILE: for my $fname (`find ./Furniture/ -name '*.tscn'`) {
    chomp $fname;
    open my $fh, '<', $fname or die("Error on $fname: $!");
    while (<$fh>) {
        next FILE if /\[node name="Sprite"/
    }
    print "WARNING! $fname";
    close $fh;
}
