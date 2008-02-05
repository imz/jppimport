#!/usr/bin/perl -w

push @SPECHOOKS, 

sub  {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst_if(qr'maven-plugin-javadoc', 'sf-maven-plugins-javadoc', qr'BuildRequires:');
    $jpp->get_section('package','')->subst_if(qr'maven-plugin-junit-report', 'maven-plugins-base', qr'BuildRequires:');
    # commons-email specific
    # TODO: report
    # pom misses cactus -> cargo dependency :(

    # note: I built it w/o maven

    $jpp->get_section('package','')->unshift_body('BuildRequires: cargo'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: sf-findbugs-maven-plugin'."\n");
    $jpp->get_section('build')->unshift_body(q!
mkdir -p .maven/repository/JPP/plugins/
ln -s /usr/share/java/maven-plugins/maven-findbugs-plugin.jar .maven/repository/JPP/plugins/
!);
}
