#!/usr/bin/perl


use strict;
use warnings;

my @times;
my @distances;

my $sum = 1;

while ( my $line = <STDIN> ) {
	chomp( $line );

	my ( $type, $data ) = split(/\:/, $line );
	while ( $data =~ /^ / ) {
		$data =~ s/^ //;
	}
	while ( $data =~ /  / ) {
		$data =~ s/  / /g;
	}
	print "$data\n";

	if ( $type =~ /^Time/ ) {
		@times = split( / /,$data);
	}
	elsif ( $type =~ /^Distance/ ) {
		@distances = split(/ /,$data);
	}

	while ( my $d = shift(@distances ) ) {
		my $t = shift(@times);

		my $count = 0;
		for ( my $p = 0; $p <= $t; $p++ ) {
			my $m = $t - $p;

			my $n = $m * $p;

			printf ( "%d %d %d %d %s\n", $p, $m, $n, $d, $n > $d ? "YES" : "" );
			if ( $n > $d ) {
				$count++;
			}
			
		}
		print "COUNT IS $count\n";
		$sum *= $count;
	}

	
}

print "ANSWER: $sum\n";

exit 0;
