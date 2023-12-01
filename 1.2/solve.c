#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static char *lexicon[18] = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };

int findfirst( const char *s )
{

	const char *p;
	int i;
	int len;

	for ( p = s; *p != '\0'; p++ ) {
		for ( i = 0; i < 18; i++ ) {
			len = strlen( lexicon[i]);

			//printf( "comparing %s with %s of length %d\n", p, lexicon[i], len );
			if ( strncmp( p, lexicon[i], len ) == 0 ) {
				return i < 9 ? i + 1 : i - 8;
			}
		}
	}

	return 0;
}

int findlast( const char *s )
{

	const char *p;
	int i;
	int len;

	int l;

	l = strlen(s);

	if ( l ) {
		for ( p = s + l - 1; *p != '\0'; p-- ) {
			for ( i = 0; i < 18; i++ ) {
				len = strlen( lexicon[i]);

				//printf( "comparing %s with %s of length %d\n", p, lexicon[i], len );
				if ( strncmp( p, lexicon[i], len ) == 0 ) {
					return i < 9 ? i + 1 : i - 8;
				}
			}
		}
	}

	return 0;
}

int main(int argc, char **argv )
{
	int n;
	char *buffer = malloc( 1000 + 1 );
	int first;
	int last;
	int chk;
	int sum = 0;

	while ( fgets( buffer, 1000, stdin ) ) {
		
		n = strlen(buffer);
		if ( n > 0 ) {
			buffer[n - 1] = '\0';
		}
		first = findfirst(buffer);
		last = findlast(buffer);

		chk = first * 10 + last;

		printf( "%s %d\n", buffer, chk );

		sum += chk;

	}

	printf ( "%d\n", sum );

	return 0;
}


