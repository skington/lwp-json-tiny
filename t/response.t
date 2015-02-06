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
pass_through();

Test::More::done_testing();

sub isa {
    my $request = $tested_class->new;
    isa_ok($request, 'HTTP::Response', 'This is a subclass of HTTP::Response');
    can_ok($request, 'json_content');
}

sub pass_through {
    my $response = $tested_class->new;
    $response->content_type('text/html');
    my $html
        = '<html><head><title>Meh</title></head>'
        . '<body><p>Meh</p></body></html>';
    $response->content($html);
    is($response->decoded_content,
        $html, 'Decoded content via standard LWP is what we expect');
    is($response->json_content, undef, q{Don't even try to decode it});
}
