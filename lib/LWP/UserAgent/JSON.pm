package LWP::UserAgent::JSON;

use strict;
use warnings;
no warnings 'uninitialized';

use LWP::JSON::Tiny;
use parent 'LWP::UserAgent';

our $VERSION = $LWP::JSON::Tiny::VERSION;

=head1 NAME

LWP::UserAgent::JSON - a subclass of LWP::UserAgent that understands JSON

=head1 SYNOPSIS

 my $user_agent = LWP::UserAgent::JSON->new;
 my $request    = HTTP::Request::JSON->new(...);
 my $response   = $user_agent->request($request);
 # $response->isa('HTTP::Response::JSON') if we got back JSON

=head1 DESCRIPTION

This is a simple subclass of LWP::UserAgent which recognises if it gets
JSON output back, and if so returns an L<HTTP::Response::JSON> object instead
of a HTTP::Response::JSON object.

=head1 AUTHOR

Sam Kington <skington@cpan.org>

The source code for this module is hosted on GitHub
L<https://github.com/skington/lwp-json-tiny> - this is probably the
best place to look for suggestions and feedback.

=head1 COPYRIGHT

Copyright (c) 2015 Sam Kington.

=head1 LICENSE

This library is free software and may be distributed under the same terms as
perl itself.

=cut

1;