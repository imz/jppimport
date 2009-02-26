#!/usr/bin/perl -w

require 'set_excalibur_pom.pl';
require 'set_xpp3_min_pom.pl';
require 'set_target_14.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: mojo-maven2-plugin-cobertura maven2-plugin-surefire jetty5 nanocontainer freemarker xstream sitemesh picocontainer maven2-plugin-dependency maven2-plugin-surefire-report'."\n");
}

__END__
