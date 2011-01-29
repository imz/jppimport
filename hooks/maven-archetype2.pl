#!/usr/bin/perl -w

require 'set_jetty6_servlet_25_api.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst_if(qr'maven-plugin-modello','modello-maven-plugin',qr'BuildRequires:');
    my $id=$jpp->add_source('maven-archetype2-components.xml');
    $jpp->get_section('install')->push_body(q!
# forcefully add missing plexus components.xml
rm -rf META-INF
mkdir -p META-INF/plexus
cp %{SOURCE!.$id.q!} META-INF/plexus/components.xml
jar uf %buildroot%_datadir/maven2/plugins/archetype2-plugin-%version.jar META-INF/plexus
!);
    
}
