require 'add_missingok_config.pl';

# todo: join with jext

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp,'/etc/%name.conf');
    $jpp->get_section('install')->push_body(q{# fix to report
%__subst 's,Categories=Application;Development;X-JPackage;,Categories=X-JPackage;Java;Development;Debugger;,' $RPM_BUILD_ROOT%_desktopdir/jpackage-%name.desktop
});
    $jpp->get_section('files')->push_body(q{#unpackaged directory: 
%dir %_datadir/%name-%version/bin/deprecated
%dir %_datadir/%name-%version/bin/experimental
});
};

__END__
    #  -2 jpp6
    $jpp->get_section('package','')->subst_if(qr'jakarta-commons-lang24','commons-lang',qr'Requires:');
    $jpp->get_section('prep')->subst(qr'commons-lang24','commons-lang');
    $jpp->get_section('install')->subst(qr'commons-lang24','commons-lang');
    $jpp->get_section('files')->subst(qr'commons-lang24','commons-lang');

