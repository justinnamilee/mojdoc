use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  VERSION   => '0.1.6',
  PREREQ_PM => {
    'Mojolicious' => '9.41',
    'Text::MultiMarkdown' => '1.005'
  },
  test => {TESTS => 't/*.t'}
);
