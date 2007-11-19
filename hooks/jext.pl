# todo: fix push_body in %%if_ed posts!
#require 'set_update_menus.pl';
require 'add_missingok_config.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp,'/etc/jext.conf');
    $jpp->disable_package('legacymenu');
    $jpp->disable_package('mdkmenu');
    $jpp->get_section('install')->push_body(q{# fix to report
%__subst 's,Categories=Application;Development;X-JPackage;,Categories=X-JPackage;Java;Development;IDE;,' $RPM_BUILD_ROOT%_desktopdir/jpackage-jext.desktop

# hack around push_body in %%if_ed posts!!!
%post
%update_menus
%postun
%clean_menus

});

}
