#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body('AutoReqProv: yes,noosgi'."\n");
    $jpp->get_section('package','')->push_body('Obsoletes: ivy < 2'."\n");
    my $num=$jpp->add_source('ivy-2.2.0.pom', NAME=>'http://repo1.maven.org/maven2/org/apache/ivy/ivy/2.2.0/ivy-2.2.0.pom');
    $jpp->get_section('install')->push_body('# poms
mkdir -p %{buildroot}%_mavenpomdir
cp -p %{SOURCE'.$num.'} %{buildroot}%_mavenpomdir/JPP-%{name}.pom
%add_to_maven_depmap org.apache.ivy ivy %{version} JPP %{name}
# jpp symlink
ln -s ivy.jar %buildroot%_javadir/%{name}.jar
'."\n");
    $jpp->get_section('files','')->push_body('# jpp compat
%_mavenpomdir/JPP-%{name}.pom
%{_mavendepmapfragdir}/%{name}
%_javadir/%{name}.jar
'."\n");

};

__END__
