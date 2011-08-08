#!/usr/bin/perl -w

push @SPECHOOKS, \&fix_etc_rhino_conf;

sub fix_etc_rhino_conf {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('httpunit-1.7-alt-jtidy8.patch',STRIP=>1);
    # network is unreachable
    $jpp->get_section('build')->subst(qr'jar javadocs test servlettest testjar examplesjar', 'jar javadocs servlettest testjar examplesjar');
    $jpp->get_section('files','manual')->subst(qr'\%doc ','%doc --no-dereference ');
}

1;
