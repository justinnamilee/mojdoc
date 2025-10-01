use strict;
use warnings;
use Test::More;
use Test::Mojo;
use FindBin;

BEGIN { $ENV{MOJO_MODE} = q[testing] }

require qq[$FindBin::Bin/../mojdoc];
my $app = main->can(q[app])->();
my $t   = Test::Mojo->new($app);

$t->get_ok(q[/])->status_is(200, q[status=200])
  ->content_like(qr/cyber-docs/, q[content=ok]);

done_testing;
