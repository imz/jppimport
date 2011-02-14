#!/usr/bin/perl -w

require 'set_fix_homedir_macro.pl';
require 'windows-thumbnail-database-in-package.pl';
require 'set_target_15.pl';

# TODO: missing caused trouble
#BuildRequires: jakarta-commons-collections-tomcat5
#BuildRequires: jakarta-commons-dbcp-tomcat5
#BuildRequires: jakarta-commons-pool-tomcat5

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # FHS-2.3 back to 2.2 :(
#    $jpp->get_section('package','')->subst(qr'appdir /srv/','appdir /var/lib/');
#    $jpp->get_section('package','')->subst(qr'tempdir %{_var}/tmp/%{name}','tempdir %{_var}/cache/%{name}/temp');
#    %{__ln_s} %{tempdir} temp

    $jpp->get_section('package','el-2.1-api')->push_body('Obsoletes: tomcat6-el-1.0-api < %{epoch}:%{version}-%{release}
Conflicts: tomcat6-el-1.0-api < %{epoch}:%{version}-%{release}
');

    # TODO: posttrans is not supported, so hack around
    my $posttrans=$jpp->get_section('posttrans','');
    $posttrans->set_body([map {"# ".$_} map {s!\%posttrans!\%\%posttrans!,$_}  @{$posttrans->get_body()}]);
    my $presection=$jpp->get_section('pre','');
    my @new_body;
    foreach my $line (@{$presection->get_body()}) {
	push @new_body, $line;
	last if $line=~/^# Save the conf, app, and lib dirs/;
    }
    $presection->set_body(\@new_body);
    $jpp->get_section('preun','')->subst(qr'\%{__rm} -rf \%{workdir}','#%{__rm} -rf %{workdir}');

    # TODO: write proper tomcat6-6.0.init!
    # as a hack, an old version is taken
    $jpp->copy_to_sources('tomcat6-6.0.init');
    #$jpp->get_section('package','')->subst_if('Requires','#Requires',qr'/lib/lsb/init-functions');

    $jpp->get_section('pre')->subst(qr'-[gu] %\{tcuid\}','');

    # a part of #%post_service %name that is not implemented there:
    # condrestart on upgrade 
    $jpp->get_section('post')->push_body('/sbin/service %name condrestart'."\n");

    $jpp->get_section('files','')->push_body('%dir %{bindir}'."\n");
    #$jpp->get_section('files','el-%{elspec}-api')->subst(qr'\%defattr\(0665,root,root','#defattr(0665,root,root');
    #$jpp->get_section('files','')->subst(qr'\%defattr\(0644,root','#defattr(0644,root');

    $jpp->get_section('files','lib')->push_body('%exclude %{libdir}/log4j*jar'."\n");
    $jpp->get_section('files','lib')->push_body('%exclude %{libdir}/tomcat6-el-2.1-api*jar'."\n");

    $jpp->get_section('files','')->push_body('%exclude /etc/tomcat6/log4j.properties'."\n");

    # till ant 1.8 migration
    $jpp->get_section('package','')->push_body('BuildRequires: ant-trax'."\n");
    $jpp->get_section('build','')->subst_if(qr'xalan-j2-serializer','xalan-j2-serializer ant/ant-trax',qr'OPT_JAR_LIST');
    #="ant/ant-trax"

    # fedora tomcat misses those jpackage alternatives
    $jpp->get_section('install')->push_body('
install -d $RPM_BUILD_ROOT/%_altdir; cat >$RPM_BUILD_ROOT/%_altdir/el_api_%{name}-el-1.0-api<<EOF
%{_javadir}/el_api.jar	%{_javadir}/%{name}-el-%{elspec}-api.jar	10000
EOF
install -d $RPM_BUILD_ROOT/%_altdir; cat >$RPM_BUILD_ROOT/%_altdir/el_1_0_api_%{name}-el-1.0-api<<EOF
%{_javadir}/el_1_0_api.jar	%{_javadir}/%{name}-el-%{elspec}-api.jar	10000
EOF
');
    $jpp->get_section('files','el-%{elspec}-api')->push_body('%_altdir/el_1_0_api_%{name}-el-1.0-api
%_altdir/el_api_%{name}-el-1.0-api
');
    $jpp->get_section('files','')->subst(qr'^\%attr\(0765,','%attr(0775,');
}
__DATA__

__END__
# fedora
    # log4j no more exists
    #$jpp->get_section('files','log4j')->subst(qr'\%defattr','#defattr');
    #$jpp->get_section('package','lib')->push_body('Requires: tomcat6-el-2.1-api tomcat6-log4j'."\n");

    # broken symlink
    $jpp->get_section('install')->subst(qr'\%{bindir}/tomcat-juli\* \.','%{bindir}/tomcat-juli.jar %{bindir}/tomcat-juli-%{version}.jar .',qr'__ln_s');


# jpp stuff ?
#Requires(post): %{_javadir}/ecj.jar
    $jpp->get_section('package','lib')->subst_if('Requires','#Requires',qr'ecj.jar');


