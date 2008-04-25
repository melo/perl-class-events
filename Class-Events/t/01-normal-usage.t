#!perl -T

use Test::More tests => 35;
use lib qw(t/lib);

BEGIN {
	use_ok( 'CESimple' );
}

# some event counters
my $count_event_a = 0;
sub count_event_a {
  my ($ctx, $delta) = @_;
  
  $count_event_a += $delta || 1;
}

my $count_event_b = 0;
sub count_event_b {
  my ($ctx, @deltas) = @_;
  
  $count_event_b += $_ for @deltas;
}

# Check initial state
is($count_event_a, 0, 'good initial value for event_a counter');
is($count_event_b, 0, 'good initial value for event_b counter');

# Class interface for notification
CESimple->notify('/event/a');
is($count_event_a, 0, 'no subscribers, no increment for event_a');
is($count_event_b, 0, 'event_a, no increment for event_b');

CESimple->notify('/event/b');
is($count_event_a, 0, 'event_b, no increment for event_a');
is($count_event_b, 0, 'no subscribers, no increment for event_b');


# add a listener
CESimple->subscribe({
   topic => '/event/a',
   cb    => \&count_event_a,
});

# redo the tests
CESimple->notify('/event/a');
is($count_event_a, 1, 'one subscriber, increment event_a counter');
is($count_event_b, 0, 'event_a, no increment for event_b');

CESimple->notify('/event/b');
is($count_event_a, 1, 'event_b, no increment for event_a');
is($count_event_b, 0, 'no subscribers, no increment for event_b');


# add a second listener to the same topic
CESimple->subscribe({
   topic => '/event/a',
   cb    => \&count_event_a,
});

# redo the tests
CESimple->notify('/event/a');
is($count_event_a, 3, '2 subscribers, increment event_a counter twice');
is($count_event_b, 0, 'event_a, no increment for event_b');

CESimple->notify('/event/b');
is($count_event_a, 3, 'event_b, no increment for event_a');
is($count_event_b, 0, 'no subscribers, no increment for event_b');

# redo the tests with specific delta
CESimple->notify('/event/a', 10);
is($count_event_a, 23, '2 subscribers, add 10 to event_a counter per subscriber');
is($count_event_b, 0, 'event_a, no increment for event_b');

CESimple->notify('/event/b');
is($count_event_a, 23, 'event_b, no increment for event_a');
is($count_event_b, 0, 'no subscribers, no increment for event_b');


# add a listener to topic b
CESimple->subscribe({
   topic => '/event/b',
   cb    => \&count_event_b,
});

# redo the tests
CESimple->notify('/event/a');
is($count_event_a, 25, '2 subscribers, increment event_a counter twice');
is($count_event_b, 0, 'event_a, no increment for event_b');

CESimple->notify('/event/b');
is($count_event_a, 25, 'event_b, no increment for event_a');
is($count_event_b, 0, '1 subscriber, but no delta given, no change to event_b counter');

# redo the test for topic b with specific delta
CESimple->notify('/event/b', 1, 2);
is($count_event_a, 25, 'event_b, no increment for event_a');
is($count_event_b, 3, '1 subscriber, sum deltas and add to event_b counter');

CESimple->notify('/event/b', 1..10);
is($count_event_a, 25, 'event_b, no increment for event_a');
is($count_event_b, 58, '1 subscriber, sum deltas and add to event_b counter');


# add a second listener to topic b
CESimple->subscribe({
   topic => '/event/b',
   cb    => \&count_event_b,
});

# redo the tests
CESimple->notify('/event/a');
is($count_event_a, 27, '2 subscribers, increment event_a counter twice');
is($count_event_b, 58, 'event_a, no increment for event_b');

CESimple->notify('/event/b');
is($count_event_a, 27, 'event_b, no increment for event_a');
is($count_event_b, 58, '2 subscribers, but no delta given, no change to event_b counter');

# redo the test for topic b with specific delta
CESimple->notify('/event/b', 1, 2);
is($count_event_a, 27, 'event_b, no increment for event_a');
is($count_event_b, 64, 's subscribers, sum deltas and add to event_b counter twice');

CESimple->notify('/event/b', 1..10);
is($count_event_a, 27, 'event_b, no increment for event_a');
is($count_event_b, 174, '2 subscribers, sum deltas and add to event_b counter twice');
