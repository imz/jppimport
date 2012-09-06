#!/usr/bin/perl -w

require 'set_osgi.pl';
#require 'set_add_fc_osgi_manifest.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body(q!Provides:       %{short_name} = %{epoch}:%{version}-%{release}!."\n");
    $jpp->get_section('install')->push_body(q!ln -sf %{name}.jar %{buildroot}%{_javadir}/jakarta-%{short_name}.jar!."\n");
    $jpp->get_section('files','')->push_body(q!%{_javadir}/jakarta-%{short_name}.jar!."\n");

}

__END__
Source3:        %{oldname}-component-info.xml

%def_with repolib
%define repodir %{_javadir}/repository.jboss.com/apache-%{base_name}/%{version}-brew
%define repodirlib %{repodir}/lib
%define repodirres %{repodir}/resources
%define repodirsrc %{repodir}/src

...
