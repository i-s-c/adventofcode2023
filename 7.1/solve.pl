#!/usr/bin/perl

use strict;
use warnings;



my %hands;

while ( my $line = <STDIN> ) {
	chomp($line);
	my ( $hand, $bid ) = split( / /, $line );

	# Swap J,Q,K,A to A,B,C,D for easier sorting

	$hand =~ tr/TJQKA/BCDEF/;

	$hands{$hand} = $bid;
}

# Sort/Score the hands

my %sorted_hands;
foreach my $hand ( keys %hands ) {
	my @cards = split(//,$hand);

	my %pairs;
	my %revpairs;
	my @sorted_cards;
	my $pair_card = "";
	my $pair_count = 0;
	foreach my $card ( sort @cards ) {
		$pairs{$card} += 2;
		if ( $pairs{$card} > $pair_count ) {
			$pair_count = $pairs{$card};
		}
		@sorted_cards = ( $card, @sorted_cards );
	}

	my $two = 0;
	my $last_two_card = "";
	foreach my $fudge ( @sorted_cards ) {
		#print "FUDGE: $fudge $pairs{$fudge} ";
		if ( $pairs{$fudge} == 4 ) {
			if ( $last_two_card ne $fudge ) {
				$two++;
				if ( $two == 2 ) {
					$pairs{$fudge}--;
				}
				$last_two_card = $fudge;
			}
			if ( $two == 2 ) {
				$pairs{$fudge}--;
			}
		}
		#print "$two\n";
		
	}
	
	my @s;
	foreach my $card ( @sorted_cards ) {
		$card = sprintf( "%d_%s", 10 - $pairs{$card}, $card );
		@s = ( $card, @s );
	}

	@sorted_cards = sort( @s );
	
	my $sorted_hand = "$pair_count:" . join(",", @sorted_cards ) . ":$pair_card";
	$sorted_hands{$sorted_hand} = $hands{$hand};

	#print "Endofhand\n";
	
}

my $rank = 1;
my $sum = 0;
foreach my $key ( sort keys %sorted_hands ) {
	my ( $paircount, $hand, $paircard ) = split( /\:/, $key );
	$hand =~ s/[012345678]_//g;
	$hand =~ s/X/${paircard}/g;
	$hand =~ tr/BCDFE/TJQKA/;
	printf( "%d, %s %d = %d\t%s\n", $rank, $hand, $sorted_hands{$key}, $sorted_hands{$key} * $rank, $key);
	$sum += $sorted_hands{$key} * $rank;
	$rank++;
}

print "ANSWER: $sum\n";

exit 0;
