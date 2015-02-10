#!/usr/bin/env perl
# Tests for LWP::UserAgent::JSON

use strict;
use warnings;
no warnings 'uninitialized';

use FindBin;
use Test::More;

use LWP::UserAgent::JSON;

my $tested_class = 'LWP::UserAgent::JSON';

isa();
guess_content_type();

Test::More::done_testing();

sub isa {
    my $user_agent = $tested_class->new;
    isa_ok($user_agent, 'LWP::UserAgent',
        'This is a subclass of LWP::UserAgent');
}

sub guess_content_type {
    my $user_agent = $tested_class->new;
    my $dir_fixtures = $FindBin::Bin . '/fixtures';

    # Text file: not messed with.
    my $request_text
        = HTTP::Request->new(GET => "file://$dir_fixtures/test.txt");
    my $response_text = $user_agent->request($request_text);
    is($response_text->content_type,
        'text/plain', 'Text file recognised as text');
    like(
        $response_text->decoded_content,
        qr/The quick brown fox/,
        'Text file contains what we expect'
    );
    is(ref($response_text), 'HTTP::Response',
        'Normal HTTP::Response for text file');
    ok(
        !$tested_class->rebless_maybe($response_text),
        'Will not rebless a non-JSON response'
    );
    is(ref($response_text), 'HTTP::Response',
        'Still have a normal HTTP::Response for text file');

    # JSON: reblessed and decoded.
    my $request_json
        = HTTP::Request->new(GET => "file://$dir_fixtures/test.json");
    my $response_json = $user_agent->request($request_json);
    is($response_json->content_type,
        'application/json', 'JSON file recognised as JSON');
    like($response_json->decoded_content,
        qr/Shave yaks/, 'JSON file contains what we expect');
    is(ref($response_json), 'HTTP::Response::JSON',
        'Got a HTTP::Response::JSON object for JSON response');
    bless $response_json => 'HTTP::Response';
    ok($tested_class->rebless_maybe($response_json),
        'Will rebless this JSON response');
    is(ref($response_json), 'HTTP::Response::JSON',
        'Got a HTTP::Response::JSON objectagain for JSON response');
}

