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
			$m = \%seed_to_soil_map;
			$key = "seed_to_soil";
		}
		elsif ( $line =~ /^soil-to-fertilizer map:/ ) {
			$m = \%soil_to_fertilizer_map;
			$key = "soil_to_fertilizer";
		}
		elsif ( $line =~ /^fertilizer-to-water map:/ ) {
			$m = \%fertilizer_to_water_map;
			$key = "fertilizer_to_water";
		}
		elsif ( $line =~ /^water-to-light map:/ ) {
			$m = \%water_to_light_map;
			$key = "water_to_light";
		}
		elsif ( $line =~ /^light-to-temperature map:/ ) {
			$m = \%light_to_temperature_map;
			$key = "light_to_temperature";
		}
		elsif ( $line =~ /^temperature-to-humidity map:/ ) {
			$m = \%temperature_to_humidity_map;
			$key = "temperature_to_humidity";
		}
		elsif ( $line =~ /^humidity-to-location map:/ ) {
			$m = \%humidity_to_location_map;
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

		$m->{$source}->{source} = $source;
		$m->{$source}->{dest} = $dest;
		$m->{$source}->{range} = $range;

		$rm->{$key}->{for}->{$source}->{source} = $source;
		$rm->{$key}->{for}->{$source}->{dest} = $dest;
		$rm->{$key}->{for}->{$source}->{range} = $range;

		my $rdest = $dest + $range - 1;
		my $rsource = $source + $range - 1;
		$rm->{$key}->{rev}->{$rdest}->{source} = $rsource;
		$rm->{$key}->{rev}->{$rdest}->{dest} = $rdest;
		$rm->{$key}->{rev}->{$rdest}->{range} = $range;
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
	return $best_match;
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
