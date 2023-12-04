#!/usr/bin/perl

use strict;

my $sum = 0;

my %deck;
my $d = \%deck;
my $max_id = 0;

while ( my $line = <STDIN> ) {
	chomp($line);

	$line =~ s/  / /g;
	my ( $name, $rest ) = split(/:/,$line);

	my $id = $name;
	$id =~ tr/0-9//cd;

	if ( $id > $max_id ) {
		$max_id = $id;
	}

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

	my $wins = 0;
	foreach my $n ( @numbers ) {
		if( defined($win{$n}) ) {
			print "$name has winning number $n\n";
			$wins++;
		}
	}

	$d->{$id}->{count}=1;
	$d->{$id}->{wins}=$wins;

	
#	my $score = 0;
#	if ( $count > 0 ) {
#		$score = 2 ** ( $count - 1 );
#	}

#	print "$name $count $score\n";
#	$sum += $score;
}

print "$max_id\n";

foreach my $i ( sort { $a <=> $b } keys %$d ) {

	for ( my $j = $i + 1; $j <= $i + $d->{$i}->{wins}; $j++ ) {
		$d->{$j}->{count} += 1;
	}
}


foreach my $i ( sort { $a <=> $b } keys %$d ) {
	print "Card $i has $d->{$i}->{count}\n";
	$sum += $d->{$i}->{count};
}

print "SUM: $sum\n";
