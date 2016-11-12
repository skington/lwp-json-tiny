package LWP::UserAgent::JSON;

use strict;
use warnings;
no warnings 'uninitialized';

use HTTP::Request::JSON;
use LWP::JSON::Tiny;
use Scalar::Util ();
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

This is a subclass of LWP::UserAgent which recognises if it gets
JSON output back, and if so returns an L<HTTP::Response::JSON> object instead
of a L<HTTP::Response> object. It exposes the logic of reblessing the
HTTP::Response object in case you get handed a HTTP::Response object by
some other method.

It also offers a handful of convenience methods to directly convert
parameters into JSON for POST, PUT and PATCH requests.

=head2 post_json

Like LWP::UserAgent::post, except for when it's called as
C<post_json($url, $form_ref, ...)>, in which case $form_ref is turned into
JSON. Obviously if you specify Content-Type or Content in subsequent header
arguments they'll take precedence.

=cut

sub post_json {
    my $self = shift;
    my $url = shift;

    if (ref($_[0])) {
        my $request = HTTP::Request::JSON->new;
        $request->json_content($_[0]);
        splice(@_, 0, 1,
            Content => $request->content, # Or is it decoded_content?
            'Content-Type' => $request->content_type,
        );
    }
    $self->SUPER::post($url, @_);
}

=head2 simple_request

As LWP::UserAgent::simple_request, but returns a L<HTTP::Response:JSON>
object instead of a L<HTTP::Response> object if the response is JSON.

=cut

sub simple_request {
    my $self = shift;

    my $response = $self->SUPER::simple_request(@_);
    $self->rebless_maybe($response);
    return $response;
}

=head2 rebless_maybe

 In: $response
 Out: $reblessed

Supplied with a HTTP::Response object, looks to see if it's a JSON
object, and if so reblesses it to be a HTTP::Response::JSON object.
Returns whether it reblessed the object or not.

=cut

sub rebless_maybe {
    my ($response) = pop;

    if (   Scalar::Util::blessed($response)
        && $response->isa('HTTP::Response')
        && $response->content_type eq 'application/json')
    {
        bless $response => 'HTTP::Response::JSON';
        return 1;
    }
    return 0;
}

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
