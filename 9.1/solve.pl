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

	my $newvalue = $vector[scalar(@vector-1)] + resolve( @vector );

	printf( "%s, [%d]\n", join( ", ", @vector ), $newvalue );

	$sum += $newvalue;

}

print "Answer: $sum\n";

exit 0;

sub resolve {
	my ( @vector ) = @_;

	my @newvector;

	my $vsum;

	my $v;
	for ( my $i = 1; $i < scalar(@vector); $i++ ) {
		$v = $vector[$i] - $vector[$i - 1];
		$vsum += $v;
		@newvector = ( @newvector, $v );
		
	}

	if ( $vsum ) {
		my $newvalue = $v + resolve(@newvector);
		printf( "%s, [%d]\n", join( ", ", @newvector ), $newvalue );
		return $newvalue;
	}
	printf( "%s, [%d]\n", join( ", ", @newvector ), 0 );
	return 0;
}
