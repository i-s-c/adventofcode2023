#!/usr/bin/perl

use strict;
use warnings;

my $deck;

# 1. Parse the input and read it into the deck of cards. Work out the number of wins
# Each card has a number of wins and the count of instances of the card
while ( my $line = <STDIN> ) {
	chomp($line);

	$line =~ s/  / /g; # Perl is very sensitive to whitespace. Just get rid of multuples
	my ( $name, $rest ) = split(/:/,$line);

	my $id = $name;
	$id =~ tr/0-9//cd; # Each card has a number, this identifies the card

	$rest =~ s/^ //; # Get rid of leading white space.

	my ( $winnerstring, $numberstring ) = split( /\|/, $rest );

	$winnerstring =~ s/ $//;
	$numberstring =~ s/^ //;

	my @winners = split( / /, $winnerstring );
	my @numbers = split( / /, $numberstring );

	# We now have a list of winning numbers and the playing numbers.

	# Let a hash take the strain: So we don't have to loop round the list of winners all the time. Just makes it easier to read later.

	my %win;

	foreach my $w ( @winners ) {
		$win{$w} = 1;
	}

	my $wins = 0;
	# See how many of the numbers are wins
	foreach my $n ( @numbers ) {
		if( defined($win{$n}) ) {
			$wins++;
		}
	}

	# Add that information to the deck
	$deck->{$id}->{count}=1;
	$deck->{$id}->{wins}=$wins;

	
}

# Now duplicate the cards as per part 2 instructions. Go through the deck, duplicate the cards. Theoretically, we might need boundary conditions, but the data is empirically OK.
# Keep a running total after we've finished each card.

my $sum = 0;
foreach my $i ( sort { $a <=> $b } keys %$deck ) {

	print "Processing card $i which has a count of $deck->{$i}->{count} and $deck->{$i}->{wins} wins\n";
	for ( my $c = 0; $c < $deck->{$i}->{count}; $c++ ) {
		for ( my $j = $i + 1; $j <= $i + $deck->{$i}->{wins}; $j++ ) {
			$deck->{$j}->{count} += 1;
			print "\tDuplicating card $j so there are now $deck->{$j}->{count} of them with $deck->{$j}->{wins}\n";
		}
	}
	
	$sum += $deck->{$i}->{count};
}

print "SUM: $sum\n";
