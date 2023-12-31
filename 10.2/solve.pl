#!/usr/bin/perl

use strict;
use warnings;

binmode(STDOUT,":utf8" );

$| = 1;
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

my $us;
$us->{"\|"} = "\x{2503}";
$us->{"\-"} = "\x{2501}";
$us->{"L"} = "\x{2517}";
$us->{"J"} ="\x{251B}";
$us->{"7"} = "\x{2513}";
$us->{"F"} = "\x{250F}";
$us->{"\."} = "\x{2588}";
$us->{"S"} = "\x{2573}";
$us->{"\*"} = " ";


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

my $max_x = $i;
my $max_y = $j;
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

	print "I'm at position $x, $y. I've taken $steps steps to get here.  The current shape is " . $us->{$map->[$x][$y]} . "\n";

	if ( $from != 0 && $shapes->{$s}->[0] ) {
		print "I'm on step $steps, Looking North... ";

		if ( $y  - 1 >= 0 ) {
			my $ns = $map->[$x][$y-1];
			if ( $shapes->{$ns}->[1] ) {
				printf( "A $us->{$ns} means that I can go North from here to %d, %d\n", $x, $y - 1 );
				if ( walk( $steps + 1, 1, $x, $y - 1 ) ) {
					@pipes = ( [ $x, $y ], @pipes );
					return 1;
				}
			}
			else {
				print "but the next shape $us->{$ns} doesn't connect here\n";
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
				printf( "A $us->{$ns} means that I can go South from here to %d, %d\n", $x, $y + 1 );
				if ( walk( $steps + 1, 0, $x, $y + 1 ) ) {
					@pipes = ( [ $x, $y ], @pipes );
					return 1;
				}
			}
			else {
				print "but the next shape $us->{$ns} doesn't connect here\n";
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
				printf( "A $us->{$ns} means that I can go East from here to %d, %d\n", $x + 1, $y );
				if ( walk( $steps + 1, 3, $x + 1, $y ) ) {
					@pipes = ( [ $x, $y ], @pipes );
					return 1;
				}
			}
			else {
				print "but the next shape $us->{$ns} doesn't connect here\n";
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
				printf( "A $us->{$ns} means that I can go East from here to %d, %d\n", $x - 1, $y );
				if ( walk( $steps + 1, 2, $x - 1, $y ) ) {
					@pipes = ( [ $x, $y ], @pipes );
					return 1;
				}
			}
			else {
				print "but the next shape $us->{$ns} doesn't connect here\n";
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

	print "Now looking for outside bits\n";

	for ( my $x = 0; $x < $max_x; $x++ ) {
		for ( my $y = 0; $y < $max_y; $y++ ) {
			$grid->[$x][$y] = ".";
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
				last;
			}
			else {
				$grid->[$x][$y] = "*";
			}
		}
	}

	# Edge 2. East to West

	for ( my $y = 0; $y < $max_y; $y++ ) {
		for ( my $x = $max_x - 1; $x >= 0; $x-- ) {
			if ( $grid->[$x][$y] eq " " ) {
				last;
			}
			else {
				$grid->[$x][$y] = "*";
			}
		}
	}

	# Edge 3. North to South

	for ( my $x = 0; $x < $max_x; $x++ ) {
		for ( my $y = 0; $y < $max_y; $y++ ) {
			if ( $grid->[$x][$y] eq " " ) {
				last;
			}
			else {
				$grid->[$x][$y] = "*";
			}
		}
	}
	
	# Edge 4. South to North

	for ( my $x = 0; $x < $max_x; $x++ ) {
		for ( my $y = $max_y - 1; $y >= 0; $y-- ) {
			if ( $grid->[$x][$y] eq " " ) {
				last;
			}
			else {
				$grid->[$x][$y] = "*";
			}
		}
	}

	# OK, now we need to find the "corner" cases.  So check every inside to see if it is adjacent to an inside. We'll have to repeat this until there aren't anymore.
	# Let's see if we can get away with only checking N, S, E, W (i.e. not the diagonals ).


	my $replacements;
	do {
		$replacements = 0;

		for ( my $x = 0; $x < $max_x; $x++ ) {
			for ( my $y = 0; $y < $max_y; $y++ ) {
				if ( $grid->[$x][$y] eq "." ) {
					for ( my $ox = -1; $ox <= 1; $ox++ ) {
						for ( my $oy = -1; $oy <= 1; $oy++ ) {
							if ( $grid->[$x+$ox][$y+$oy] eq "*" ) {
								$replacements++;
								$grid->[$x][$y] = "*";
							}
						}
					}
				}
			}
		}

	} while ( $replacements );
	

	my $insides = 0;
	for ( my $y = 0; $y < $max_y; $y++ ) {
		for ( my $x = 0; $x < $max_x; $x++ ) {
			#printf( "%s", $grid->[$x][$y]);
			if ( $grid->[$x][$y] eq "." ) {
				$insides++;
			}
			if ( $grid->[$x][$y] eq " " ) {
				printf( "%s", $us->{ $map->[$x][$y]});
			}
			else {
				printf( "%s", $us->{$grid->[$x][$y]});
			}
		}
		print "\n";
	}

	print "There are $insides inside\n";
}


# Now we need to find edges.  Each cell can be divided into four quadrants. Each quadrant will be inside or outside.
# So we can represent inside as 1, outside as 0
# So our 4 bits can map nicely to a single number for each cell
#
# 1 0
# 3 2
# 
# We just need to find an edge. Doesn't need to be the starting point, and work our way round.  Probably easiest to find a straight edge (north to south) as it's unambiguous.
# Then inside tiles are when adjacent halves are all inside. Once we've gone round the pipe, we can then find the inside adjacent pieces. And so on.





