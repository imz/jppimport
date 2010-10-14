#!/usr/bin/perl -w

require 'set_jboss_ant18.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'antlr-repolib = 0:2.7.6','antlr-repolib >= 0:2.7.6');
    $jpp->get_section('package','')->subst(qr'bcel-repolib = 0:5.1','bcel-repolib >= 0:5.1');
    $jpp->get_section('package','')->subst(qr'bsf-repolib = 0:2.3.0','bsf-repolib >= 0:2.3.0');
    $jpp->get_section('package','')->subst(qr'junit-repolib = 0:3.8.2','junit-repolib = 1:3.8.2');
    $jpp->get_section('package','')->subst(qr'qdox-repolib = 0:1.6.1','qdox-repolib = 1:1.6.1');
    $jpp->get_section('package','')->subst(qr'xerces-j2-repolib = 0:2.7.1','xerces-j2-repolib = 0:2.9.0');
    $jpp->get_section('package','')->subst(qr'jakarta-commons-collections-repolib = 0:3.1','jakarta-commons-collections-repolib >= 0:3.1');
    $jpp->get_section('package','')->subst(qr'xml-security-repolib = 0:1.3.0','xml-security-repolib >= 0:1.3.0');
}
__END__
5.0 fixes

# my hacks
sed -i 's,apache-xmlsec" version="1.3.0-brew,org/apache" version="1.4.3-brew,g' 4.2.3.GA/jboss-4.2.x/build/build-thirdparty.xml
sed -i 's,hsqldb" version="1.8.0.8.patch01-brew,hsqldb" version="1.8.0.10,g' 4.2.3.GA/jboss-4.2.x/build/build-thirdparty.xml
sed -i 's,glassfish/jaf,sun-jaf,g' 4.2.3.GA/jboss-4.2.x/build/build-thirdparty.xml
sed -i 's,glassfish/javamail,sun-javamail,g' 4.2.3.GA/jboss-4.2.x/build/build-thirdparty.xml
sed -i 's,glassfish/jsf" version="1.2_09-brew,sun-jsf" version="1.2_12-brew,g' 4.2.3.GA/jboss-4.2.x/build/build-thirdparty.xml
# and also 4.2.3.GA/jboss-4.2.x/thirdparty/licenses/thirdparty-licenses.xml should be fixed.
# also, repolibs  glassfish/jaf,glassfish/javamail repolibs seems to look broken
