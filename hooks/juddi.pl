#!/usr/bin/perl -w

require 'set_fix_homedir_macro.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'#\%\%define appdir','%define appdir');

# reported #294
    # homedir confilct 
    #map {$_->subst(qr'homedir','apphomedir')} $jpp->get_sections();
    # /var/lib/juddi/webapps not packaged
    #$jpp->get_section('install')->push_body('mkdir -p $RPM_BUILD_ROOT/var/lib/juddi/webapps'."\n");
    #$jpp->get_section('files')->push_body('%dir /var/lib/juddi/webapps'."\n");
 
};

1;
