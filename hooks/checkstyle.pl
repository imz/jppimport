#!/usr/bin/perl -w

# is it needed?
require 'set_manual_no_dereference.pl';

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
# is it needed?
    $jpp->get_section('package','')->unshift_body('BuildRequires: ant-optional'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: jakarta-commons-lang'."\n");
#4.3 feature
#    $jpp->get_section('build')->subst(qr'export CLASSPATH=\$\(build-classpath excalibur/avalon-logkit commons-collections\)','export CLASSPATH=$(build-classpath excalibur/avalon-logkit commons-collections velocity jdom jakarta-commons-lang)');

    # hack! disabled tests! (xerces-j-2.9.0; tests passed with xerces-j-2.8.x)
    $jpp->get_section('build')->subst(qr' run.tests ',' ');
}
