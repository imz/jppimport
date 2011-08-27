#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->unshift_body_before(qr'^maven', q!
mkdir -p .maven/repository/JPP/plugins/
ln -s /usr/share/java/maven-plugins/maven-multiproject-plugin.jar .maven/repository/JPP/plugins/
ln -s /usr/share/java/maven-plugins/maven-artifact-plugin.jar .maven/repository/JPP/plugins/
!);
}
