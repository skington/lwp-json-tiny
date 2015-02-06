package LWP::JSON::Tiny;

use strict;
use warnings;
no warnings 'uninitialized';

use LWP;
use JSON::MaybeXS;

our $VERSION = '0.001';
$VERSION = eval $VERSION;

=head1 NAME

LWP::JSON::Tiny - use JSON natively with LWP objects

=head1 SYNOPSIS

 my $user_agent = LWP::UserAgent::JSON->new;
 my $request = HTTP::Request::JSON->new(POST => "$url_prefix/upload_dance");
 $request->add_json_content({ contents => [qw(badger mushroom snake)] });
 my $response = $user_agent->request($request);
 if (my $upload_id = $response->json_content->{upload}{id}) {
     print "Uploaded Weebl rip-off: $upload_id\n";
 }

=head1 DESCRIPTION

A lot of RESTful API integration involves pointless busy work with setting
accept and content-type headers, remembering how Unicode is supposed to work
and so on. This is a very simple wrapper around HTTP::Request and
HTTP::Response that handles all of that for you.

There are three classes in this distribution:

=over

=item HTTP::Request::JSON

A subclass of HTTP::Request. It automatically sets the Accept header to
C<application/json>, and implements an
L<HTTP::Request::JSONE<sol>add_content_jsonE<verbar>add_content_json> method
which takes a JSONable data structure and sets the content-type.

=item HTTP::Response::JSON

A subclass of HTTP::Response. It implements a
L<HTTP::Response::JSONE<sol>json_contentE<verbar>json_content> method which
decodes the JSON contents into a Perl data structure.

=item LWP::UserAgent::JSON

A subclass of LWP::UserAgent. It does only one thing: is a response has
content-type JSON, it reblesses it into a HTTP::Response::JSON object.

=back

=head1 SEE ALSO

L<JSON::API> handles authentication and common URL prefixes, but (a)
doesn't support PATCH routes, and (b) makes you use a wrapper object
rather than LWP directly.

L<WWW::JSON> handles authentication (including favours of OAuth), common URL
prefixes, response data structure transformations, but has the same
limitations as JSON::API, as well as being potentially unwieldy.

L<LWP::Simple::REST> decodes JSON but makes you use a wrapper object, and
looks like a half-hearted attempt that never went anywhere.

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