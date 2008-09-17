#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    #$jpp->get_section('package','')->unshift_body('BuildRequires: excalibur excalibur-avalon-framework'."\n");

    #/.out/jettison-repolib-1.0-alt2_0.rc2.1jpp5.noarch.rpm: unpackaged directory: /usr/share/java/repository.jboss.com/codehaus-jettison
    $jpp->get_section('files','repolib')->push_body('%dir %_javadir/repository.jboss.com/codehaus-jettison'."\n");
}
