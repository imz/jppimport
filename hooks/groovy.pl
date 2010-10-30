#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
# %post:
# <13>May  8 02:17:52 rpmi: groovy-0:1.0-alt1_2jpp5 installed
# /usr/bin/rebuild-jar-repository: error: Could not find commons-primitives Java extension for this JVM
# /usr/bin/rebuild-jar-repository: error: Some detected jars were not found for this jvm
#    $jpp->get_section('package','')->unshift_body('Requires: jakarta-commons-primitives'."\n");
# no :( just disable rebuild jar
    $jpp->get_section('post','')->subst(qr'rebuild-jar-repository','#rebuild-jar-repository');

    $jpp->get_section('package','')->unshift_body('%add_findreq_skiplist /usr/share/groovy-1.0/lib/*junit*.jar'."\n");

    # bug ?
    $jpp->get_section('prep')->push_body(q!
%__subst 's,xml-commons-jaxp-1.1-apis.jar,xml-commons-jaxp-1.3-apis.jar,g' %{SOURCE4}
# too long
rm src/test/UberTestCaseLongRunningTests.java
# Out of Memory
rm src/test/UberTestCase2.java
rm src/test/UberTestCase3.java
rm src/test/UberTestCase4.java
rm src/test/UberTestCaseTCK.java
rm -rf src/test/*
!);
    # bug to report
    $jpp->get_section('install')->subst(qr'%{javadir}','%{_javadir}');
};

__END__
    # does not work (due to %build) --- we hacked above. todo: fix in source
    $jpp->get_section('build')->push_body(q!
# bug in Source4: groovy-1.0-jpp-depmap.xml
%__subst 's,xml-commons-jaxp-1.1-apis.jar,xml-commons-jaxp-1.3-apis.jar,g' ./groovy-core/project.xml
%__subst 's,xml-commons-jaxp-1.1-apis.jar,xml-commons-jaxp-1.3-apis.jar,g' ./project.xml
!);
