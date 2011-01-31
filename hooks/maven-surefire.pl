#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package')->unshift_body('BuildRequires: maven-shared-verifier'."\n");
    $jpp->add_patch('maven-surefire-2.3.1-alt-null-project.patch');
}

__END__
# TODO diff
> Provides: maven-surefire = 2.3
139a142
> Provides:               maven-surefire-plugin = 2.3
157a161
> Provides:               maven-surefire-report-plugin = 2.3
174a179
> Provides:               maven-surefire-provider-junit = 2.3
> Provides:               maven-surefire-junit = 2.3
276a282,283
>       mvn-jpp  -e -s settings.xml install:install-file -DgroupId=org.testng -DartifactId=testng -Dversion=5.7 -Dclassifier=jdk15 -Dpackaging=jar -Dfile=/usr/share/java/testng-jdk15.jar



# jpp 5.0
require 'set_without_maven.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
#    $jpp->get_section('package')->subst(qr'^Requires: maven2-bootstrap','#Requires: maven2');
    $jpp->get_section('package')->unshift_body('BuildRequires: plexus-archiver'."\n");
    $jpp->add_patch('maven-surefire-2.3.1-alt-null-project.patch');

}
