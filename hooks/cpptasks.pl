#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;

    # 1.0b5-8; there were no cpptasks.jar. We just added a symlink, so jardup :(
    $jpp->get_section('install')->subst_body(qr'^echo "\%{name} ant/','echo "ant/');

    $jpp->get_section('install')->push_body(q!# jpp compat
ln -s ant/%{name}.jar $RPM_BUILD_ROOT%{_javadir}/%{name}.jar
%add_to_maven_depmap ant-contrib %{name} %{namedversion} JPP %{name}

# poms
install -D -m 644 pom.xml $RPM_BUILD_ROOT%_mavenpomdir/JPP-%{name}.pom
!."\n");
    $jpp->get_section('files','')->push_body(q!
%{_javadir}/%{name}.jar
%{_mavendepmapfragdir}/*
%_mavenpomdir/*
!."\n");
};

__END__
