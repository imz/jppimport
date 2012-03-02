#!/usr/bin/perl -w

#require 'set_fix_jpp_depmap_for_qdox12.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    #$jpp->get_section('package')->unshift_body('BuildRequires: maven-shared-verifier'."\n");
    $jpp->add_patch('maven-surefire-2.3.1-alt-null-project.patch',STRIP=>1);
    # against
    my $msg='
  Path to dependency: 
        1) dummy:dummy:jar:1.0
        2) org.apache.maven.surefire:surefire-junit:jar:2.4.3

----------
1 required artifact is missing.

for artifact: 
  dummy:dummy:jar:1.0';
    $jpp->main_section()->unshift_body('Requires: maven-surefire-provider-junit'."\n");
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


