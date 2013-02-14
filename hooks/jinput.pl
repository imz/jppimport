#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('files')->push_body(q!%_javadir/%{name}.jar!."\n");
};

__END__
# added by hand
mkdir -p %buildroot%_javadir/
ln -s $(relative %_libdir/%{name}/%{name}.jar %_javadir/) %buildroot%_javadir/%{name}.jar
%add_maven_depmap JPP-%{name}.pom %{name}.jar
%add_maven_depmap JPP-%{name}-platform.pom

instead of 
%add_to_maven_depmap JPP-%{name}.pom %{name}.jar
%add_to_maven_depmap JPP-%{name}-platform.pom
