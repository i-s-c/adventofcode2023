#!/usr/bin/perl

use strict;

# Read in an array

my $sum = 0;
my @a;
my %stars = ();

my %results;
my $r = \%results;

my $i = 0;
my $max_j = 0;
while ( my $line = <STDIN> ) {
	chomp($line);

	my $j = 0;
	foreach my $e ( split(//,$line) ) {
	
		$a[$i][$j] = $e;

		$j++;
	}

	if ( $j > $max_j ) {
		$max_j = $j;
	}
	
	$i++;
}

my $max_i = $i;

print "Array has size $max_i by $max_j\n";

# Let's find numbers

my $in_num = 0;

for ( $i = 0; $i < $max_i; $i++ ) {
	$in_num = 0;
	my @num_str = ( 0 );
	for ( my $j = 0; $j < $max_j; $j++ ) {
		if ( $a[$i][$j] =~ /[0-9]/ ) {
			$in_num = 1;
			# This won't work if the same numbers are part of multiple ratios
			$num_str[0] = check_adjacent( $num_str[0], $i, $j );
			@num_str = ( @num_str, $a[$i][$j] );
		}
		else {
			if ( $in_num ) {
				my $adjacent = shift ( @num_str );
				my $n = join("",@num_str);
				print "$i $j $adjacent\t$n\n";
				$r->{$adjacent}->{$n} = $adjacent;

			}

			$in_num = 0;
			@num_str = ( 0 );
		}
	}

	if ( $in_num ) {
		my $adjacent = shift ( @num_str );
		my $n = join("",@num_str);
		print "$adjacent\t$n\n";
		$r->{$adjacent}->{$n} = $adjacent;

	}
}

print "Results\n";
foreach my $id ( sort keys %stars ) {
	my $ratio = 1;
	my $i = -1;  # hack which only works if there are exactly two numbers in a ratio, and one if there aren't.

	foreach my $n ( sort keys %$r->{$id} ) {
		#print "\t$id\t$n\n";

		$ratio = $ratio * $n;
		$i++;
	}
	$ratio = $ratio * $i;
	print "Ratio for $id is $ratio\n";
	$sum += $ratio;
}

print "SUM: $sum\n";


exit 0;

sub check_adjacent {
	my ( $adjacent, $x, $y ) = @_;

	if ( $adjacent ) {
		print "Already adjacent to $adjacent\n";
	}
	for ( my $i = $x - 1; $i <= $x + 1; $i++ ) {
		for ( my $j = $y - 1; $j <= $y + 1; $j++ ) {
			if ( $i >= 0 && $i < $max_i && $j >= 0 && $j < $max_j ) {
				unless ( $i == $x && $j == $y ) {
					#print "Checking cell adjacent to $x, $y at $i, $j $a[$i][$j]\n";
					my $v = $a[$i][$j];

					# Just looking for a *

					if ( $v eq "*" ) {
						my $id = $i * $max_i + $j;
						if ( $adjacent and $id != $adjacent ) {
							print "Warning: Current number is adjacent to multiple stars $id $adjacent\n";
						}
						$stars{$id}++;
						return $id;
					}

				}
			}
		}
	}

	return $adjacent;
}
