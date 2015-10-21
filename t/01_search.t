use strict;
use Test::More 0.98;

use_ok $_ for qw(
    Bower
);

my $bower = Bower->new;

$bower->search('angular-mocks');

done_testing;

