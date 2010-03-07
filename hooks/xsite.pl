#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
}
__END__

require 'set_excalibur_pom.pl';
require 'set_xpp3_min_pom.pl';
require 'set_target_14.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: mojo-maven2-plugin-cobertura maven2-plugin-surefire jetty5 nanocontainer freemarker xstream sitemesh picocontainer maven2-plugin-dependency maven2-plugin-surefire-report'."\n");
    $jpp->get_section('prep')->push_body('
# maven 2.0.7
subst s,org.codehaus.mojo,org.apache.maven.plugins, xsite-distribution/pom.xml
subst s,dependency-maven-plugin,maven-dependency-plugin, xsite-distribution/pom.xml
');


}

__END__
       <groupId>org.codehaus.mojo</groupId>
        <artifactId>dependency-maven-plugin</artifactId>
 
       <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-dependency-plugin</artifactId>
