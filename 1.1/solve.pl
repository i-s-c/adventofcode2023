#!/usr/bin/perl

use strict; 

my $sum = 0;

while ( my $line = <STDIN> ) {
	chomp($line);

	my $digits = $line;
	$digits =~ tr/0-9//cd;

	my @d = split(//,$digits);

	my $f = shift(@d);

	my $l = $d[scalar(@d)-1];

	if ( !defined($l) ) {
		$l = $f;
		print "SINGLE\t";
	}

	print "print $line\n$digits\n$f $l\n";

	$sum += "$f$l";
}

print "$sum\n";

exit 0;

