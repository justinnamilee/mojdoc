use strict;
use warnings;
use Test::More;
use Test::Mojo;
use FindBin;

BEGIN { $ENV{MOJO_MODE} = q[testing] }

local $ENV{MOJDOC_BADGE} = q[testing1234567890];

require qq[$FindBin::Bin/../mojdoc];
my $app = main->can(q[app])->();
my $t   = Test::Mojo->new($app);

$t->get_ok(q[/])->status_is(200, q[status=200])
  ->content_like(qr/testing1234567890/, q[content=ok]);
$t->content_unlike(qr/cyber-docs/, q[content=ok]);

done_testing;
