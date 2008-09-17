#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: servletapi4 jakarta-commons-validator'."\n");
    # over shebang.req.files: executable script /usr/src/tmp/quartz-buildroot/usr/share/quartz-1.5.2/bin/buildcp.sh not executable
    #$jpp->get_section('package','')->unshift_body('AutoReq yes. noshell'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: /usr/bin/dos2unix'."\n");
    $jpp->get_section('install')->push_body('find $RPM_BUILD_ROOT%_datadir/%name-%version/ -name "*.sh" -print0 | xargs -0 chmod 755'."\n");
    $jpp->get_section('install')->push_body('dos2unix $RPM_BUILD_ROOT%_datadir/%name-%version/*/*.sh'."\n");
}
