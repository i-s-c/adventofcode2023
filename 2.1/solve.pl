#!/usr/bin/perl

use strict;

my $sum = 0;

my %gameset;

my $gr = \%gameset;

while ( my $line = <STDIN> ) {
	chomp( $line );


	my ( $title, $stub ) = split( /\:/, $line );
	my $id = $title;
	$id =~ tr/0-9//cd;

	my @games = split( /\;/, $stub );

	foreach my $game ( @games ) {
		#print "$title\t$game\n";
		my @balls = split(/\,/, $game );

		foreach my $ball ( @balls ) {
			while ( $ball =~ /^[ \t]/ ) {
				$ball =~ s/^[ \t]//;
			}

			my ( $count, $colour ) = split(/ /, $ball );

			$gr->{ $id }->{$colour} += $count;

		}

	}
}

foreach my $g ( sort keys %gameset ) {
	my $r = $gameset{$g};

	if ( $r->{"red"} <= 12 && $r->{"green"} <= 13 && $r->{"blue"} <= 14 ) {
		$sum += $g;
	}
}

print "$sum\n";
