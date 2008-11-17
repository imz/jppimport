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
}
