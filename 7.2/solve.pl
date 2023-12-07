#!/usr/bin/perl

use strict;
use warnings;

$| = 1;

my $hands;
my %values;

my %cardvalues = ( "2" => 1, "3" => 2, "4" => 3, "5" => 4, "6" => 5, "7" => 6, "8" => 7, "9" => 8, "T" => 9, "J" => 0, "Q" => 10, "K" => 11, "A" => 12 );

my %valuecards;

foreach my $card ( keys %cardvalues ) {
	$valuecards{$cardvalues{$card}} = $card;
}

my %description = ( 5 => "5 different cards", 9 => "ONE Pair", 13 => "TWO Pairs", 38 => "Three of a kind", 42 => "Three of a kind and a pair", 217 => "FOUR of a kind", 1296 => "FIVE of a Kind" );

# Read the hands into memory

while ( my $line = <STDIN> ) {
	chomp($line);
	my ( $hand, $bid ) = split( / /, $line );

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

	# Just count the jokers.

	my $jokers = 0;

	foreach my $card( @cards ) {
		if ( $card eq "J" ) {
			$jokers++;
		}
	}

	print "\tWe have $jokers jokers\n";

	# Work out the pairs, now using jokers
	# Pairs are really the number of times each card occurs in the hand

	my %pairs;

	foreach my $card ( @cards ) {
		$pairs{$card} += 1;
	}

	# Which one shall we apply the jokers to?
	# Need to pick one. So we'll pick the highest scoring card.

	if ( $jokers > 0 ) {
		my @bestpair;

		foreach my $card ( keys %pairs ) {
			@bestpair = ( @bestpair, sprintf( "%02d.%02d", $pairs{$card}, $cardvalues{$card} ));
		}

		print "\tbest pairs are: " . join(", ", @bestpair ) . "\n";

		# If the "best pair" is a joker, then try again. Only really need to pick the next one.. but why not use a GOTO?
		for ( my $i = 0; $i < scalar(@bestpair); $i++ ) {
			my $bp = ( sort { $b <=> $a } @bestpair )[$i];

			print "\tthe best pair is $bp\n";

			my ( $bpp, $bpv ) = split(/\./,$bp );

			$bp = int($bpv);
			print "\tThe card has a value of $bp\n";

			my $wildcard = $valuecards{$bp};

			if ( $wildcard ne "J" ) {
				printf("\tthe card is %s, using the %d jokers to make %d of %s\n", $wildcard, $jokers,  $pairs{$wildcard} + $jokers, $wildcard);

				$pairs{$wildcard} += $jokers;
				delete $pairs{"J"};
				goto OUT;
			}
			else {
				print "\tDon't need to make a joker a joker!\n";
				print "\tTrying again\n";
			}
		}
OUT:
	}
	
	# Score the hand so that five of a kind is best, five different cards is the worst.

	my $pairscore = 0;
	
	my $wildcardhand = "";
	foreach my $card ( sort keys %pairs ) {
		$pairscore += 6 ** ($pairs{$card}-1);

		print "\t\tWe have $pairs{$card} of $card\n";

		# This is just cosmetic for making a nice story - so we get to see what it has used the jokers for. Order isn't important here.

		for ( my $i = 0; $i < $pairs{$card}; $i++ ) {
			$wildcardhand .= "$card";
		}
	} 

	print "\thand is $description{$pairscore} (a pairvalue of $pairscore), with wildcards it looks like $wildcardhand instead of $hand\n";

	# Stash everything in our complex data structure.

	$hands->{$hand}->{pairvalue} = $pairscore;
	$hands->{$hand}->{wildcardhand} = $wildcardhand;

	# Get something sortable, pad it with zeros to make it ascii sortable. The type of hand, followed by the value of each card.
	$handvalue = sprintf( "%04d%s", $pairscore, $handvalue );

	print "\ttotal value is $handvalue\n";

	$hands->{$hand}->{value} = $handvalue;

	# Reverse lookup for later, to be able to get from the value back to the hand. Let's hope hands are unique. If not, we'll need to make it an array, not a scalar.
	if ( !defined( $values{$handvalue} )) {
		$values{$handvalue} = $hand;
	}
	else {
		print "Duplicate value for $hand\n";
		# We'll worry about dealing with this if it ever comes up!
		exit 0;
	}
}

# OK. Everything hand is scored now, wild cards applied, etc. etc. So lets print it out in order, and work out the score.

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
