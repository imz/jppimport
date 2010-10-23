#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
#< export CLASSPATH=`pwd`/ant/target/jsunit-ant-%{version}.jar:`pwd`/jsunit/target/jsunit-%{version}.jar
#---
#> export CLASSPATH=`pwd`/ant/target/jsunit-ant-%{version}.jar:`pwd`/jsunit/target/jsunit-%{version}.jar:$(build-classpath js)
    $jpp->get_section('build')->subst(qr'^export CLASSPATH=','export CLASSPATH=$(build-classpath js):');

};
__END__

