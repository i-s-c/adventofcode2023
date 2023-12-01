#!/usr/bin/perl

use strict; 

my $sum = 0;

my %numbers = ( "one" => 1, "two" => 2, "three" => 3, "four" => 4, "five" => 5, "six" => 6, "seven" => 7, "eight" => 8, "nine" => 9 );

while ( my $line = <STDIN> ) {
	chomp($line);

	print "$line\t";

	foreach my $n ( keys %numbers ) {
		$line =~ s/$n/$numbers{$n}/ig;
	}

	print "$line\t";

	my $digits = $line;
	$digits =~ tr/0-9//cd;

	my @d = split(//,$digits);

	my $f = shift(@d);

	my $l = $d[scalar(@d)-1];

	if ( !defined($l) ) {
		$l = $f;
		print "SINGLE\t";
	}


	print "$digits\t$f$l + $sum = \t";

	$sum += "$f$l";

	print "$sum\n";

}

print "$sum\n";

exit 0;

