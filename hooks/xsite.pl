#!/usr/bin/perl -w

require 'set_excalibur_pom.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: mojo-maven2-plugin-cobertura maven2-plugin-surefire jetty5 nanocontainer freemarker xstream sitemesh picocontainer mojo-maven2-plugin-dependency'."\n");
}

__END__
