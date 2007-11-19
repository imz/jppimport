#!/usr/bin/perl -w

require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;

    $jpp->get_section('package','')->set_tag('Summary','Jython is an implementation of Python written in pure Java.');
    $jpp->get_section('package','')->subst(qr'cpython_version\s+2.3','cpython_version	2.4');
    # HACK until mysql-connector-java will be built
    $jpp->get_section('package','')->subst(qr'mysql-connector-java','mysql-connector-jdbc');
    $jpp->get_section('prep')->subst(qr'mysql-connector-java','mysql-connector-jdbc');
    $jpp->get_section('build')->subst(qr'mysql-connector-java','mysql-connector-jdbc');
    foreach my $section (@{$jpp->get_sections()}) {
	if ($section->get_type() eq 'package') {
#	    $section->subst(qr'PyXML\s*>=\s*0:%{pyxml_version}','python-module-PyXML ');
	    $section->subst(qr'PyXML\s*>=\s*0:%{pyxml_version}','python-module-PyXML ');
	}
    }

    $jpp->get_section('package','')->unshift_body('BuildRequires(pre): j2se-jdbc = 1.4.2
BuildRequires: jline
# recommends
Requires: jline libreadline-java
AutoReq: yes, nopython
');
    $jpp->get_section('package','demo')->push_body('AutoReq: yes, nopython
#AutoProv: yes, nopython
');
    &add_missingok_config($jpp,'/etc/jython.conf');

    $jpp->get_section('install')->push_body('
mkdir -p $RPM_BUILD_ROOT%{_localstatedir}/jython/cachedir/packages
ln -s $(relative %{_localstatedir}/jython/cachedir %{_datadir}/jython/) $RPM_BUILD_ROOT%{_datadir}/jython/
');

    $jpp->get_section('files','')->push_body('
%{_localstatedir}/jython
# is it worth ghosting?
#%ghost %{_localstatedir}/jython/cachedir/packages
%{_datadir}/jython/cachedir
');

    $jpp->get_section('post','')->push_body('
echo "creating jython cache..."
echo | /usr/bin/jython

%preun
# cleanup
if [ "$1" -eq 0 ]
then
    rm %{_localstatedir}/jython/cachedir/packages/*.{pkc,idx}
    find /usr/share/jython/Lib -name "*py.class" -delete
fi || :
');

#');
#    $jpp->get_section('preun','')->push_body('


}

__END__
%define cpython_version 2.3
%define cpythondir      python%{cpython_version}
%define pyxml_version   0.8.3
