#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('install')->unshift_body_after(qr'sed.+repodir.+/component-info.xml', q!
%{__sed} -i 's/project name=""/project name="%{name}"/g' %{buildroot}%{repodir}/component-info.xml
!);
}

__END__
