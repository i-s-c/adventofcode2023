#!/usr/bin/perl

use strict;
use warnings;

$| = 1;

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

print "Seeds: " . join ( ", ", @seeds ) . "\n";

# It's too slow.  So what we want is just a list of seeds that are in the ranges... so when there is a break, take that one.

my $seed_matrix;

while ( my $is = shift ( @seeds ) ) {
	my $r = shift ( @seeds );
	$seed_matrix->{$is} = $r;
}

my @quick_seeds;

foreach my $is ( sort { $a <=> $b } keys %$seed_matrix ) {
	my $r = $seed_matrix->{$is};

	my $last_l = -1;
	for ( my $s = $is; $s < $is + $r; $s++ ) {
		my $lowest = get_lowest_map( \%seed_to_soil_map, $s );
		print "Seed $s maps to soil $lowest\n";
		my $l = get_last_in_range( \%seed_to_soil_map, $s );
		print "$s $l\n";
		if ( $l != $last_l ) {
			print "Seed $s\n";
			@quick_seeds = ( @quick_seeds, $s );
			$last_l = $l;
		}
	}
}

exit 0;

foreach my $s ( @quick_seeds ) {
	my $l = $s;
	foreach my $m ( @transformation_map_list ) {
		$l = get_lowest_map( $m, $l );
	}
	print "Lowest location for seed $s is $l\n";
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
