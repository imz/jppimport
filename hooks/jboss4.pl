#!/usr/bin/perl -w

# done
#require 'set_with_cor eonly.pl';
#require 'set_with_basiconly.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    #if require 'set_with_basiconly.pl';=> then we need to add 
    #$jpp->get_section('package','')->unshift_body('BuildRequires: spring jakarta-commons-discovery myfaces-core11-impl javassist'."\n");

    $jpp->get_section('package','')->unshift_body('BuildRequires: jakarta-crimson'."\n");
    $jpp->add_patch('jboss-4.0.3SP1-alt-ant17support.patch');

    # otherwise Depends: /lib/lsb/init-functions but it is not installable
    $jpp->copy_to_sources('jboss4.init');

    # could be managed as a common hook
    # require wsdl4j 1.5
#    for my $sec ('prep', 'build', 'install') {
#	$jpp->get_section($sec)->subst(qr'build-classpath wsdl4j', 'build-classpath wsdl4j-jboss4');
#    }
    $jpp->get_section('package','')->subst_if(qr'classpathx-mail-monolithic', 'classpathx-mail', qr'Requires:');

    # this hack is due to the bug in blackdown
    # we build with 5.0 but pretend to build with 1.4 (as there are errors)
    $jpp->add_patch('jboss4-4.0.3.1-alt-force-jdk14-only.patch');

    # out of memory errors
    $jpp->get_section('build')->subst(qr'-Xmx128','-Xmx512');
    $jpp->get_section('build')->subst(qr'-Xmx256','-Xmx512');

    # writable files in /usr: not good, rather bug to report
    #$jpp->disable_package('-n jboss4-testsuite');
    # temporary hack
    $jpp->get_section('files','-n jboss4-testsuite')->subst(qr'775,jboss4','755,jboss4');
}

__END__
    # dirty hack to finish build; (4.0.3.x only?)
    # TODO: either build with wsdl4j-1.4 or
    # backport patches from jboss 4.2
    $jpp->get_section('prep')->push_body('
pushd thirdparty/ibm-wsdl4j/lib
rm wsdl4j.jar
mv wsdl4j.jar.no wsdl4j.jar
popd
');

################### deprecated ############################
    # TODO: report
    # hack:user and group are created in main package: dependency shoud be fixed
#warning: user jboss4 does not exist - using root
#warning: group jboss4 does not exist - using root
#jboss4-default-4.0.3.1-alt2_5jpp5.0
#jboss4-4.0.3.1-alt2_5jpp5.0
    
    #$jpp->get_section('package','-n jboss4-default')->subst(qr'Requires: jboss4 =','Requires(pre): jboss4 =');
#############################################################
