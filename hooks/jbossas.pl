#!/usr/bin/perl -w

require 'set_jboss_ant18.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'antlr-repolib = 0:2.7.6','antlr-repolib >= 0:2.7.6');
    $jpp->get_section('package','')->subst(qr'bcel-repolib = 0:5.1','bcel-repolib >= 0:5.1');
    $jpp->get_section('package','')->subst(qr'bsf-repolib = 0:2.3.0','bsf-repolib >= 0:2.3.0');
    $jpp->get_section('package','')->subst(qr'junit-repolib = 0:3.8.2','junit-repolib = 1:3.8.2');
    $jpp->get_section('package','')->subst(qr'qdox-repolib = 0:1.6.1','qdox-repolib >= 1:1.6.1');
    $jpp->get_section('package','')->subst(qr'xerces-j2-repolib = 0:2.7.1','xerces-j2-repolib = 0:2.9.0');
    $jpp->get_section('package','')->subst(qr'jakarta-commons-collections-repolib = 0:3.1','jakarta-commons-collections-repolib >= 0:3.1');
    $jpp->get_section('package','')->subst(qr'jakarta-commons-digester-repolib = 0:1.7','jakarta-commons-digester-repolib >= 0:1.7');
    $jpp->get_section('package','')->subst(qr'xml-security-repolib = 0:1.3.0','xml-security-repolib >= 0:1.3.0');
    $jpp->get_section('package','')->subst(qr'wstx-repolib = 0:3.1.1','wstx-repolib >= 0:3.1.1');
    $jpp->get_section('package','')->subst(qr'cglib-repolib = 0:2.1.3','cglib-repolib >= 0:2.1.3');

    # jbossas 4.2
    $jpp->copy_to_sources('jbossas.init');

    $jpp->get_section('files','')->subst(qr'#\%ghost \%{_sysconfdir}/sgml/\%{name}-\%{version}-\%{release}.cat','%ghost %{_sysconfdir}/sgml/%{name}-%{version}-%{release}.cat');
}
__END__


# does not help :(
#< export ANT_OPTS="-Xms500m -Xmx1500m -Xss1m"
#> export ANT_OPTS="-Xms800m -Xmx2000m -Xss2m"

# commented out BR: bcel, as it used old repolibs anyway.

# TODO: check and update to new wstx, as it builds with old one, but use the new one 
# TODO: check and update to new bcel

45a46,47
# alt build hack
Source44: build-thirdparty.xml
366a369,370
# alt build hack
cp %{SOURCE44}  4.2.3.GA/jboss-4.2.x/build/build-thirdparty.xml

5.0 fixes
# my hacks; included in build-thirdparty.xml
sed -i 's,apache-xmlsec" version="1.3.0-brew,apache-xmlsec" version="1.4.3-brew,g' 4.2.3.GA/jboss-4.2.x/build/build-thirdparty.xml
sed -i 's,hsqldb" version="1.8.0.8.patch01-brew,hsqldb" version="1.8.0.10,g' 4.2.3.GA/jboss-4.2.x/build/build-thirdparty.xml
sed -i 's,glassfish/jsf" version="1.2_09-brew,sun-jsf" version="1.2_12-brew,g' 4.2.3.GA/jboss-4.2.x/build/build-thirdparty.xml
