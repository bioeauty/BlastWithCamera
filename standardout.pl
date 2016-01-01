#!usr/bin/perl

use strict;
use warnings;

my $file = $ARGV[0];

open(FH,$file);

while (<FH>) {
        chomp();
        my @arr = split(/\t/,$_);
        if($#arr == 1) {

        printf "%20s",$arr[0]." -- ";
    printf "%5.5s",$arr[1]."\n";

    }
 }
 close(FH);
