#!perl -T

use Test::More tests => 9;
use Test::Exception;
use lib qw(t/lib);

use_ok( 'CESimple' );

throws_ok { CESimple->notify } qr/Class::Events::notify\(\): \[FATAL\] missing required first parameter \(topic\)/;

throws_ok { CESimple->subscribe } qr/Class::Events::subscribe\(\): \[FATAL\] missing required parameter 'topic'/;
throws_ok { CESimple->subscribe({}) } qr/Class::Events::subscribe\(\): \[FATAL\] missing required parameter 'topic'/;
throws_ok { CESimple->subscribe({ topic => 'a' }) } qr/Class::Events::subscribe\(\): \[FATAL\] missing required parameter 'cb'/;
throws_ok { CESimple->subscribe({ cb => sub {} }) } qr/Class::Events::subscribe\(\): \[FATAL\] missing required parameter 'topic'/;

throws_ok { CESimple->subscribe({ topic => undef, cb => sub {} }) } qr/Class::Events::subscribe\(\): \[FATAL\] 'topic' parameter is undefined/;

throws_ok { CESimple->subscribe({ topic => 'a', cb => undef }) } qr/Class::Events::subscribe\(\): \[FATAL\] 'cb' parameter must be a coderef,/;
throws_ok { CESimple->subscribe({ topic => 'a', cb => 'a' })   } qr/Class::Events::subscribe\(\): \[FATAL\] 'cb' parameter must be a coderef,/;

