#!/usr/bin/perl -w

require 'set_sasl_hook.pl';

$spechook = \&fix_jaf;

# until old jaf will be in Sisyphus
sub fix_jaf {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('Requires(pre): classpathx-jaf'."\n");
    $jpp->get_section('package','')->unshift_body('Conflicts: jaf = 1.0.2-alt2'."\n");
    $jpp->get_section('files','manual')->subst(qr'^%doc docs/*', '%doc --no-dereference docs/*');
}

1;
