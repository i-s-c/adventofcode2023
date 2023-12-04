#!/usr/bin/perl

use strict;

my $sum = 0;

my %deck;
my $d = \%deck;
while ( my $line = <STDIN> ) {
	chomp($line);

	$line =~ s/  / /g;
	my ( $name, $rest ) = split(/:/,$line);

	my $id = $name;
	$id =~ tr/0-9//cd;

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
			$wins++;
		}
	}

	$d->{$id}->{count}=1;
	$d->{$id}->{wins}=$wins;

	
}

foreach my $i ( sort { $a <=> $b } keys %$d ) {

	print "Processing card $i which has a count of $d->{$i}->{count} and $d->{$i}->{wins} wins\n";
	for ( my $c = 0; $c < $d->{$i}->{count}; $c++ ) {
		for ( my $j = $i + 1; $j <= $i + $d->{$i}->{wins}; $j++ ) {
			$d->{$j}->{count} += 1;
			print "\tDuplicating card $j so there are now $d->{$j}->{count} of them with $d->{$j}->{wins}\n";
		}
	}
}


foreach my $i ( sort { $a <=> $b } keys %$d ) {
	print "Card $i has a total of $d->{$i}->{count}\n";
	$sum += $d->{$i}->{count};
}

print "SUM: $sum\n";
