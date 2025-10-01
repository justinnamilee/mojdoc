use strict;
use warnings;
use Test::More;
use Test::Mojo;
use File::Temp qw/tempdir/;
use File::Spec;
use IO::Handle;
use FindBin;

BEGIN { $ENV{MOJO_MODE} = q[testing] }

my $tmp = tempdir(CLEANUP => 1);
my $md  = File::Spec->catfile($tmp, q[hello.md]);
open my $fh, q[>], $md or die $!;
$fh->print(qq[# Hello\n\n**world**\n\n42069\n]); $fh->flush; close $fh;

local $ENV{MOJDOC_WELCOME} = $md;

require qq[$FindBin::Bin/../mojdoc];
my $app = main->can(q[app])->();
my $t   = Test::Mojo->new($app);

$t->get_ok(q[/])->status_is(200, q[status=200])
  ->content_like(qr/\b42069\b/, q[content=ok]);

done_testing;
