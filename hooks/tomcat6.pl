#!/usr/bin/perl -w

require 'set_fix_homedir_macro.pl';
require 'windows-thumbnail-database-in-package.pl';
require 'set_target_15.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # FHS-2.3 back to 2.2 :(
#    $jpp->get_section('package','')->subst(qr'appdir /srv/','appdir /var/lib/');
#    $jpp->get_section('package','')->subst(qr'tempdir %{_var}/tmp/%{name}','tempdir %{_var}/cache/%{name}/temp');
#    %{__ln_s} %{tempdir} temp

    # TODO: write proper tomcat6-6.0.init!
    # as a hack, an old version is taken
    $jpp->copy_to_sources('tomcat6-6.0.init');
    $jpp->get_section('package','')->subst_if('Requires','#Requires',qr'/lib/lsb/init-functions');

#Requires(post): %{_javadir}/ecj.jar
    $jpp->get_section('package','lib')->subst_if('Requires','#Requires',qr'ecj.jar');

    $jpp->get_section('pre')->subst(qr'-[gu] %\{tcuid\}','');

    # a part of #%post_service %name that is not implemented there:
    # condrestart on upgrade 
    $jpp->get_section('post')->push_body('/sbin/service %name condrestart'."\n");
}
__DATA__
