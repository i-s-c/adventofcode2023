#!/usr/bin/perl

use strict;
use warnings;


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

			print "$node $left $right\n";
			$m->{$node}->{L} = $left;
			$m->{$node}->{R} = $right;
		}
		else {
			print "$line\n" 
		}
	}
}

# Walk through it

# Get starting nodes

my @nodes;
foreach my $node ( keys %$m ) {
	print "$node\n";
	if ( $node =~ /A$/ ) {
		@nodes = ( @nodes, $node );
	}
}

printf( "There are %d starting nodes\n", scalar(@nodes) );

my $stepcount = 0;

my $allz = 1;
foreach my $n ( @nodes ) {
	unless ( $n =~ /Z$/ ) {
		$allz = 0;
	}
}

while ( $allz == 0 ) {
	foreach my $step ( @steps ) {
		$stepcount++;

		$allz = 1;
		for ( my $i = 0; $i < scalar(@nodes); $i++ ) {
			my $node = $nodes[$i];

			$nodes[$i] = $m->{$nodes[$i]}->{$step};

			unless ( $nodes[$i] =~ /Z$/ ) {	
				$allz = 0;
			}
		}
		if ( $allz ) {
			goto OUT;
		}
		
	}
}

OUT:


print "Answer: $stepcount\n";

exit 0;
