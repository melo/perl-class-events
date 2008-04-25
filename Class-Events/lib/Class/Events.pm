package Class::Events;

use warnings;
use strict;
use Carp::Clan qw( Class::Events );


our $VERSION = '0.01';

##########################
# The subscribers database

our %subscribers;


##############
# The main API

sub subscribe {
  my ($class, $args) = @_;
  
  my ($topic, $cb) = _req_param($args, qw( topic cb ));
  croak("[FATAL] 'topic' parameter is undefined, ") unless defined $topic;
  croak("[FATAL] 'cb' parameter must be a coderef, ") unless ref($cb) eq 'CODE';

  my $subs = $subscribers{$topic} ||= [];
  push @$subs, $cb;
  
  return;
}


sub notify {
  my $class = shift;
  my $topic = shift;

  croak("[FATAL] missing required first parameter (topic), ")
    unless defined($topic);
  
  return unless exists $subscribers{$topic};
  
  foreach my $cb (@{$subscribers{$topic}}) {
    # First parameter will be a context object eventually
    # reserve the slot for now
    $cb->(undef, @_);
  }
  
  return;
}


#######
# Utils

sub _req_param {
  my $args = shift;
  my @rets;
  
  foreach my $arg (@_) {
    croak("[FATAL] missing required parameter '$arg', ")
      unless exists $args->{$arg};
    push @rets, $args->{$arg};
  }
  
  return @rets;
}


1; # End of Class::Events



__END__

=head1 NAME

Class::Events - The great new Class::Events!

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Class::Events;

    my $foo = Class::Events->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 function1

=head2 function2

=head1 AUTHOR

Pedro Melo, C<< <melo at simplicidade.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-class-events at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Class-Events>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Class::Events


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Class-Events>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Class-Events>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Class-Events>

=item * Search CPAN

L<http://search.cpan.org/dist/Class-Events>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2008 Pedro Melo, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


