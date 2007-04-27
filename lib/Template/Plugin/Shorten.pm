package Template::Plugin::Shorten;

use strict;
use warnings;

use UNIVERSAL::require;
use Regexp::Common qw(URI);

use base qw(Template::Plugin);

our $VERSION = '0.02';
our $STYLE   = 'TinyURL';

sub new {
    my ($class, $context, @args) = @_;
    $STYLE = $args[0] || $STYLE;

    for my $method (qw(shorten_url lengthen_url)) {
        $context->define_filter($method, filter_factory($method));
    }

    bless {}, $class;
}

sub filter_factory {
    my $method = shift;
    my $sub    = sub {
        my($context, @args) = @_;
        my $style  = $args[0] || $STYLE;
        my $module = 'WWW::Shorten::' . $style;

        $module->use;

        return sub {
            my $text = shift;
            $text =~ s/($RE{URI}{HTTP})/convert_url_for($1, $method)/eg;
            $text;
        };
    };

    return [$sub, 1];
}

sub convert_url_for {
    my ($url, $method) = @_;

    if ($method eq 'shorten_url') {
        return makeashorterlink($url);
    }
    elsif ($method eq 'lengthen_url') {
        return makealongerlink($url);
    }
}

1;

__END__

=head1 NAME

Template::Plugin::Shorten - Template plugin to shorten/lengthen URLs

=head1 SYNOPSIS

  # Load this plugin
  [% USE Shorten %]

  # Shortening URLs
  [% FILTER shorten_url %]
    <a href="http://search.cpan.org/">search.cpan.org</a>
  [% END %]

  # or

  [% text | shorten_url %]

  # Lengthening URLs
  [% FILTER lengthen_url %]
    <a href="http://tinyurl.com/37rwu">search.cpan.org</a>
  [% END %]

  # or

  [% text | lengthen_url %]

=head1 DESCRIPTION

Template::Plugin::Shorten is a Template plugin to shorten or lengthen
URLs using URL shortening sites like TinyURL.com and all that.

=head1 OPTIONS

=over 4

=item * [% USE Shorten         'URLShorteningSite' %]

=item * [% FILTER shorten_url  'URLShorteningSite' %]

=item * [% FILTER lengthen_url 'URLShorteningSite' %]

Each of them can accept a parameter indicates which site you preffer
to shorten/lengthen URLs. It's optional. If it is not passed in,
TinyURL.com will be used automatically to make it.

For more, consult the documentation of L<WWW::Shorten>.

=back

=head1 CAVEAT

To avoid too much frequent accesses to URL shortening sites, don't use
this module in such template as they're generated dynamically and
frequently along with users' requests, typically in Web sites.

=head1 SEE ALSO

=over 4

=item * L<WWW::Shorten>

=back

=head1 AUTHOR

Kentaro Kuribayashi E<lt>kentaro@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE (The MIT License)

Copyright (c) 2007, Kentaro Kuribayashi E<lt>kentaro@cpan.orgE<gt>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

=cut
