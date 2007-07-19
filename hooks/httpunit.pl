#!/usr/bin/perl -w

$spechook = \&fix_etc_rhino_conf;

sub fix_etc_rhino_conf {
    my ($jpp, $alt) = @_;
    # network is unreachable
    $jpp->get_section('build')->subst(qr'jar javadocs test servlettest testjar examplesjar', 'jar javadocs servlettest testjar examplesjar');
    $jpp->get_section('files','manual')->subst(qr'\%doc ','%doc --no-dereference ');
}

1;
