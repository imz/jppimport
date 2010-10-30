#!/usr/bin/perl -w

require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp, '/etc/fop.conf','');
    $jpp->get_section('install')->push_body(q!
# hack intil jpackage #308
# https://www.jpackage.org/bugzilla/show_bug.cgi?id=308
# will be fixed
subst 's,excalibur/avalon-framework-api,excalibur/avalon-framework-api excalibur/avalon-framework-impl,' $RPM_BUILD_ROOT%_bindir/%name
subst 's,xmlgraphics-batik/util,xmlgraphics-batik,' $RPM_BUILD_ROOT%_bindir/%name
!);

    $jpp->get_section('install')->push_body(q!
# fop compat symlinks
pushd $RPM_BUILD_ROOT/%_javadir
ln -s xmlgraphics-fop.jar fop.jar
popd
pushd $RPM_BUILD_ROOT/%_bindir
ln -s xmlgraphics-fop fop
popd

!);

    $jpp->get_section('package','')->push_body(q!
Provides: fop = %{epoch}:%version
Obsoletes: fop <= 0:0.21
Obsoletes: fop <= 0.21
Conflicts: fop <= 0:0.21
!);
    $jpp->get_section('files')->push_body(q!%_javadir/fop.jar
%_bindir/fop
!);
}
