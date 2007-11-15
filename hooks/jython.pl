#!/usr/bin/perl -w

require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'mysql-connector-java','mysql-connector-jdbc');
    $jpp->get_section('package','')->subst(qr'cpython_version\s+2.3','cpython_version	2.4');
    $jpp->get_section('prep')->subst(qr'mysql-connector-java','mysql-connector-jdbc');
    foreach my $section (@{$jpp->get_sections()}) {
	if ($section->get_type() eq 'package') {
#	    $section->subst(qr'PyXML\s*>=\s*0:%{pyxml_version}','python-module-PyXML ');
	    $section->subst(qr'PyXML\s*>=\s*0:%{pyxml_version}','python-module-PyXML ');
	}
    }

    $jpp->get_section('package','')->unshift_body('BuildRequires(pre): j2se-jdbc = 1.4.2
BuildRequires: rpm-build-python
AutoReq: yes, nopython
AutoProv: yes, nopython
');
    &add_missingok_config($jpp,'/etc/jython.conf');
}

__END__
%define cpython_version 2.3
%define cpythondir      python%{cpython_version}
%define pyxml_version   0.8.3
