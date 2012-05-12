#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
#    $jpp->get_section('package','')->subst_body_if(qr'felix-maven2','maven-plugin-bundle',qr'Requires:');
#    $jpp->get_section('package','')->subst_if('asm','objectweb-asm',qr'Requires:');
#    $jpp->get_section('package','')->unshift_body('BuildRequires: maven-plugin-descriptor'."\n");
#    $jpp->get_section('package','')->unshift_body('BuildRequires: servletapi4'."\n");
#$jpp->get_section('package','')->unshift_body('BuildRequires: mojo-parent'."\n");
#    $jpp->get_section('package','')->unshift_body('Requires: sun-ws-metadata-2.0-api sun-annotation-1.0-api'."\n");
foreach my $sec ($jpp->get_sections()) {
	$sec->map_body(
sub {
	s/\s*[>=].*// if /^Requires:.*0:\%{.*-%{release}/;
}
);
}
}
