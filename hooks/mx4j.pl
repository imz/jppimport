#!/usr/bin/perl -w

#require 'set_bootstrap.pl';
# too long :(
require 'set_without_tests.pl';

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->get_section('package','')->unshift_body('BuildRequires: docbook-dtds'."\n");
    $spec->get_section('package','')->subst_body(qr'javamail\s+>=\s+0:1.2-5jpp','javamail');
}

__END__
# no network; hm... maybe altspecific...
#$spec->add_patch('mx4j-3.0.1-alt-local-xsl-stylesheets.patch', STRIP=>1);
