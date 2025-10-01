use strict;
use warnings;
use Test::More;
use Test::Mojo;
use Mojo::Log;
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
local $ENV{MOJDOC_LOGIT} = 1;


require qq[$FindBin::Bin/../mojdoc];
my $app = main->can(q[app])->();
my $t   = Test::Mojo->new($app);
my $lb  = undef;

LOG: {
  open my $lf, q[>], \$lb or die $!;
  my $log = Mojo::Log->new(level => q[info], handle => $lf);

  $app->log($log);
}

# setup testable defaults
my $ua   = q[TestUA/1.0];
my $ref  = q[http://example.test/ref];
my $host = q[example.test:1234];
my $qs   = q[foo=bar];

my @hello = (
  q[/view/hello.md?../etc/passwd],
  q[/view/hello.md#../etc/passwd],
  q[/view/hello.md?foo=bar&baz=qux],
  q[/view/././hello.md],
  q[/view///hello.md],
  q[/view/%2fhello.md],
  q[/view/%20hello.md%20],
);

# test fields work as expected (testables)
$t->get_ok(qq[/view/hello.md?$qs],
          {q[User-Agent] => $ua, q[Referer] => $ref, Host => $host})
  ->status_is(200, q[status=200]);

like(
  $lb, qr{
    \[info\] \s+
    \[[^\]]+\] \s+               # req id
    (?:127\.0\.0\.1|::1|\S+) \s+ # "remote ip"
    \Q$md\E \s+                  # full path to the served file
    method=GET \s+
    host=\Q$host\E \s+           # testables
    ua="\Q$ua\E" \s+             # testables
    ref="\Q$ref\E" \s+           # testables
    route=view \s+
    qs="\Q$qs\E"                 # testables
  }x,
  q[log=exists]
);

# test failure
$lb = q[]; # reset buffer

$t->get_ok(q[/view/fake.md],
          {q[User-Agent] => $ua, Host => $host})
  ->status_isnt(200, q[status!=200]);

unlike(
  $lb, qr{
    \Qfake.md\E .*
    \bmethod=GET\b .*
    \broute=view\b
  }x,
  q[log!=exists]
);

# test "safified" / identities produce logs
foreach my $url (@hello) {
  $lb = q[]; # reset buffer

  $t->get_ok($url,
            {q[User-Agent] => $ua, Host => $host})
    ->status_is(200, q[status=200]);

  like(
    $lb, qr{
      \Q$md\E .*
      \bmethod=GET\b .*
      \broute=view\b
    }x,
    q[log=exists]
  )
}

done_testing;
