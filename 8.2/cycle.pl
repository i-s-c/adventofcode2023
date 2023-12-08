#!/usr/bin/perl

use strict;
use warnings;

$| = 1;

my $m;

my $step = <STDIN>;
chomp($step);
my @steps = split(//,$step);

while ( my $line = <STDIN> ) {
	chomp($line);
	if ( $line =~ /=/ ) {
		if ( $line =~ /^([0-9A-Z]..) = \(([0-9A-Z]..), ([0-9A-Z]..)\)$/ ) {
			my $node = $1;
			my $left = $2;
			my $right = $3;

			$m->{$node}->{L} = $left;
			$m->{$node}->{R} = $right;
		}
	}
}

# Walk through it

# Get starting nodes

my @nodes;
foreach my $node ( sort keys %$m ) {
	if ( $node =~ /A$/ ) {
		print "Start at $node\n";
		@nodes = ( @nodes, $node );
	}
}

#@nodes = ( "AAA" );

#shift @nodes;
my $nodenum = scalar(@nodes);
#$nodenum = 3;
printf( "There are %d starting nodes\n", $nodenum );



my $sum = 0;

for ( my $i = 0; $i < $nodenum; $i++ ) {
	my $stepcount = 0;
	my $finished = 0;
	my $cyclecount = 0;
	while ( $finished == 0 ) {
		$cyclecount++;
		foreach my $step ( @steps ) {
			$stepcount++;

			$nodes[$i] = $m->{$nodes[$i]}->{$step};

			if ( $nodes[$i] =~ /Z$/ ) {	
				$finished = 1;
				goto OUT;
			}
		
		}
	}
OUT:
	print "$i $stepcount $cyclecount\n";
	
	if ( $sum == 0 ) {
		$sum = $stepcount;
	}
	else {
		$sum = $sum * $cyclecount;
	}
}


printf( "Answer: %ld\n", $sum);

exit 0;
