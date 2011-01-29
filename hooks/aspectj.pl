#!/usr/bin/perl -w

require 'add_missingok_config.pl';
require 'set_bin_755.pl';

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp, '/etc/java/aspectj.conf','');
    $jpp->get_section('package','')->unshift_body('BuildRequires: ant-jakarta-regexp'."\n");
    $jpp->get_section('build')->subst(qr'-Xmx512','-Xmx1024');
    $jpp->get_section('install')->subst(qr'\%{buildroot}\%{_libdir}/eclipse','%{buildroot}%{_datadir}/eclipse');
    $jpp->get_section('files','eclipse-plugins')->subst(qr'\%{_libdir}/eclipse','%{_datadir}/eclipse');
}
__END__
