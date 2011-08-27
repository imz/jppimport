#!/usr/bin/perl -w

require 'set_fix_repolib_project.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('install')->unshift_body_after(qr'__sed.+repodir.+/component-info.xml',
q!%{__sed} -i "s/@VERSION@/%{version}-brew/g" %{buildroot}%{repodir}/component-info.xml
!);
}

__END__
