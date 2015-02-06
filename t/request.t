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
encode_unicode();

done_testing();

sub isa {
    my $request = $tested_class->new;
    isa_ok($request, 'HTTP::Request', 'This is a subclass of HTTP::Request');
    can_ok($request, 'add_json_content');
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
        exception { $request->add_json_content(\$scalar) },
        'Cannot add arbitrary scalar references as JSON'
    );
    ok(
        exception {
            $request->add_json_content(bless 'foo' => 'Package::Thing')
        },
        'Cannot add blessed objects as JSON'
    );
}

sub encode_valid {
    my $request = $tested_class->new;
    $request->add_json_content({foo => ['foo', 'bar', { baz => 'bletch'}]});
    is(
        $request->decoded_content,
        '{"foo":["foo","bar",{"baz":"bletch"}]}',
        'Simple JSON encoding worked'
    );
}

sub encode_unicode {
    
}
