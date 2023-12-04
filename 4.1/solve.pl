#!/usr/bin/perl

use strict;

my $sum = 0;

while ( my $line = <STDIN> ) {
	chomp($line);

	$line =~ s/  / /g;
	my ( $name, $rest ) = split(/:/,$line);

	$rest =~ s/^ //;
	

	my ( $winnerstring, $numberstring ) = split( /\|/, $rest );

	$winnerstring =~ s/ $//;
	$numberstring =~ s/^ //;

	my @winners = split( / /, $winnerstring );
	my @numbers = split( / /, $numberstring );

	# Let a hash take the strain

	my %win;

	foreach my $w ( @winners ) {
		$win{$w} = 1;
	}

	my $count = 0;
	foreach my $n ( @numbers ) {
		if( defined($win{$n}) ) {
			print "$name has winning number $n\n";
			$count++;
		}
	}

	
	my $score = 0;
	if ( $count > 0 ) {
		$score = 2 ** ( $count - 1 );
	}

	print "$name $count $score\n";
	$sum += $score;
}

print "SUM: $sum\n";
