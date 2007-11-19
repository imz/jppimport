#!/usr/bin/perl -w

#require 'set_target_14.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;
#    $jpp->get_section('package','')->unshift_body('BuildRequires: xml-commons-jaxp-1.1-apis'."\n");
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
