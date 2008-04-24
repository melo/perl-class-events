#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Class::Events' );
}

diag( "Testing Class::Events $Class::Events::VERSION, Perl $], $^X" );
