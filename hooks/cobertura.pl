#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('cobertura-1.9-javadoc-exclude.patch');
    $jpp->get_section('install')->push_body(q!
%add_to_maven_depmap net.sourceforge.cobertura cobertura %{version} JPP %{name}
%add_to_maven_depmap net.sourceforge.cobertura cobertura-runtime %{version} JPP %{name}-runtime
!);
};

1;
__END__
>       install:install-file -DgroupId=net.sourceforge.cobertura -DartifactId=cobertura \
>        -Dversion=1.9 -Dpackaging=jar -Dfile=$(build-classpath cobertura)
: Missing:
----------
1) net.sourceforge.cobertura:cobertura-runtime:pom:1.9

%__cp -a %{SOURCE1} %{buildroot}%{_datadir}/maven2/poms/JPP-%{name}.pom
%__cp -a %{SOURCE2} %{buildroot}%{_datadir}/maven2/poms/JPP-%{name}-runtime.pom
