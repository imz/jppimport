require 'add_missingok_config.pl';

# todo: join with jext

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp,'/etc/%name.conf');
    $jpp->get_section('install')->push_body(q{# fix to report
%__subst 's,Categories=Application;Development;X-JPackage;,Categories=X-JPackage;Java;Development;Debugger;,' $RPM_BUILD_ROOT%_desktopdir/jpackage-%name.desktop
});
}
