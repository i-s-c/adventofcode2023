#!/usr/bin/perl

use strict;
use warnings;

# Let's describe the various shapes

my $shapes;

$shapes->{"\|"} = [ 1, 1, 0, 0 ];
$shapes->{"\-"} = [ 0, 0, 1, 1 ];
$shapes->{"L"} = [ 1, 0, 1, 0 ];
$shapes->{"J"} = [ 1, 0, 0, 1 ];
$shapes->{"7"} = [ 0, 1, 0, 1 ];
$shapes->{"F"} = [ 0, 1, 1, 0 ];
$shapes->{"\."} = [ 0, 0, 0, 0 ];
$shapes->{"S"} = [ 1, 1, 1, 1 ];

my @compass = ( "North", "South", "East", "West" );

# Now read the input

my $map;

my @pipes;

my $i = 0;
my $j = 0;
my @pos;
my @start;

while ( my $line = <STDIN> ) {
	chomp($line);
	$i = 0;

	foreach my $shape ( split(//,$line) ) {
		$map->[$i][$j] = $shape;

		if ( $shape eq "S" ) {
			@start = ( $i, $j );
		}
		$i++;
	}

	$j++;
}

my $max_x = $j;
my $max_y = $i;
print "Size is $max_x, $max_y\n";

my $size = 0;

print "Start is " . join(", ",@start ) . "\n";

if ( walk( 0, -1, @start ) ) {
	print "Found the loop it is $size steps long\n";

	printf( "The are %d sections in the pipe\n", scalar(@pipes));

	find_outside( @pipes );
}

printf( "Answer:  %d\n", $size / 2 );

exit 0;

sub walk {
	my ( $steps, $from, $x, $y ) = @_;

	if ( $steps > 0 ) {
		print "I've come from the $compass[$from]\n";
	}

	my $s = $map->[$x][$y];

	if ( $s eq "S" and $steps > 0 ) {
		print "I'm back at the beginning at $steps steps!\n";
		$size = $steps;
		return 1;
	}

	print "I'm at position $x, $y. I've taken $steps steps to get here.  The current shape is " . $map->[$x][$y] . "\n";

	if ( $from != 0 && $shapes->{$s}->[0] ) {
		print "I'm on step $steps, Looking North... ";

		if ( $y  - 1 >= 0 ) {
			my $ns = $map->[$x][$y-1];
			if ( $shapes->{$ns}->[1] ) {
				printf( "A $ns means that I can go North from here to %d, %d\n", $x, $y - 1 );
				if ( walk( $steps + 1, 1, $x, $y - 1 ) ) {
					@pipes = ( [ $x, $y ], @pipes );
					return 1;
				}
			}
			else {
				print "but the new shape $ns doesn't connect here\n";
			}
		}
		else {
			print "but this is off the map\n";
		}

	}
	if ( $from != 1 && $shapes->{$s}->[1] ) {
		print "I'm on step $steps, Looking South... ";

		if ( $y  + 1 < $max_y ) {
			my $ns = $map->[$x][$y+1];
			if ( $shapes->{$ns}->[0] ) {
				printf( "A $ns means that I can go South from here to %d, %d\n", $x, $y + 1 );
				if ( walk( $steps + 1, 0, $x, $y + 1 ) ) {
					@pipes = ( [ $x, $y ], @pipes );
					return 1;
				}
			}
			else {
				print "but the new shape $ns doesn't connect here\n";
			}
		}
		else {
			print "but this is off the map\n";
		}
	}
	if ( $from != 2 && $shapes->{$s}->[2] ) {
		print "I'm on step $steps, Looking East... ";

		if ( $x  + 1 < $max_x ) {
			my $ns = $map->[$x + 1][$y];
			if ( $shapes->{$ns}->[3] ) {
				printf( "A $ns means that I can go East from here to %d, %d\n", $x + 1, $y );
				if ( walk( $steps + 1, 3, $x + 1, $y ) ) {
					@pipes = ( [ $x, $y ], @pipes );
					return 1;
				}
			}
			else {
				print "but the new shape $ns doesn't connect here\n";
			}
		}
		else {
			print "but this is off the map\n";
		}
	}
	if ( $from != 3 && $shapes->{$s}->[3] ) {
		print "I'm on step $steps, Looking West... ";

		if ( $x  - 1 >= 0 ) {
			my $ns = $map->[$x - 1][$y];
			if ( $shapes->{$ns}->[2] ) {
				printf( "A $ns means that I can go East from here to %d, %d\n", $x - 1, $y );
				if ( walk( $steps + 1, 2, $x - 1, $y ) ) {
					@pipes = ( [ $x, $y ], @pipes );
					return 1;
				}
			}
			else {
				print "but the new shape $ns doesn't connect here\n";
			}
		}
		else {
			print "but this is off the map\n";
		}
	}
	
	return 0;
}

sub find_outside {
	my ( @pipe ) = @_;

	my $grid;

	for ( my $j = 0; $j < $max_x; $j++ ) {
		for ( my $i = 0; $i < $max_y; $i++ ) {
			$grid->[$j][$i] = ".";
		}
	}

	foreach my $p ( @pipes ) {
		#printf( "%d,%d\n", $p->[0], $p->[1] );
		$grid->[$p->[0]][$p->[1]] = ' ';
	}

	# Outside must be from the edges in. So there are four moves: down the west edge, going east until you hit a pipe, then stopping.

	# Edge 1. West to East

	for ( my $y = 0; $y < $max_y; $y++ ) {
		for ( my $x = 0; $x < $max_x; $x++ ) {
			if ( $grid->[$x][$y] eq " " ) {
				goto OUT1;
			}
			else {
				$grid->[$x][$y] = "*";
			}
		}
OUT1:
	}

	# Edge 2. East to West

	for ( my $y = 0; $y < $max_y; $y++ ) {
		for ( my $x = $max_x - 1; $x >= 0; $x-- ) {
			if ( $grid->[$x][$y] eq " " ) {
				goto OUT2;
			}
			else {
				$grid->[$x][$y] = "*";
			}
		}
OUT2:
	}

	# Edge 3. North to South

	for ( my $x = 0; $x < $max_x; $x++ ) {
		for ( my $y = 0; $y < $max_y; $y++ ) {
			if ( $grid->[$x][$y] eq " " ) {
				goto OUT3;
			}
			else {
				$grid->[$x][$y] = "*";
			}
		}
OUT3:
	}
	
	# Edge 4. South to North

	for ( my $x = 0; $x < $max_x; $x++ ) {
		for ( my $y = $max_y - 1; $y >= $0; $y-- ) {
			if ( $grid->[$x][$y] eq " " ) {
				goto OUT4;
			}
			else {
				$grid->[$x][$y] = "*";
			}
		}
OUT4:
	}

	# OK, now we need to find the "corner" cases.  So check every inside to see if it is adjacent to an inside. We'll have to repeat this until there aren't anymore.
	# Let's see if we can get away with only checking N, S, E, W (i.e. not the diagonals ).


	my $replacements;
	do {
		$replacements = 0;

		for ( my $x = 0; $x < $max_x; $x++ ) {
			for ( my $y = 0; $y < $max_y; $y++ ) {
				if ( $grid->[$x][$y] eq "." ) {
					# Not checking if we are off the grid
					if ( $grid->[$x-1][$y] eq "*" ) {
						$replacements++;
						$grid->[$x][$y] = "*";
					}
					if ( $grid->[$x+1][$y] eq "*" ) {
						$replacements++;
						$grid->[$x][$y] = "*";
					}
					if ( $grid->[$x][$y+1] eq "*" ) {
						$replacements++;
						$grid->[$x][$y] = "*";
					}
					if ( $grid->[$x][$y-1] eq "*" ) {
						$replacements++;
						$grid->[$x][$y] = "*";
					}
				}
			}
		}

	} while ( $replacements );
	

	my $insides = 0;
	for ( my $j = 0; $j < $max_x; $j++ ) {
		for ( my $i = 0; $i < $max_y; $i++ ) {
			printf( "%s", $grid->[$i][$j]);
			if ( $grid->[$i][$j] eq "." ) {
				$insides++;
			}
		}
		print "\n";
	}

	print "There are $insides inside\n";
}

