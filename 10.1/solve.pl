#!/usr/bin/perl

use strict;
use warnings;

# Let's describe the various shapes

my $shapes;

$shapes->{"\|"}->{N}=1; $shapes->{"\|"}->{S}=1; $shapes->{"\|"}->{E}=0; $shapes->{"\|"}->{W}=0; 
$shapes->{"\-"}->{N}=0; $shapes->{"\-"}->{S}=0; $shapes->{"\-"}->{E}=1; $shapes->{"\-"}->{W}=1; 
$shapes->{"L"}->{N}=1; $shapes->{"L"}->{S}=0; $shapes->{"L"}->{E}=1; $shapes->{"L"}->{W}=0; 
$shapes->{"J"}->{N}=1; $shapes->{"J"}->{S}=0; $shapes->{"J"}->{E}=0; $shapes->{"J"}->{W}=1; 
$shapes->{"7"}->{N}=0; $shapes->{"7"}->{S}=1; $shapes->{"7"}->{E}=0; $shapes->{"J"}->{W}=1; 
$shapes->{"F"}->{N}=0; $shapes->{"F"}->{S}=1; $shapes->{"F"}->{E}=1; $shapes->{"F"}->{W}=0; 
$shapes->{"\."}->{N}=0; $shapes->{"\."}->{S}=0; $shapes->{"\."}->{E}=0; $shapes->{"\."}->{W}=0; 
$shapes->{"S"}->{N}=1; $shapes->{"S"}->{S}=1; $shapes->{"S"}->{E}=1; $shapes->{"S"}->{W}=1; 

# Now read the input

my $map;

my $i = 0;
my $j = 0;
my @pos;
my @start;

while ( my $line = <STDIN> ) {
	chomp($line);
	$j = 0;

	foreach my $shape ( split(//,$line) ) {
		$map->[$i][$j] = $shape;

		if ( $shape eq "S" ) {
			@start = ( $i, $j );
		}
		$j++;
	}

	$i++;
}

my $max_x = $i;
my $max_y = $j;
print "Size is $max_x, $max_y\n";

print "Start is " . join(", ",@start ) . "\n";


my $steps = walk( 0, @start );

print "Loop: $steps\n";

exit 0;

sub walk {
	my ( $steps, $x, $y ) = @_;

	print "I'm at position $x, $y. I've taken $steps steps to get here.  The current shape is " . $map->[$x][$y] . "\n";

	
	return $steps;
}
