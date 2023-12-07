#!/usr/bin/perl

use strict;
use warnings;



my $hands;
my %values;

my %cardvalues = ( "1" => 0, "2" => 1, "3" => 2, "4" => 3, "5" => 4, "6" => 5, "7" => 6, "8" => 7, "9" => 8, "T" => 9, "J" => 10, "Q" => 11, "K" => 12, "A" => 13 );

while ( my $line = <STDIN> ) {
	chomp($line);
	my ( $hand, $bid ) = split( / /, $line );

	$hands->{$hand}->{bid} = $bid;
}

# Sort/Score the hands

foreach my $hand ( keys %$hands ) {

	print "Hand: $hand\n";
	my @cards = split(//,$hand);

	my %pairs;
	foreach my $card ( @cards ) {
		$pairs{$card} += 1;
	}

	my $handvalue = 0;
	foreach my $card ( @cards ) {

		my $hv = $cardvalues{$card} * 14 ** ( $pairs{$card} - 1 );
		printf("\t%s: %d * 14^%d\n", $card, $cardvalues{$card}, $pairs{$card} - 1 );
		$handvalue += $hv;

		#if ( $pairs{$card} > 1 ) 0i{
		#	$handvalue += $pairs{$card} * 5 * 14;
#
#			$handvalue += ( $
#			print "\t$card: $pairs{$card} * 5 * 14 = " . $pairs{$card} * 14 . "\n";
#		}
#		else {
#			$handvalue += $cardvalues{$card};
#			print "\t$card: $pairs{$card} =  $cardvalues{$card}\n";
#		}
	}
	print "\thand value is $handvalue\n";
	$hands->{$hand}->{value} = $handvalue;

	if ( !defined( $values{$handvalue} )) {
		$values{$handvalue} = $hand;
	}
	else {
		print "Duplicate value for $hand\n";
		exit 0;
	}
}

my $rank = 1;
my $sum = 0;
foreach my $value (sort { $a <=> $b } keys %values ) {
	my $score = $rank * $hands->{$values{$value}}->{bid};
	printf( "%d, %d, %s = %d\n", $rank, $value, $values{$value}, $score );
	$sum += $score;
	$rank++;
}

print "ANSWER: $sum\n";

exit 0;
