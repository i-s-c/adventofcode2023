#!/usr/bin/perl

use strict;
use warnings;

my %seed_to_soil_map;
my %soil_to_fertilizer_map;
my %fertilizer_to_water_map;
my %water_to_light_map;
my %light_to_temperature_map;
my %temperature_to_humidity_map;
my %humidity_to_location_map;

my @seeds;

my $m;

# Start by reading in the maps

while ( my $line = <STDIN> ) {
	chomp( $line );

	if ( $line =~ /\:/ ) {
		if ( $line =~ /^seeds:/ ) {
			my $s = $line;
			$s =~ tr/0-9 //cd;
			$s =~ s/^ //;
			@seeds = split(/ /,$s);
		}
		elsif ( $line =~ /^seed-to-soil map:/ ) {
			$m = \%seed_to_soil_map;
		}
		elsif ( $line =~ /^soil-to-fertilizer map:/ ) {
			$m = \%soil_to_fertilizer_map;
		}
		elsif ( $line =~ /^fertilizer-to-water map:/ ) {
			$m = \%fertilizer_to_water_map;
		}
		elsif ( $line =~ /^water-to-light map:/ ) {
			$m = \%water_to_light_map;
		}
		elsif ( $line =~ /^light-to-temperature map:/ ) {
			$m = \%light_to_temperature_map;
		}
		elsif ( $line =~ /^temperature-to-humidity map:/ ) {
			$m = \%temperature_to_humidity_map;
		}
		elsif ( $line =~ /^humidity-to-location map:/ ) {
			$m = \%humidity_to_location_map;
		}
		else {
			print "Mapping start error\n";
			exit 0;
		}
	}
	elsif ( $line eq "" ) {
	}
	else {
		# Assume that the data is right. Saves time.
		my ( $dest, $source, $range ) = split(/ /, $line );

		$m->{$source}->{source} = $source;
		$m->{$source}->{dest} = $dest;
		$m->{$source}->{range} = $range;
	}
}

my @transformation_map_list = ( \%seed_to_soil_map,
	\%soil_to_fertilizer_map,
	\%fertilizer_to_water_map,
	\%water_to_light_map,
	\%light_to_temperature_map,
	\%temperature_to_humidity_map,
	\%humidity_to_location_map );

# Assume that lowest x -> lowest y (i.e all the numbers are in order

my $lowest_location = -1;

#print "Seeds: " . join ( ", ", @seeds ) . "\n";

while ( my $is = shift( @seeds) ) {
	# Quick hack
	my $r = shift ( @seeds );
	#print "initial Seed $is range $r\n";

	for ( my $s = $is; $s < $is + $r; $s++ ) {
		my $l = $s;
		foreach my $m ( @transformation_map_list ) {
			$l = get_lowest_map( $m, $l );
		}
		#print "Lowest location for seed $s is $l\n";
		if ( $lowest_location == -1 or $l < $lowest_location ) {
			$lowest_location = $l;
		}
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
