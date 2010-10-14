#!/usr/bin/perl -w

require 'set_fix_homedir_macro.pl';
require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;

    #%define appdir /srv/jetty6
    $jpp->get_section('package','')->subst_if(qr'/srv/jetty6', '/var/lib/jetty6',qr'\%define');

    # requires from nanocontainer-webcontainer :(
    $jpp->get_section('package','jsp-2.0')->push_body('Provides: jetty6-jsp-2.0-api = %version'."\n");

    &add_missingok_config($jpp, '/etc/default/%{name}','');
    &add_missingok_config($jpp, '/etc/default/jetty','');

    if ($jpp->get_section('package','')->match(qr'Source7:\s+jetty.init\s*$')) {
	$jpp->get_section('prep')->push_body("sed -i 's,daemon --user,start_daemon --user,' %SOURCE7"."\n");
    } else {
	die "jetty6 init not found";
    }
    $jpp->applied_block(
	"exclude tempdir hook",
	sub {
	    foreach my $section ($jpp->get_sections()) {
		$section->exclude(qr'\%{tempdir}');
	    }
	}
	);
}



__END__
