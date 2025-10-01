use strict;
use warnings;
use Test::More;
use Test::Mojo;
use FindBin;

BEGIN { $ENV{MOJO_MODE} = q[testing] }

require qq[$FindBin::Bin/../mojdoc];

my $app = main->can(q[app])->();
my $t   = Test::Mojo->new($app);

ok($t, q[load=ok]);

done_testing;
