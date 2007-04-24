use Test::Base;
use Template;
use Template::Plugin::Shorten;

plan tests => 1 * blocks;
filters qw(trim);

run {
    my $block = shift;
    my $tt = Template->new;
    $tt->process(\$block->input, {}, \my $out)
        or do { fail $tt->error; next };
    is $out, $block->expected;
};

__END__
===
--- input
[% USE Shorten -%]
[% FILTER shorten_url -%]
<a href="http://www.perl.org/">Perl.org</a> and <a href="http://search.cpan.org/">search.cpan.org</a>
[% END -%]
--- expected
<a href="http://tinyurl.com/e64h">Perl.org</a> and <a href="http://tinyurl.com/37rwu">search.cpan.org</a>
===
--- input
[% USE Shorten -%]
[% '<a href="http://www.perl.org/">Perl.org</a> and <a href="http://search.cpan.org/">search.cpan.org</a>' | shorten_url %]
--- expected
<a href="http://tinyurl.com/e64h">Perl.org</a> and <a href="http://tinyurl.com/37rwu">search.cpan.org</a>
===
--- input
[% USE Shorten -%]
[% FILTER lengthen_url -%]
<a href="http://tinyurl.com/e64h">Perl.org</a> and <a href="http://tinyurl.com/37rwu">search.cpan.org</a>
[% END -%]
--- expected
<a href="http://www.perl.org/">Perl.org</a> and <a href="http://search.cpan.org/">search.cpan.org</a>
===
--- input
[% USE Shorten -%]
[% '<a href="http://tinyurl.com/e64h">Perl.org</a> and <a href="http://tinyurl.com/37rwu">search.cpan.org</a>' | lengthen_url %]
--- expected
<a href="http://www.perl.org/">Perl.org</a> and <a href="http://search.cpan.org/">search.cpan.org</a>
