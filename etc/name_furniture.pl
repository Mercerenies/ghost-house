#!/usr/bin/perl

use strict;
use warnings;
use 5.010;

use File::Find qw(find);

my @files;

sub wanted {
    my $name = $File::Find::name;
    push @files, $name if $name =~ /\.gd$/;
}

find { wanted => \&wanted, no_chdir => 1 }, './Furniture';
FILE: for my $filename (@files) {
    # First, search for an existing get_furniture_name(). If one
    # exists, don't clobber it and move on.
    open my $fh, '<', $filename;
    my $extends_furniture = '';
    for (<$fh>) {
        if (/func get_furniture_name\(\):/) {
            say "Skipping $filename (already has value)...";
            close $fh;
            next FILE;
        }
        if (/extends Furniture/) {
            $extends_furniture = 1;
        }
    }
    close $fh;
    unless ($extends_furniture) {
        say "Skipping $filename (is not furniture)...";
        next FILE;
    }
    # If we're still solid, append
    open $fh, '>>', $filename;
    unless ($filename =~ m[/(\w*)\.gd$]) {
        say "Can't identify name of $filename...";
        close $fh;
        next FILE;
    }
    print $fh <<"END_FUNCTION";
func get_furniture_name():
    return "$1"
END_FUNCTION
    say "Marking $filename...";
    close $fh;
}
