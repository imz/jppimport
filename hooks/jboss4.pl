#!/usr/bin/perl -w

# done
#require 'set_with_coreonly.pl';
require 'set_with_basiconly.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: jakarta-crimson'."\n");
    $jpp->add_patch('jboss-4.0.3SP1-alt-ant17support.patch');
    # dirty hack to finish build; 
    # TODO: either build with wsdl4j-1.4 or
    # backport patches from jboss 4.2
    $jpp->get_section('prep')->push_body('
pushd thirdparty/ibm-wsdl4j/lib
rm wsdl4j.jar
mv wsdl4j.jar.no wsdl4j.jar
popd
');

}
