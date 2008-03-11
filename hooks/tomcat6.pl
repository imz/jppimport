#!/usr/bin/perl -w

require 'set_fix_homedir_macro.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;
    # FHS-2.3 back to 2.2 :(
    $jpp->get_section('package','')->subst(qr'appdir /srv/','appdir /var/lib/');
    $jpp->get_section('package','')->subst(qr'tempdir %{_var}/tmp/%{name}','tempdir %{_var}/cache/%{name}/temp');
#    %{__ln_s} %{tempdir} temp

    $jpp->get_section('pre')->subst(qr'-[gu] %\{tcuid\}','');

    # a part of #%post_service %name that is not implemented there:
    # condrestart on upgrade 
    $jpp->get_section('post')->push_body('/sbin/service %name condrestart'."\n");
}
__DATA__
