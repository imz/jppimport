#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->subst(qr'/mvn-jpp ','/mvn-jpp -Dmaven.test.skip=true ');
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven-license-plugin maven-shared-filtering'."\n");
    $jpp->get_section('prep')->push_body(q!sed -i -e s,com.google.code.maven-license-plugin,com.mycila.maven-license-plugin, pom.xml!."\n");
};

__END__
