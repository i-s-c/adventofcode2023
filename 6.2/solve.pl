#!/usr/bin/perl


use strict;
use warnings;

my $t;
my $d;

my $sum = 1;

while ( my $line = <STDIN> ) {
	chomp( $line );

	my ( $type, $data ) = split(/\:/, $line );

	$data =~ tr/0-9//cd;
	
	if ( $type =~ /^Time/ ) {
		$t = $data;
	}
	elsif ( $type =~ /^Distance/ ) {
		$d = $data;
	}

	
}

print "$t $d\n";

my $l = 0;
my $h = $t;

my $low = lsearch( $l, $h, $t, $d );

my $high = $t - $low;

$sum = $high - $low + 1;

print "ANSWER: $sum\n";

exit 0;

sub func {
	my ( $t, $d, $m ) = @_;

	return $t * $m - $m * $m;
}

sub lsearch {
	my ( $low, $high, $time, $target ) = @_;

	print "LOW $low, HIGH $high " . abs($high-$low) . "\n";

	if ( abs($high - $low ) <= 1 ) {
		print "Found?\n";
		return $high;
	}

	my $m = int(( $high - $low ) / 2 + $low);

	my $distance = func($t, $d, $m );

	printf ("%d %d %d %d %s\n", $m, func($time,$target,$m), $t, $d, $distance > $target ? "YES" : "NO" );

	if ( $distance > $target ) {
		return lsearch( $low, $m, $time, $target );
	}
	elsif ( $distance < $target ) {
		return lsearch( $m, $high, $time, $target );
	}

	return $m; # Not sure if this is a big or I need an equality. It doesn't get hit though
}

