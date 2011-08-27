#!/usr/bin/perl -w

require 'set_apache_obsoletes_epoch1.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst_if(qr!/repository.jboss.com/%{base_name}/!,'/repository.jboss.com/apache-%{base_name}/',qr'^\%define repodir');
    $jpp->get_section('install')->unshift_body_after(qr'__sed.+repodir.+/component-info.xml',
q!%{__sed} -i 's/project name=""/project name="%{name}"/;s/id="commons-collections"/id="apache-collections"/' %{buildroot}%{repodir}/component-info.xml

!);
}

__END__
