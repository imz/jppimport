#!/usr/bin/perl -w

require 'set_skip_usr_bin_run.pl';
require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;

    $spec->get_section('package','')->set_tag('Summary','Jython is an implementation of Python written in pure Java.');
    #$spec->get_section('package','')->subst(qr'cpython_version\s+2.3','cpython_version	2.4');

    $spec->get_section('package','')->push_body('BuildArch: noarch'."\n") unless $spec->get_section('package','')->match_body(qr'BuildArch:\s*noarch');

    $spec->get_section('package','')->unshift_body('#BuildRequires(pre): j2se-jdbc = 1.4.2
BuildRequires: jline
# recommends
Requires: jline libreadline-java
AutoReq: yes, nopython
');
    $spec->get_section('package','demo')->push_body('AutoReq: yes, nopython
#AutoProv: yes, nopython
');
    &add_missingok_config($spec,'/etc/jython.conf');

    $spec->get_section('install')->push_body('
mkdir -p $RPM_BUILD_ROOT%{_localstatedir}/jython/cachedir/packages
ln -s $(relative %{_localstatedir}/jython/cachedir %{_datadir}/jython/) $RPM_BUILD_ROOT%{_datadir}/jython/
');

    $spec->get_section('files','')->push_body('
%{_localstatedir}/jython
# is it worth ghosting?
#%ghost %{_localstatedir}/jython/cachedir/packages
%{_datadir}/jython/cachedir
');

    $spec->add_section('post','')->push_body('
echo "creating jython cache..."
echo | /usr/bin/jython ||:

%preun
# cleanup
if [ "$1" -eq 0 ]
then
    rm %{_localstatedir}/jython/cachedir/packages/*.{pkc,idx}
    find /usr/share/jython/Lib -name "*py.class" -delete
fi || :
');

}

__END__
