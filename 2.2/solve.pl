#!/usr/bin/perl

use strict;

my $sum = 0;

my %gameset;

my $gr = \%gameset;

my %max = ( "red" => 12, "green" => 13, "blue" => 14 );

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

			if ( $gr->{$id}->{$colour} < $count ) {
				$gr->{ $id }->{$colour} = $count;
			}
		}

	}
}

foreach my $g ( sort { $a <=> $b } keys %gameset ) {
	my $r = $gameset{$g};

	my $power = $r->{"red"} * $r->{"green"} * $r->{"blue"};

	$sum += $power;

}

print "$sum\n";
