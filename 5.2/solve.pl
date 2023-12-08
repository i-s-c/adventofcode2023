#!/usr/bin/perl

use strict;
use warnings;

$| = 1;

my @seeds;

my $key;
my $rm;
my @key_list;
my @rev_key_list;

# Start by reading in the maps

while ( my $line = <STDIN> ) {
	chomp( $line );

	if ( $line =~ /\:/ ) {
		$key = "";
		if ( $line =~ /^seeds:/ ) {
			my $s = $line;
			$s =~ tr/0-9 //cd;
			$s =~ s/^ //;
			@seeds = split(/ /,$s);
		}
		elsif ( $line =~ /^seed-to-soil map:/ ) {
			$key = "seed_to_soil";
		}
		elsif ( $line =~ /^soil-to-fertilizer map:/ ) {
			$key = "soil_to_fertilizer";
		}
		elsif ( $line =~ /^fertilizer-to-water map:/ ) {
			$key = "fertilizer_to_water";
		}
		elsif ( $line =~ /^water-to-light map:/ ) {
			$key = "water_to_light";
		}
		elsif ( $line =~ /^light-to-temperature map:/ ) {
			$key = "light_to_temperature";
		}
		elsif ( $line =~ /^temperature-to-humidity map:/ ) {
			$key = "temperature_to_humidity";
		}
		elsif ( $line =~ /^humidity-to-location map:/ ) {
			$key = "humidity_to_location";
		}
		else {
			print "Mapping start error\n";
			exit 0;
		}
		if ( $key ne "" ) {
			@key_list = ( @key_list, $key );
			@rev_key_list = ( $key, @rev_key_list );
		}
	}
	elsif ( $line eq "" ) {
	}
	else {
		#print "$key -> $line\n";
		# Assume that the data is right. Saves time.
		my ( $dest, $source, $range ) = split(/ /, $line );

		$rm->{$key}->{for}->{$source}->{source} = $source;
		$rm->{$key}->{for}->{$source}->{dest} = $dest;
		$rm->{$key}->{for}->{$source}->{range} = $range;

		my $rdest = $dest + $range - 1;
		my $rsource = $source + $range - 1;
		$rm->{$key}->{rev}->{$dest}->{source} = $dest;
		$rm->{$key}->{rev}->{$dest}->{dest} = $source;
		$rm->{$key}->{rev}->{$dest}->{range} = $range;
	}
}

# Assume that lowest x -> lowest y (i.e all the numbers are in order

my $lowest_location = -1;

print "Seeds: " . join ( ", ", @seeds ) . "\n";

# It's too slow.  So what we want is just a list of seeds that are in the ranges... so when there is a break, take that one.

my $seed_matrix;

while ( my $is = shift ( @seeds ) ) {
	my $r = shift ( @seeds );
	$seed_matrix->{$is} = $r;
}

my @quick_seeds;

#resolve_seed_matrix( $seed_matrix );

foreach my $key ( keys %$rm ) {
	print "$key:\n";

	foreach my $s ( sort { $a <=> $b } keys %{$rm->{$key}->{rev}} ) {
		printf( "%d %d %d\n", $rm->{$key}->{rev}->{$s}->{dest}, $rm->{$key}->{rev}->{$s}->{source}, $rm->{$key}->{rev}->{$s}->{range} );
		
	}
}

exit 0;

foreach my $is ( sort { $a <=> $b } keys %$seed_matrix ) {
	my $r = $seed_matrix->{$is};

	my $last_l = -1;
	for ( my $s = $is; $s < $is + $r; $s++ ) {
		## Find the lowest map
		#my $lowest = $s;
		#foreach my $k ( @key_list ) {
		#	$lowest = get_lowest_map( $rm->{$k}->{for}, $lowest );
		#}
		#my $highest = $lowest;
		#foreach my $k ( @rev_key_list ) {
		#	print "$k $highest ";
		#	$highest = get_highest_map( $rm->{$k}->{rev}, $highest );
		#	print " -> $highest\n";
		#}
		#print "Seed $s maps to location $lowest, which maps to highest seed $highest\n";
		##my $l = get_last_in_range( \%seed_to_soil_map, $s );
		##print "$s $l\n";
		##if ( $l != $last_l ) {
		#	#print "Seed $s\n";
			@quick_seeds = ( @quick_seeds, $s );
		#	#$last_l = $l;
		##}
	}
}

print "Start as normal\n";

foreach my $s ( @quick_seeds ) {
	my $l = $s;
	print "$l";
	foreach my $k ( @key_list ) {
		$l = get_lowest_map( $rm->{$k}->{for}, $l );
		print ",$l";
	}
	print "\n";
	#print "Lowest location for seed $s is $l\n";
	if ( $lowest_location == -1 or $l < $lowest_location ) {
		$lowest_location = $l;
	}
}

