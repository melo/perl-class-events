use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Class::Events',
    license             => 'perl',
    dist_author         => 'Pedro Melo <melo@cpan.org>',
    dist_version_from   => 'lib/Class/Events.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'Class-Events-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
