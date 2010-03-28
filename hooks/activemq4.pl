#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: geronimo-jacc-1.0-api geronimo-jms-1.1-api geronimo-specs javacc3 rome jetty6-servlet-2.5-api'."\n");
    $jpp->get_section('package','')->subst(qr'Requires: smack','Requires: smack1');
    $jpp->get_section('package','xmpp')->subst(qr'Requires: smack','Requires: smack1');

    $jpp->get_section('build')->unshift_body_before(q!
mvn-jpp \
        -e \
        -s $SETTINGS \
        -Dtest=false \
        -Dmaven2.jpp.depmap.file=%{SOURCE2} \
        -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
        install:install-file -DgroupId=javacc -DartifactId=javacc \
        -Dversion=3.2 -Dpackaging=jar -Dfile=$(build-classpath javacc3)

mvn-jpp \
        -e \
        -s $SETTINGS \
        -Dtest=false \
        -Dmaven2.jpp.depmap.file=%{SOURCE2} \
        -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
        install:install-file -DgroupId=rome -DartifactId=rome \
        -Dversion=0.8 -Dpackaging=jar -Dfile=$(build-classpath rome-0.9)
!,qr'mvn-jpp');



}
__END__
diff activemq4-jpp-depmap.xml.old activemq4-jpp-depmap.xml    
453c453
<      <artifactId>smackx</artifactId>
---
>      <artifactId>smackx1</artifactId>
465c465
<      <artifactId>smack</artifactId>
---
>      <artifactId>smack1</artifactId>
