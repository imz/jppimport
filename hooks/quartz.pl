#!/usr/bin/perl -w

require 'set_fix_repolib_project.pl';
require 'set_dos2unix_scripts.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: geronimo-jta-1.0.1B-api'."\n");
    # over shebang.req.files: executable script /usr/src/tmp/quartz-buildroot/usr/share/quartz-1.5.2/bin/buildcp.sh not executable
    #$jpp->get_section('package','')->unshift_body('AutoReq yes. noshell'."\n");
    $jpp->get_section('install')->push_body('find $RPM_BUILD_ROOT%_datadir/%name-%version/ -name "*.sh" -print0 | xargs -0 chmod 755'."\n");
}
__END__
