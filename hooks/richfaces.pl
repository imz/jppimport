#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;

    $jpp->get_section('package','')->unshift_body('BuildRequires: modello-maven-plugin'."\n");

    $jpp->get_section('prep')->subst(qr'/sgml/docbook/xsl-stylesheets','/xml/docbook/xsl-stylesheets');
#    $jpp->get_section('build')->subst(qr'/sgml/docbook/xsl-stylesheets','/xml/docbook/xsl-stylesheets');
#    $jpp->get_section('install')->subst(qr'/sgml/docbook/xsl-stylesheets','/xml/docbook/xsl-stylesheets');
};
