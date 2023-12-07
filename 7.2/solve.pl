#!/usr/bin/perl

use strict;
use warnings;



my $hands;
my %values;

my %cardvalues = ( "1" => 1, "2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, "7" => 7, "8" => 8, "9" => 9, "T" => 10, "J" => 0, "Q" => 11, "K" => 12, "A" => 13 );

my %valuecards;

foreach my $card ( keys %cardvalues ) {
	$valuecards{$cardvalues{$card}} = $card;
}

while ( my $line = <STDIN> ) {
	chomp($line);
	my ( $hand, $bid ) = split( / /, $line );

	$hands->{$hand}->{bid} = $bid;
}

# Sort/Score the hands

foreach my $hand ( keys %$hands ) {

	print "Hand: $hand\n";
	my @cards = split(//,$hand);


	my $handvalue = "";
	foreach my $card ( @cards ) {
		$handvalue .= sprintf( "%02d", $cardvalues{$card} );
	}

	# Now work out the pair score
	my %pairs;

	my $jokers = 0;

	foreach my $card( @cards ) {
		if ( $card eq "J" ) {
			$jokers++;
		}
	}

	print "We have $jokers jokers\n";

	# Work out the pairs, this time with the jokers

	# Does it matter than we are using the jokers more than once?
	foreach my $card ( @cards ) {
		if ( $card ne "J" and !defined( $pairs{$card} ) ) {
			$pairs{$card} = $jokers;
		}

		$pairs{$card} += 1;
	}

	
	my $pairscore = 0;
	

	foreach my $card ( keys %pairs ) {
		$pairscore += 6 ** ($pairs{$card}-1);

		print "\t\tWe have $pairs{$card} of $card\n";
	} 

	print "\thand has pairvalue $pairscore\n";

	$hands->{$hand}->{pairvalue} = $pairscore;

	#$handvalue =  $handvalue  + ( $pairscore * ( 14 ** 6 ) );
	$handvalue = sprintf( "%04d%s", $pairscore, $handvalue );

	print "\ttotal value is $handvalue\n";

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
printf( "rank\tpairscore\tvalue\thand\ttank\tbid\tscore\n");
foreach my $value (sort { $a <=> $b } keys %values ) {
	my $hand = $values{$value};
	my $score = $rank * $hands->{$hand}->{bid};
	printf( "%d\t%d\t%s\t%s\t%d\t%d\t%d\n", $rank, $hands->{$hand}->{pairvalue}, $value, $hand, $rank, $hands->{$hand}->{bid}, $score );
	$sum += $score;
	$rank++;
}

print "ANSWER: $sum\n";

exit 0;
