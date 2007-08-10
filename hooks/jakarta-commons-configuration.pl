#!/usr/bin/perl -w

require 'set_without_maven.pl'; # maven1

push @SPECHOOKS, 

sub  {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->subst(qr'export JAVA_HOME=/etc/alternatives/java_sdk_1.4.2','');
    # bug to report
    $jpp->get_section('build')->subst(qr'build-classpath servletapi4','build-classpath commons-collections commons-beanutils servletapi4');
#-Xmx256m
    $jpp->get_section('build')->unshift_body('
#export JAVA_OPTS=" -Djava.awt.headless=true -Ddisconnected=true"
#export ANT_OPTS=" -Djava.awt.headless=true -Ddisconnected=true"

# org.apache.commons.configuration.web.TestAppletConfiguration
rm -f src/test/org/apache/commons/configuration/web/TestAppletConfiguration.java
');
}

