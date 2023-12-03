#!/usr/bin/perl

use strict;

# Read in an array

my $sum = 0;
my @a;

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
			$num_str[0] = check_adjacent( $num_str[0], $i, $j );
			@num_str = ( @num_str, $a[$i][$j] );
		}
		else {
			if ( $in_num ) {
				my $adjacent = shift ( @num_str );
				my $n = join("",@num_str);
				print "Y $i $j $adjacent\t$n\n";
				if ( $adjacent ) {
					$sum += $n;
				}
			}

			$in_num = 0;
			@num_str = ( 0 );
		}
	}

	if ( $in_num ) {
		my $adjacent = shift ( @num_str );
		my $n = join("",@num_str);
		print "X $adjacent\t$n\n";
		if ( $adjacent ) {
			$sum += $n;
		}

	}
}

print "SUM: $sum\n";


exit 0;

sub check_adjacent {
	my ( $adjacent, $x, $y ) = @_;

	if ( $adjacent ) {
		return 1;
	}
	for ( my $i = $x - 1; $i <= $x + 1; $i++ ) {
		for ( my $j = $y - 1; $j <= $y + 1; $j++ ) {
			if ( $i >= 0 && $i < $max_i && $j >= 0 && $j < $max_j ) {
				unless ( $i == $x && $j == $y ) {
					print "Checking cell adjacent to $x, $y at $i, $j $a[$i][$j]\t";
					my $v = $a[$i][$j];

					$v =~ tr/0-9//d;
					$v =~ tr/\.//d;

					if ( length($v) > 0 ) {
						print "$v YES\n";
						return 1;
					}
					else {
						print "$v NO\n";
					}
				}
			}
		}
	}

	return 0;
}
