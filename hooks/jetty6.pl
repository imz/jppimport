#!/usr/bin/perl -w

require 'set_fix_homedir_macro.pl';
require 'add_missingok_config.pl';
require 'set_apache_translation.pl';
require 'set_add_fc_osgi_manifest.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;

    #%define appdir /srv/jetty6
    $jpp->get_section('package','')->subst_if(qr'/srv/jetty6', '/var/lib/jetty6',qr'\%define');

    $jpp->get_section('package','')->unshift_body(q!BuildRequires: jetty6-core!."\n");

    # requires from nanocontainer-webcontainer :(
    #$jpp->get_section('package','jsp-2.0')->push_body('Provides: jetty6-jsp-2.0-api = %version'."\n");

    &add_missingok_config($jpp, '/etc/default/%{name}','');
    &add_missingok_config($jpp, '/etc/default/jetty','');

    $jpp->copy_to_sources('jetty.init');
    #if ($jpp->get_section('package','')->match(qr'Source7:\s+jetty.init\s*$')) {
    #	$jpp->get_section('prep')->push_body("sed -i 's,daemon --user,start_daemon --user,' %SOURCE7"."\n");
    #}
    $jpp->applied_block(
	"exclude tempdir hook",
	sub {
	    foreach my $section ($jpp->get_sections()) {
		$section->exclude(qr'\%{tempdir}');
	    }
	}
	);

    # remove explicit group ids
    $jpp->get_section('pre','')->subst(qr'-[gu]\s+%\{jtuid\}','-r');
    # set default shell to /dev/null (will it work ?)
    #$jpp->get_section('pre','')->subst(qr'-s /bin/sh','/dev/null');
    # hack to fix upgrade from -alt2 if rmuser/adduser to be applied
    #$jpp->get_section('post','')->push_body('chown -R %{name}.%{name} %logdir'."\n");


}



__END__
