#!/usr/bin/env perl

use strict;
use warnings;
no warnings 'uninitialized';

use Test::Fatal;
use Test::More;

use HTTP::Request::JSON;

my $tested_class = 'HTTP::Request::JSON';

isa();
accept_header();
encode_invalid();
encode_valid();

done_testing();

sub isa {
    my $request = $tested_class->new;
    isa_ok($request, 'HTTP::Request', 'This is a subclass of HTTP::Request');
}

sub accept_header {
    my $request = $tested_class->new;
    is($request->headers->header('Accept'),
        'application/json', 'The Accept header is automatically set');
}

sub encode_invalid {}

sub encode_valid {}
