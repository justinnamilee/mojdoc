use strict;
use warnings;
use Test::More;
use Test::Mojo;
use File::Temp qw/tempdir/;
use File::Spec;
use FindBin;

BEGIN { $ENV{MOJO_MODE} = q[testing] }

my $tmp = tempdir(CLEANUP => 1);
my $md  = File::Spec->catfile($tmp, q[hello.md]);
# file doesn't exist at this point

local $ENV{MOJDOC_WELCOME} = qq[$md];

require qq[$FindBin::Bin/../mojdoc];
my $app = main->can(q[app])->();
my $t   = Test::Mojo->new($app);

$t->get_ok(q[/])->status_is(200, q[status=200])
  ->content_like(qr/\QI couldn't find a "welcome" file, see the logs.\E/, q[content=ok]);

done_testing;
