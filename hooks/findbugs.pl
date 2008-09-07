# todo: fix push_body in %%if_ed posts!
#require 'set_update_menus.pl';
require 'add_missingok_config.pl';

# todo: join with jext

$spechook = sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp,'/etc/%name.conf');
    $jpp->get_section('install')->push_body(q{# fix to report
%__subst 's,Categories=Application;Development;X-JPackage;,Categories=X-JPackage;Java;Development;Debugger;,' $RPM_BUILD_ROOT%_desktopdir/jpackage-%name.desktop
});
    $jpp->get_section('post')->push_body(q{%update_menus
});
    $jpp->get_section('postun')->push_body(q{%clean_menus
});
}
