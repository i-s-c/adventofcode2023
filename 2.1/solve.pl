#!/usr/bin/perl

use strict;

my $sum = 0;

my %gameset;

my $gr = \%gameset;

my %max = ( "red" => 12, "green" => 13, "blue" => 14 );

print $max{"red"} . "\n";

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

		
			if ( $count > $max{$colour} ) {
				print "$colour $count $max{$colour}\n";
				$gr->{$id}->{"impossible"} = 1;
			}
			$gr->{ $id }->{$colour} += $count;
		}

	}
}

foreach my $g ( sort { $a <=> $b } keys %gameset ) {
	my $r = $gameset{$g};

	unless ( $r->{"impossible"} == 1 ) {
		$sum += $g;
	}

	my @a;
	foreach my $b ( sort keys %$r ) {
		@a = ( @a, "$b: $gameset{$g}->{$b}" );
	}
	print "$g: " . join( ", ", @a ) . "\n";
}

print "$sum\n";
