#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('post','')->subst_body(qr'\%systemd_post hsqldb.service','%post_service hsqldb');
    $jpp->get_section('postun','')->exclude_body(qr'\%systemd_postun_with_restart hsqldb.service');
    $jpp->add_section('preun','')->push_body('%preun_service hsqldb'."\n");
};

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('hsqldb-1.8.0.7-alt-init.patch',STRIP=>1);
    $jpp->get_section('pre','')->subst_body_if(qr'-g\s+\d+','',qr'groupadd');
    $jpp->get_section('pre','')->subst_body_if(qr'-u\s+\d+','',qr'useradd');
    $jpp->get_section('install')->push_body(q!# sysv init
install -d -m 755 $RPM_BUILD_ROOT%{_initrddir}
install -m 755 bin/%{name} $RPM_BUILD_ROOT%{_initrddir}/%{name}!."\n");
    $jpp->get_section('files')->push_body(q!%{_initrddir}/%{name}!."\n");
};

__END__

