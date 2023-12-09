#!/usr/bin/perl

use strict;
use warnings;

my $sum = 0;
while ( my $line = <STDIN> ) {
	chomp($line);

	while ( $line =~ /  / ) {
		$line =~ s/  / /g;
	}
	print "ORIGINAL: $line\n";

	my @vector = split( / /, $line );

	my $newvalue = $vector[0] - resolve( @vector );

	printf( "[%d], %s\n", $newvalue, join( ", ", @vector ));

	$sum += $newvalue;

}

print "Answer: $sum\n";

exit 0;

sub resolve {
	my ( @vector ) = @_;

	my @newvector;

	my $allzero = 1;

	my $v;
	for ( my $i = 1; $i < scalar(@vector); $i++ ) {
		$v = $vector[$i] - $vector[$i - 1];
		if ( $v ) {
			$allzero = 0;
		}
		@newvector = ( @newvector, $v );
		
	}

	unless ( $allzero ) {
		my $newvalue = $newvector[0] - resolve(@newvector);
		printf( "[%d], %s\n", $newvalue, join( ", ", @newvector ) );
		return $newvalue;
	}
	printf( "[%d], %s\n", 0, join( ", ", @newvector ));
	return 0;
}
