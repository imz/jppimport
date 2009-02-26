#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->copy_to_sources('xpp3_min-1.1.4c.pom');
    $jpp->get_section('package','')->push_body('Source101: http://repo2.maven.org/maven2/xpp3/xpp3_min/1.1.4c/xpp3_min-1.1.4c.pom'."\n");
    $jpp->get_section('install')->push_body(q!
#add_to_maven_depmap xpp3 xpp3 %{version} JPP %{name}
# TODO move xpp3_min.pom and depmap to minimal
#add_to_maven_depmap xpp3 xpp3_min %{version} JPP %{name}-minimal
%add_to_maven_depmap xpp3 xpp3_min %{version} JPP %{name}

install -D -m 644 %{SOURCE101} %{buildroot}%{_datadir}/maven2/poms/JPP-%{name}-minimal.pom
!);
    $jpp->get_section('files','minimal')->push_body(q!
#%_mavendepmapfragdir/%{name}-minimal
#%_datadir/maven2/poms/JPP-%{name}-minimal.pom
!);
    $jpp->get_section('files','')->push_body(q!
#%_datadir/maven2/poms/JPP-%{name}.pom
# todo: move to 'minimal' subpackage
%_mavendepmapfragdir/%{name}
%_datadir/maven2/poms/JPP-%{name}-minimal.pom
!);
};

1;
__END__
%__cp -a %{SOURCE1} %{buildroot}%{_datadir}/maven2/poms/JPP-%{name}.pom
%__cp -a %{SOURCE2} %{buildroot}%{_datadir}/maven2/poms/JPP-%{name}-runtime.pom

