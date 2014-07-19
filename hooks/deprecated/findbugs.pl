require 'add_missingok_config.pl';

# todo: join with jext

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp,'/etc/%name.conf');

    $jpp->get_section('prep')->push_body(q{# offline
sed -i -e s,http://findbugs.googlecode.com/svn/trunk/findbugs/etc/docbook/docbookx.dtd,`pwd`/etc/docbook/docbookx.dtd,g `grep -rl 'http://findbugs.googlecode.com/svn/trunk/findbugs/etc/docbook/docbookx.dtd' .`
});
    $jpp->get_section('install')->push_body(q{# fix to report
sed -i -e 's,Categories=Development;X-JPackage;,Categories=X-JPackage;Java;Development;Debugger;,' $RPM_BUILD_ROOT%_desktopdir/*.desktop
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
