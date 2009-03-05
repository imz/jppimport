#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: cyberdomo-upnp-stack'."\n");
    # 5.0 bug to report: brioken symlink:
    # felix-maven2: brioken symlink to /usr/share/java/felix/maven-ipojo-plugin.jar

    $jpp->get_section('install')->unshift_body_after(q!
(cd $RPM_BUILD_ROOT%{_javadir}/%{name} && for jar in maven-ipojo-plugin-%{ipojo_version}*; do ln -sf ${jar} `echo $jar| sed  "s|-%{ipojo_version}||g"`; done)
# already done later
#pushd ${RPM_BUILD_ROOT}%{_datadir}/maven2/plugins
#    ln -sf %{_javadir}/%{name}/maven-ipojo-plugin.jar
#popd
!,qr'add_to_maven_depmap org.apache.felix maven-ipojo-plugin');

};
__END__
