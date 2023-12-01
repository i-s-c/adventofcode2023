#!/usr/bin/perl

# This gets the right answer for the example (281). But fails for the real data set. Which was annoying.

use strict; 

my $sum = 0;

my %numbers = ( "one" => 1, "two" => 2, "three" => 3, "four" => 4, "five" => 5, "six" => 6, "seven" => 7, "eight" => 8, "nine" => 9 );

my %digits;

foreach my $n ( sort keys %numbers ) {
	$digits{$numbers{$n}} = $n;
}

while ( my $line = <STDIN> ) {
	chomp($line);

	print "$line\t";

	while ( ( my $m = get_bestmatch( $line ) ) > 0 ) {
		#print "\tswapping $digits{$m} for $m\n";
		$line =~ s/$digits{$m}/$m/;
		#print "\t$line\n";
	}

	print "$line\t";

	my $digits = $line;
	$digits =~ tr/0-9//cd;

	my @d = split(//,$digits);

	my $f = shift(@d);

	my $l = $d[scalar(@d)-1];

	if ( !defined($l) ) {
		$l = $f;
		#print "SINGLE\t";
	}


	print "$digits\t$f$l\n";

	$sum += "$f$l";

	#print "$sum\n";

}

print "$sum\n";

exit 0;


sub get_bestmatch {
	my ( $s ) = @_;

	my @bestmatch;

	foreach my $k ( sort keys %numbers ) {
		if ( $s =~ /$k/ ) {
			my $t = $s;
			$t =~ s/$k.*$//;
			my $len = length($t);

			$bestmatch[ $numbers{$k}] = $len;
		}
	}

	my $bm = 1000000;
	my $bi = 0;
	my $count  = 0;
	for( my $i = 1; $i < 10; $i++ ) {
		if( defined( $bestmatch[$i] ) ) {
			if ( $bestmatch[$i] < $bm ) {
				$bm = $bestmatch[$i];
				$bi = $i;
				$count++;
			}
		}
	}

	if ( $count ) {
		print "*";
	}
	else {
		print " ";
	}
	return $bi;
}
