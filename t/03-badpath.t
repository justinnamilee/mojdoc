use strict;
use warnings;
use Test::More;
use Test::Mojo;
use FindBin;

BEGIN { $ENV{MOJO_MODE} = q[testing] }

require qq[$FindBin::Bin/../mojdoc];
my $app = main->can(q[app])->();
my $t   = Test::Mojo->new($app);

# try to get the app file (view/ is private/dox/)
$t->get_ok(q[/view/../../mojdoc])->status_isnt(200);
done_testing;
