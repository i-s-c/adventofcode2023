#!/usr/bin/perl

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

	#foreach my $n ( keys %numbers ) {
	#	$line =~ s/$n/$numbers{$n}/ig;
	#}
	while ( ( my $m = get_bestmatch( $line ) ) > 0 ) {
		print "\tswapping $digits{$m} for $m\n";
		$line =~ s/$digits{$m}/$m/;
		print "\t$line\n";
	}

	print "$line\n";

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


sub get_bestmatch {
	my ( $s ) = @_;

	my @bestmatch;

	foreach my $k ( sort keys %numbers ) {
		if ( $s =~ /$k/ ) {
			print "Matches $k\n";
			my $t = $s;
			$t =~ s/$k.*$//;
			my $l = length($t );

			$bestmatch[ $numbers{$k}] = $l;
		}
	}

	print "Matching $s\n";

	my $bm = 10;
	my $bi = 0;
	for( my $i = 1; $i < 10; $i++ ) {
		if( defined( $bestmatch[$i] ) ) {
			print "\t$bestmatch[$i]\n";
			if ( $bestmatch[$i] < $bm ) {
				$bm = $bestmatch[$i];
				$bi = $i;
			}
		}
	}
	return $bi;
}
