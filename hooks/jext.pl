require 'add_missingok_config.pl';
# TODO
require 'set_target_14.pl';

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp,'/etc/%name.conf');
    $jpp->disable_package('legacymenu');
    $jpp->disable_package('mdkmenu');
    $jpp->get_section('install')->push_body(q{# fix to report
%__subst 's,Categories=Application;Development;X-JPackage;,Categories=X-JPackage;Java;Development;IDE;,' $RPM_BUILD_ROOT%_desktopdir/jpackage-%name.desktop
%__subst 's,.png$,,' $RPM_BUILD_ROOT%_desktopdir/jpackage-%name.desktop

});

}
