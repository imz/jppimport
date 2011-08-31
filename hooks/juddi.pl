#!/usr/bin/perl -w

require 'set_fix_homedir_macro.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'#\%\%define appdir','%define appdir');

    #foreach my $section ($jpp->get_sections()) {
	# webapp is needed for symlink resolution
    #$section->subst(qr'if 0','if 1');
    #}
    # вместо
    $jpp->get_section('files','webapps')->push_body('%exclude /usr/share/juddi/webapps'."\n");
    # вместо
    # /var/lib/juddi/webapps not packaged
    #$jpp->get_section('install')->push_body('mkdir -p $RPM_BUILD_ROOT/var/lib/juddi/webapps'."\n");
    #$jpp->get_section('files')->push_body('%dir /var/lib/juddi/webapps'."\n");


# reported #294
    # homedir confilct 
    #map {$_->subst(qr'homedir','apphomedir')} $jpp->get_sections();
 
};

1;
