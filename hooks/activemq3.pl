#!/usr/bin/perl -w

#require 'set_bootstrap.pl';
require 'set_target_14.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
#    $jpp->get_section('package','')->unshift_body('BuildRequires: geronimo-specs-poms'."\n");
    $jpp->get_section('prep')->unshift_body(q!perl -npe 's,geronimo/spec-(.+)\.jar,geronimo-$1-api.jar,' -i %{SOURCE4}!."\n");
    $jpp->get_section('prep')->push_body(q!# timeout
#rm modules/core/src/test/org/activemq/FragmentPersistentQueueTest.java
#rm modules/core/src/test/org/activemq/Fragment*Test.java
#too long
rm modules/core/src/test/org/activemq/JmsClientAckTest.java
rm modules/core/src/test/org/activemq/JmsConnectionStartStopTest.java

!);
    $jpp->get_section('build')->unshift_body(q!export MAVEN_OPTS="-XX:MaxPermSize=512m -Xmx512M"!."\n");
}
__END__
TODO:
409a415,423
>         -Dgoal=jar:install \
>         multiproject:goal
> 
> maven -e \
>         -Dmaven.repo.remote=file:/usr/share/maven/repository \
>         -Dmaven.home.local=$MAVEN_HOME_LOCAL \
>         -Dmaven.docs.src=$MAVEN_DOCS_SRC \
>         -Dmaven.test.failure.ignore=true \
>         -Dmaven.multiproject.excludes=modules/gbean/project.xml,modules/assembly/project.xml \
412a427
> 
