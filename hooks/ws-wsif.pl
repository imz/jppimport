#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # hack before jms will be obsolete
    $jpp->get_section('package','')->subst('Requires: jms\s*=\s*0:1.1','Requires: geronimo-jms-1.1-api');
    $jpp->get_section('package','')->unshift_body('BuildRequires: jaf bsf sun-mail'."\n");
    $jpp->get_section('build')->unshift_body2_after('ln -sf $(build-classpath bsf)'."\n",qr'pushd lib');
    $jpp->get_section('build')->unshift_body2_after('ln -sf $(build-classpath jaf)'."\n",qr'pushd lib');
    $jpp->get_section('build')->unshift_body2_after('ln -sf $(build-classpath sun-mail-monolithic)'."\n",qr'pushd lib');

    $jpp->get_section('build')->subst('wsdl4j','wsdl4j-jboss4');

}
