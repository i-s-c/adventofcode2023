#!/usr/bin/perl

use strict;
use warnings;


my $m;

my $step = <STDIN>;
chomp($step);
my @steps = split(//,$step);

while ( my $line = <STDIN> ) {
	if ( $line =~ /=/ ) {
		if ( $line =~ /^([A-Z]..) = \(([A-Z]..), ([A-Z]..)\)$/ ) {
			my $node = $1;
			my $left = $2;
			my $right = $3;

			$m->{$node}->{L} = $left;
			$m->{$node}->{R} = $right;
		}
	}
}

# Walk through it

my $node = "AAA";

my $stepcount = 0;

while ( $node ne "ZZZ" ) {
	foreach my $step ( @steps ) {
		$stepcount++;

		$node = $m->{$node}->{$step};

		if ( $node eq "ZZZ" ) {
			goto OUT;
		}
		
	}
}

OUT:


print "Answer: $stepcount\n";

exit 0;
