#!/usr/bin/perl -w

push @SPECHOOKS, 

sub  {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body(q!BuildRequires: sf-cobertura-maven-plugin!."\n");
    $jpp->get_section('build')->unshift_body_before(q!
mkdir -p .maven/repository/JPP/plugins/
ln -s \
/usr/share/java/maven-plugins/maven-cobertura-plugin.jar \
.maven/repository/JPP/plugins/
!, qr'^maven');
};

