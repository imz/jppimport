#!/usr/bin/perl -w

require 'set_add_fc_osgi_manifest.pl';
require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp, '/etc/fop.conf','');
    $jpp->get_section('install')->push_body(q!
# hack intil jpackage #308
# https://www.jpackage.org/bugzilla/show_bug.cgi?id=308
# will be fixed
subst 's,excalibur/avalon-framework-api,excalibur/avalon-framework-api excalibur/avalon-framework-impl,' %buildroot%_bindir/%name
subst 's,xmlgraphics-batik/util,xmlgraphics-batik,' %buildroot%_bindir/%name
!);
    $jpp->get_section('install')->push_body(q!# add xmlgraphics-commons to classpath
grep xmlgraphics-commons %buildroot%_bindir/xmlgraphics-fop || sed -i 's,xmlgraphics-fop xmlgraphics-batik,xmlgraphics-fop xmlgraphics-batik xmlgraphics-commons,' %buildroot%_bindir/xmlgraphics-fop
!);

    $jpp->get_section('install')->push_body(q!
# fop compat symlinks
pushd $RPM_BUILD_ROOT/%_javadir
ln -s xmlgraphics-fop.jar fop.jar
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
Obsoletes: fop <= 0:0.21
Obsoletes: fop <= 0.21
Conflicts: fop <= 0:0.21
!);
    $jpp->get_section('files')->push_body(q!# compat symlinks
%_javadir/fop.jar
%_bindir/fop
%_datadir/fop
!);
}
