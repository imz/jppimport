#!/usr/bin/perl -w

require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;

    $jpp->get_section('package','')->set_tag('Summary','Jython is an implementation of Python written in pure Java.');
    #$jpp->get_section('package','')->subst(qr'cpython_version\s+2.3','cpython_version	2.4');

    $jpp->get_section('package','')->push_body('BuildArch: noarch'."\n") unless $jpp->get_section('package','')->match(qr'BuildArch:\s*noarch');

    $jpp->get_section('package','')->unshift_body('#BuildRequires(pre): j2se-jdbc = 1.4.2
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

    $jpp->add_section('post','')->push_body('
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

#');
#    $jpp->get_section('preun','')->push_body('

    # for fedora jython lacking pom
    if (!$jpp->get_section('package','')->match(qr'^Source.:.+jython.*\.pom')) {
	$jpp->get_section('install')->push_body(q!
%add_to_maven_depmap %{name} %{name} %{version} JPP %{name}                     
%add_to_maven_depmap org.python %{name} %{version} JPP %{name}                  

# poms
install -d -m 755 $RPM_BUILD_ROOT%{_datadir}/maven2/poms
cat > $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.%{name}.pom <<'EOF'
<project>
  <modelVersion>4.0.0</modelVersion>
  <groupId>jython</groupId>
  <artifactId>jython</artifactId>
  <version>%version</version>

  <distributionManagement>
    <relocation>
      <groupId>org.python</groupId>
    </relocation>
  </distributionManagement>

</project>
EOF
!);
	
	$jpp->get_section('files','')->push_body(q!# pom
%{_datadir}/maven2/poms/*
%{_mavendepmapfragdir}/*
!);
    }
}

__END__
