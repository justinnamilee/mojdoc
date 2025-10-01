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

local $ENV{MOJDOC_DOX} = $tmp;

require qq[$FindBin::Bin/../mojdoc];
my $app = main->can(q[app])->();
my $t   = Test::Mojo->new($app);

my @bad = (
  # --- non-existent ---
  q[/hello.md],
  q[/view/fake.md],

  # --- traversal trying to escape tmp ---
  q[/view/../hello.md],                   # simple up-level
  q[/view/../../hello.md],                # double up-level
  q[/view/subdir/../../hello.md],         # through fake subdir
  q[/view/..%2fhello.md],                 # encoded slash
  q[/view/..%2f..%2fhello.md],
  q[/view/%2e%2e/hello.md],
  q[/view/%2e%2e%2f%2e%2e%2fhello.md],
  q[/view/..%252fhello.md],               # double encoded
  q[/view/..%5chello.md],                 # backslash encoded
  q[/view/..\\hello.md],                  # windows slash
  q[/view/..%00/hello.md],                # null byte attempt
  q[/view/hello.md%00.png],               # extension confusion
  q[/view/hello.md%0a.png],               # newline injection
  q[/view/../../../../../../etc/passwd],  # classic traversal to system file

  # --- alternate schemes ---
  q[/view/file:///etc/passwd],
  q[/view/C:/Windows/System32/drivers/etc/hosts],
  q[/../mojdoc],
  q[//../mojdoc],
  q[/../../mojdoc],
  q[/../../etc/passwd],
  q[///etc/passwd],
);

my @good = (
  # --- expected fall-throughs to public folder ---
  q[/welcome.md],
  q[/view//..///welcome.md],
  q[/view/subdir/../../welcome.md],

  # --- da root, yo ---
  q[/],
);

my @hello = (
  # --- "a real one" ---
  q[/view/hello.md],

  # --- "safified" real paths ---
  q[/view/%2fhello.md],            # absolute inside param
  q[/view/%20hello.md%20],         # space appended is trimmed
  q[/view//hello.md],              # strip extra '/'
  q[/view/./hello.md],             # dot segment should normalize inside root
  q[/view/././././hello.md],       # redundant dot segments
  q[/view/hello.md?foo=bar],       # query string should be ignored
  q[/view/hello.md#anchor],        # fragment should be ignored
  q[/view/hello.md#../etc/passwd], # should return the hello file only
  q[/view/hello.md?../etc/passwd], # should return the hello file only
  q[/view/hello.md#/etc/passwd],   # should return the hello file only
  q[/view/hello.md?/etc/passwd],   # should return the hello file only
);

$t->get_ok($_)->status_isnt(200, qq["$_": status!=200]) foreach @bad;
$t->get_ok($_)->status_is(200, qq["$_": status=200]) foreach @good;
$t->get_ok($_)->status_is(200, qq["$_": status=200])
  ->content_like(qr/\b42069\b/, qq["$_": content=ok]) foreach @hello;

done_testing;
