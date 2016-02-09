#!/usr/bin/perl -w

require 'set_osgi.pl';
#require 'set_add_fc_osgi_manifest.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body(q!Provides:       %{short_name} = %{epoch}:%{version}-%{release}!."\n");
    $jpp->get_section('package','')->push_body(q!Provides:       jakarta-%{short_name} = %{epoch}:%{version}-%{release}!."\n");

}

__END__
#    $jpp->get_section('install')->push_body(q!ln -sf %{name}.jar %{buildroot}%{_javadir}/jakarta-%{short_name}.jar!."\n");
#    $jpp->get_section('files','')->push_body(q!%{_javadir}/jakarta-%{short_name}.jar!."\n");
