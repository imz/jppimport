#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('Obsoletes: wagon = 1.0-alt0.3.alpha5'."\n");
    $jpp->get_section('package','')->subst_if(qr'surefire-plugin = 2.3', 'surefire-plugin', qr'Requires:');
    $jpp->get_section('package','')->subst_if(qr'surefire-provider-junit = 2.3', 'surefire-provider-junit', qr'Requires:');
};

__END__
# jpp 5

#require 'set_without_maven2.pl'
push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: avalon-framework'."\n");
    # fixes in case set_without_maven2
    # disables ant tests
    $jpp->get_section('prep')->unshift_body(q[find . -name build.xml -exec subst 's!depends="compile,test"!depends="compile"!' {} \;]."\n");
};

