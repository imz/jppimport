#!/usr/bin/perl -w

require 'set_add_fc_osgi_manifest.pl';
require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp, '/etc/fop.conf','');
    &add_missingok_config($jpp, '/etc/xmlgraphics-fop.conf','');
    $jpp->get_section('install')->push_body(q!
# avalon-framework is not in requires
subst 's,excalibur/avalon-framework,excalibur/avalon-framework-api excalibur/avalon-framework-impl,' %buildroot%_bindir/%name
!);
    $jpp->get_section('install')->push_body(q!# add xmlgraphics-commons to classpath
grep xmlgraphics-commons %buildroot%_bindir/xmlgraphics-fop || sed -i 's,xmlgraphics-batik,batik-all xmlgraphics-commons commons-io commons-logging,' %buildroot%_bindir/xmlgraphics-fop
!);
    $jpp->get_section('package','')->push_body(q!Requires: commons-io commons-logging xmlgraphics-commons
!);
# fedora 14 jars
#commons-io batik-all avalon-framework xmlgraphics-commons commons-logging fop

    $jpp->get_section('install')->push_body(q!
# fop compat symlinks
pushd $RPM_BUILD_ROOT/%_javadir
ln -s xmlgraphics-fop/fop.jar fop.jar
ln -s xmlgraphics-fop/fop.jar xmlgraphics-fop.jar
popd
pushd $RPM_BUILD_ROOT/%_bindir
ln -s xmlgraphics-fop fop
popd
pushd $RPM_BUILD_ROOT/%_datadir
ln -s xmlgraphics-fop fop
popd
!);

    $jpp->get_section('package','')->push_body(q!
Provides: fop = %{epoch}:%version-%release
Obsoletes: fop <= 0.21
Conflicts: fop <= 0:0.21
!);
    $jpp->get_section('files')->push_body(q!# compat symlinks
%_javadir/fop.jar
%_javadir/xmlgraphics-fop.jar
%_bindir/fop
%_datadir/fop
!);
}