print "ANSWER: $lowest_location\n";

exit 0;

sub get_lowest_map {
	my ( $map, $i ) = @_;

	foreach my $source ( sort { $a <=> $b } keys %$map ) {
		if ( $i >= $source && $i < $source + $map->{$source}->{range} ) {
			my $offset = $i - $source;
			return $map->{$source}->{dest} + $offset;
		}
	}
	return $i;
}

sub get_highest_map {
	my ( $map, $i ) = @_;

	my $best_match = $i;

	foreach my $dest ( sort { $b <=> $a } keys %$map ) {
		#print "Looking at $dest\n";
		if ( $i > $dest - $map->{$dest}->{range} && $i <= $dest ) {
			my $offset = $i - $dest;
			#return $map->{$dest}->{source} + $offset;
			return $map->{$dest}->{source};
		}
		$best_match = $map->{$dest}->{source};
	}
	#print "Not in range\n";
	return $i;
	#return $best_match;
}

sub get_last_in_range {
	my ( $map, $i ) = @_;
	foreach my $source ( sort { $a <=> $b } keys %$map ) {
		if ( $i >= $source && $i < $source + $map->{$source}->{range} ) {
			my $tmp = $source + $map->{$source}->{range} - 1;
			print "Item $i is in range $source to $tmp\n";
			return $source + $map->{$source}->{range} - 1;
		}
	}
	return $i;
}

sub resolve_seed_matrix {
	my ( $sm ) = @_;

	my @key_copy = @key_list;

	find_range_for_map( \@key_copy, $sm );
		
}

sub find_range_for_map {
	my ( $keys, $sm ) = @_;

	my $new_sm;

	my $key = shift @$keys;


	if ( !defined($key) ) {
		return;
	}

	print "$key\n";

	my $map = $rm->{$key}->{for};

	
	foreach my $s ( sort { $a <=> $b } keys %$sm ) {
		my $low = $s;
		my $high = $low + $sm->{$s} - 1;

		print "\tINPUT($low,$high)\n";

		foreach my $r ( sort { $a <=> $b } keys %$map ) {
			my $start = $map->{$r}->{source};
			my $end = $start + $map->{$r}->{range} - 1;
			my $offset = $start - $map->{$r}->{dest};
			print "\t\tOUTPUT($start, $end)  $map->{$r}->{range} $map->{$r}->{dest}\n";

			my @coords;
			if ( $low < $start ) {
				if ( $high < $start ) {
					@coords = ( @coords, [ $low, $high ] );
					@coords = ( @coords, [ $start, $end ] );
				}
				elsif ( $high > $end ) {
					@coords = ( @coords, [ $low, $start - 1 ] );
					@coords = ( @coords, [ $start, $end ] );
					@coords = ( @coords, [ $end + 1, $high ] );
				}
				else {
					@coords = ( @coords, [ $low, $start - 1 ] );
					@coords = ( @coords, [ $start, $high ] );
					@coords = ( @coords, [ $high + 1, $end ] );
				}
			}
			elsif ( $low > $end ) {
				@coords = ( @coords, [ $start, $end ] );
				@coords = ( @coords, [ $low, $high ] );
			}
			else { # low is within start and end 
				if ( $high > $end ) {
					@coords = ( @coords, [ $start, $low - 1 ] );
					@coords = ( @coords, [ $low, $end ] );
					@coords = ( @coords, [ $end + 1, $high ] );
				}
				else {
					@coords = ( @coords, [ $start, $low - 1 ] );
					@coords = ( @coords, [ $low, $high ] );
					@coords = ( @coords, [ $high + 1, $end ] );
				}
			}

			foreach my $a ( @coords ) {

				my $new_source = $a->[0];
				my $new_range = $a->[1] - $a->[0] + 1;
				my $new_dest = $a->[0] - $offset;
				print "\t\t$a->[0], $a->[1] $new_range $new_dest\n";

				$rm->{$key}->{complete}->{$new_source}->{source} = $new_source;
				$rm->{$key}->{complete}->{$new_source}->{dest} = $new_dest;
				$rm->{$key}->{complete}->{$new_source}->{range} = $new_range;
				
				$rm->{$key}->{rev_complete}->{$new_dest}->{source} = $new_source;
				$rm->{$key}->{rev_complete}->{$new_dest}->{dest} = $new_dest;
				$rm->{$key}->{rev_complete}->{$new_dest}->{range} = $new_range;

				$new_sm->{$new_dest} = $new_range;

			}
		}
	}

	find_range_for_map($keys, $new_sm )
}
