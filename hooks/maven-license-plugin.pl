#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven2-plugin-eclipse maven2-plugin-idea maven-shared-filtering'."\n");
    $jpp->get_section('build')->subst(qr'mvn-jpp -e','mvn-jpp -e -Dmaven.javadoc.additionalparam=-J-Xmx512m');
};

__END__
