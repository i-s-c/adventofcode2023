#!/usr/bin/perl

use strict;
use warnings;



my $hands;
my %values;

my %cardvalues = ( "1" => 0, "2" => 1, "3" => 2, "4" => 3, "5" => 4, "6" => 5, "7" => 6, "8" => 7, "9" => 8, "T" => 9, "J" => 10, "Q" => 11, "K" => 12, "A" => 13 );

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

	my %pairs;
	my @cv;
	foreach my $card ( @cards ) {
		$pairs{$card} += 1;
		@cv = ( @cv, $cardvalues{$card} );
	}

	my $handvalue = 0;
	my $i = 5;
	my @orderedhand;
	foreach my $v ( sort { $b <=> $a } @cv) {
		$handvalue += $v * ( 14 ** $i );

		@orderedhand = ( @orderedhand, $valuecards{$v} );
		$i--;
	}
	
	print "\thand value is $handvalue\n";
	$hands->{$hand}->{ordervalue} = $handvalue;

	$hands->{$hand}->{ordered} = join("",@orderedhand);

	print "$hand order is " . join("",@orderedhand) . "\n";

	# Now work out the pair score
	my $pairscore = 0;

	foreach my $card ( keys %pairs ) {
		$pairscore += 6 ** ($pairs{$card}-1);
	} 

	print "\thand has pairvalue $pairscore\n";

	$hands->{$hand}->{pairvalue} = $pairscore;

	$handvalue =  $handvalue  + ( $pairscore * ( 14 ** 6 ) );

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
foreach my $value (sort { $a <=> $b } keys %values ) {
	my $score = $rank * $hands->{$values{$value}}->{bid};
	my $hand = $values{$value};
	printf( "%d: %s, %d, %d, %d, %s: %d * %d  = %d\n", $rank, $hands->{$hand}->{ordered}, $hands->{$hand}->{pairvalue}, $hands->{$hand}->{ordervalue}, $value, $hand, $rank, $hands->{$hand}->{bid}, $score );
	$sum += $score;
	$rank++;
}

print "ANSWER: $sum\n";

exit 0;
