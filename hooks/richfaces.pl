#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package')->unshift_body('BuildRequires: mojo-maven2-archetypeng'."\n");
    $jpp->get_section('prep')->subst(qr'/sgml/docbook/xsl-stylesheets','/xml/docbook/xsl-stylesheets');
};
__END__

