#!/usr/bin/perl

use strict;
use warnings;

# Let's describe the various shapes

my $shapes;

#$shapes->{"\|"}->{N}=1; $shapes->{"\|"}->{S}=1; $shapes->{"\|"}->{E}=0; $shapes->{"\|"}->{W}=0; 
$shapes->{"\|"} = [ 1, 1, 0, 0 ];
#$shapes->{"\-"}->{N}=0; $shapes->{"\-"}->{S}=0; $shapes->{"\-"}->{E}=1; $shapes->{"\-"}->{W}=1; 
$shapes->{"\-"} = [ 0, 0, 1, 1 ];
#$shapes->{"L"}->{N}=1; $shapes->{"L"}->{S}=0; $shapes->{"L"}->{E}=1; $shapes->{"L"}->{W}=0; 
$shapes->{"L"} = [ 1, 0, 1, 0 ];
#$shapes->{"J"}->{N}=1; $shapes->{"J"}->{S}=0; $shapes->{"J"}->{E}=0; $shapes->{"J"}->{W}=1; 
$shapes->{"J"} = [ 1, 0, 0, 1 ];
#$shapes->{"7"}->{N}=0; $shapes->{"7"}->{S}=1; $shapes->{"7"}->{E}=0; $shapes->{"J"}->{W}=1; 
$shapes->{"7"} = [ 0, 1, 0, 1 ];
#$shapes->{"F"}->{N}=0; $shapes->{"F"}->{S}=1; $shapes->{"F"}->{E}=1; $shapes->{"F"}->{W}=0; 
$shapes->{"F"} = [ 0, 1, 1, 0 ];
#$shapes->{"\."}->{N}=0; $shapes->{"\."}->{S}=0; $shapes->{"\."}->{E}=0; $shapes->{"\."}->{W}=0; 
$shapes->{"\."} = [ 0, 0, 0, 0 ];
#$shapes->{"S"}->{N}=1; $shapes->{"S"}->{S}=1; $shapes->{"S"}->{E}=1; $shapes->{"S"}->{W}=1; 
$shapes->{"S"} = [ 1, 1, 1, 1 ];

my @compass = ( "North", "South", "East", "West" );

# Now read the input

my $map;

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

print "Start is " . join(", ",@start ) . "\n";

my $steps = walk( 0, -1, @start );

print "Loop: $steps\n";

exit 0;

sub walk {
	my ( $steps, $from, $x, $y ) = @_;

	my $found;

	if ( $x < 0 ) {
		print "Hit the west edge of the map\n";
		return 0;
	}
	if ( $x >= $max_x ) {
		print "Hit the east edge of the map\n";
		return 0;
	}
	if ( $y < 0 ) {
		print "Hit the north edge of the map\n";
		return 0;
	}
	if ( $y >= $max_y ) {
		print "Hit the south edge of the map\n";
		return 0;
	}

	if ( $steps > 0 ) {
		print "I've come from the $compass[$from]\n";
	}

	my $s = $map->[$x][$y];

	if ( $s eq "S" and $steps > 0 ) {
		print "I'm back at the beginning at $steps steps!\n";
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
		printf( "I can go East from here to %d, %d\n", $x + 1, $y  );

		if ( $x  + 1 < $max_x ) {
			my $ns = $map->[$x + 1][$y];
			if ( $shapes->{$ns}->[3] ) {
				printf( "A $ns means that I can go East from here to %d, %d\n", $x + 1, $y );
				if ( walk( $steps + 1, 3, $x + 1, $y ) ) {
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
		printf( "I can go West from here to %d, %d\n", $x - 1, $y );

		if ( $x  - 1 >= 0 ) {
			my $ns = $map->[$x - 1][$y];
			if ( $shapes->{$ns}->[2] ) {
				printf( "A $ns means that I can go East from here to %d, %d\n", $x - 1, $y );
				if ( walk( $steps + 1, 2, $x - 1, $y ) ) {
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
