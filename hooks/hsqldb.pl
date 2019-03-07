#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($spec,) = @_;
#    $spec->add_patch('hsqldb-1.8.0.7-alt-init.patch',STRIP=>1);
    my $initno=$spec->add_source('hsqldb.init');
    $spec->get_section('pre','')->subst_body_if(qr'-g\s+\d+','',qr'groupadd');
    $spec->get_section('pre','')->subst_body_if(qr'-u\s+\d+','',qr'useradd');
    $spec->get_section('install')->push_body(q!# sysv init
install -d -m 755 $RPM_BUILD_ROOT%{_initrddir}
#install -m 755 bin/%{name} $RPM_BUILD_ROOT%{_initrddir}/%{name}
install -m 755 %{SOURCE!.$initno.q!} $RPM_BUILD_ROOT%{_initrddir}/%{name}
!."\n");
    $spec->get_section('files')->push_body(q!%{_initrddir}/%{name}!."\n");
};

__END__

