#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven-shared-plugin-tools-api  maven-shared-plugin-tools-beanshell maven-shared-plugin-tools-java maven-shared-plugin-testing-harness maven2-plugin-site'."\n");

#< export CLASSPATH=`pwd`/ant/target/jsunit-ant-%{version}.jar:`pwd`/jsunit/target/jsunit-%{version}.jar
#---
#> export CLASSPATH=`pwd`/ant/target/jsunit-ant-%{version}.jar:`pwd`/jsunit/target/jsunit-%{version}.jar:$(build-classpath js)
    $jpp->get_section('build')->subst(qr'^export CLASSPATH=','export CLASSPATH=$(build-classpath js):');

};
__END__

