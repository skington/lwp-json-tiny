#!/usr/bin/env perl
# Tests for HTTP::Response::JSON

use charnames qw(:full);
use strict;
use warnings;
no warnings 'uninitialized';

use Test::Fatal;
use Test::More;

use HTTP::Response::JSON;

my $tested_class = 'HTTP::Response::JSON';

isa();

Test::More::done_testing();

sub isa {
    my $request = $tested_class->new;
    isa_ok($request, 'HTTP::Response', 'This is a subclass of HTTP::Response');
    can_ok($request, 'json_content');
}
