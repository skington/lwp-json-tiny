#!/usr/bin/env perl
# Tests for HTTP::Request::JSON

use charnames qw(:full);
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
encode_unicode();

Test::More::done_testing();

sub isa {
    my $request = $tested_class->new;
    isa_ok($request, 'HTTP::Request', 'This is a subclass of HTTP::Request');
    can_ok($request, 'json_content');
}

sub accept_header {
    my $request = $tested_class->new;
    is($request->headers->header('Accept'),
        'application/json', 'The Accept header is automatically set');
}

sub encode_invalid {
    my $request = $tested_class->new;
    my $scalar = 42;
    ok(
        exception { $request->json_content(\$scalar) },
        'Cannot add arbitrary scalar references as JSON'
    );
    ok(
        exception {
            $request->json_content(bless 'foo' => 'Package::Thing')
        },
        'Cannot add blessed objects as JSON'
    );
}

sub encode_valid {
    my $request = $tested_class->new;
    is($request->content_type, '', 'No content type at first');
    $request->json_content({foo => ['foo', 'bar', { baz => 'bletch'}]});
    is(
        $request->decoded_content,
        '{"foo":["foo","bar",{"baz":"bletch"}]}',
        'Simple JSON encoding worked'
    );
    is($request->content_type, 'application/json',
        'We have a content-type now');
}

sub encode_unicode {
    # OK, time to try the most famous Unicode character of all,
    # PILE OF POO.
    # Unicode: U+1F4A9 (U+D83D U+DCA9), UTF-8: F0 9F 92 A9
    my $request = $tested_class->new;
    $request->json_content("\N{PILE OF POO}");
    is(length($request->content),
        6, '6 bytes in the raw content: 4 bytes of poo plus quotes');
    is_deeply(
        [map { ord($_) } split(//, $request->content)],
        [ord('"'), 0xF0, 0x9F, 0x92, 0xA9, ord('"')],
        'Bytes look fine'
    );
}
