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
foreach my $node ( keys %$m ) {
	if ( $node =~ /A$/ ) {
		print "Start at $node\n";
		@nodes = ( @nodes, $node );
	}
}

#@nodes = ( "AAA" );

printf( "There are %d starting nodes\n", scalar(@nodes) );

my $stepcount = 0;

my $allz = 0;

while ( $allz < scalar(@nodes) ) {
	foreach my $step ( @steps ) {
		$stepcount++;

		$allz = 0;
		for ( my $i = 0; $i < scalar(@nodes); $i++ ) {

			$nodes[$i] = $m->{$nodes[$i]}->{$step};

			if ( $nodes[$i] =~ /Z$/ ) {	
				$allz++;
				print "Found $stepcount $i $allz $nodes[$i]\n";
			}
		}
		if ( $allz >= scalar(@nodes)) {
			goto OUT;
		}
		# print "$allz $stepcount\n";
		
	}
}

OUT:


print "Answer: $allz $stepcount\n";

exit 0;
