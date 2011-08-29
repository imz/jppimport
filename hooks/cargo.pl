#!/usr/bin/perl -w

require 'set_jetty6_servlet_25_api.pl';
#
push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
# hack: use modello10
#    $jpp->get_section('package','')->exclude(qr'(maven-plugin-modello|modello-maven-plugin)');
#    $jpp->get_section('package','')->subst_if(qr'modello','modello10',qr'Requires:');
# ADD>       -Dmodel=src/main/mdo/mergeinfo.mdo \

    $jpp->get_section('build')->unshift_body('export MAVEN_OPTS="-Xmx256m"'."\n");
}

__END__
