#!/usr/bin/perl

use strict;
use warnings;

$| = 1;



my $hands;
my %values;

my %cardvalues = ( "1" => 1, "2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, "7" => 7, "8" => 8, "9" => 9, "T" => 10, "J" => 0, "Q" => 11, "K" => 12, "A" => 13 );

my %valuecards;

foreach my $card ( keys %cardvalues ) {
	$valuecards{$cardvalues{$card}} = $card;
}

my %description = ( 5 => "5 different cards", 9 => "ONE Pair", 13 => "TWO Pairs", 38 => "Three of a kind", 42 => "Three of a kind and a pair", 217 => "FOUR of a kind", 1296 => "FIVE of a Kind" );

while ( my $line = <STDIN> ) {
	chomp($line);
	my ( $hand, $bid ) = split( / /, $line );

	#if ( $hand eq "JJJJJ" ) {
	#	$hand = "AAAAA";
	#}
	$hands->{$hand}->{bid} = $bid;
}

# Sort/Score the hands

foreach my $hand ( sort keys %$hands ) {

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
		#if ( $card ne "J" and !defined( $pairs{$card} ) ) {
		#	$pairs{$card} = $jokers;
		#}

		$pairs{$card} += 1;
	}

	# Which one shall we apply the jokers to

	if ( $jokers > 0 ) {
		my @bestpair;

		foreach my $card ( keys %pairs ) {
			@bestpair = ( @bestpair, sprintf( "%02d.%02d", $pairs{$card}, $cardvalues{$card} ));
		}

		print "\tbest pairs are: " . join(", ", @bestpair ) . "\n";

		my $bp = ( sort { $b <=> $a } @bestpair )[0];

		print "\tthe best pair is $bp\n";

		my ( $bpp, $bpv ) = split(/\./,$bp );

		$bp = int($bpv);
		print "\tThe card has a value of $bp\n";

		my $wildcard = $valuecards{$bp};

		if ( $wildcard ne "J" ) {
			printf("\tthe card is %s, using the %d jokers to make %d of %s\n", $wildcard, $jokers,  $pairs{$wildcard} + $jokers, $wildcard);

			$pairs{$wildcard} += $jokers;
			delete $pairs{"J"};
		}
		else {
			print "\tDon't need to make a joker a joker!\n";
		}
	}
	
	my $pairscore = 0;
	
	my $wildcardhand = "";
	foreach my $card ( sort keys %pairs ) {
		$pairscore += 6 ** ($pairs{$card}-1);

		print "\t\tWe have $pairs{$card} of $card\n";

		for ( my $i = 0; $i < $pairs{$card}; $i++ ) {
			$wildcardhand .= "$card";
		}
	} 

	print "\thand is $description{$pairscore} (a pairvalue of $pairscore), with wildcards it looks like $wildcardhand instead of $hand\n";

	$hands->{$hand}->{pairvalue} = $pairscore;
	$hands->{$hand}->{wildcardhand} = $wildcardhand;

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
printf( "rank\t%-20s\tpairscore\tvalue\thand\twildcard\trank\tbid\tscore\n", "description");
foreach my $value (sort { $a <=> $b } keys %values ) {
	my $hand = $values{$value};
	my $score = $rank * $hands->{$hand}->{bid};
	printf( "%d\t%-30s\t%d\t%s\t%s\t%s\t%d\t%d\t%d\n", $rank, $description{$hands->{$hand}->{pairvalue}}, $hands->{$hand}->{pairvalue}, $value, $hand, $hands->{$hand}->{wildcardhand}, $rank, $hands->{$hand}->{bid}, $score );
	$sum += $score;
	$rank++;
}

print "ANSWER: $sum\n";

exit 0;
