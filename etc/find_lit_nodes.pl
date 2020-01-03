#!/usr/bin/perl

use strict;
use warnings;
use 5.010;

# Finds entity nodes which have custom lighting

FILE: for my $fname (`find ./ -name '*.gd'`) {
    chomp $fname;
    open my $fh, '<', $fname or die("Error on $fname: $!");
    while (<$fh>) {
        if (/func lighting/) {
            print "$fname\n";
            close $fh;
            next FILE;
        }
    }
    close $fh;
}
