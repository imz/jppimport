#!/usr/bin/perl -w

require 'set_sasl_hook.pl';
require 'set_manual_no_dereference.pl';

#$spechook = \&fix_jaf;

# until old jaf will be in Sisyphus
sub fix_jaf {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('Requires(pre): classpathx-jaf'."\n");
#    $jpp->get_section('files','manual')->subst(qr'^%doc docs/*', '%doc --no-dereference docs/*');
}

1;
