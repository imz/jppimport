#!/usr/bin/perl -w

require 'set_target_15.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;


    # cglib-nodeps support
    $jpp->get_section('package','')->unshift_body('BuildRequires: jarjar'."\n");
    die "killing patch is deprecated" if not $jpp->main_section->match_body(qr'Remove the repackaging step that includes other jars into the final thing');
    $jpp->get_section('prep')->subst_body(qr'^\%patch0','#patch0');
    $jpp->get_section('prep')->push_body(q!# for jarjar
pushd lib
ln -s $(build-classpath objectweb-asm/asm) asm-3.1.jar
popd!."\n");
    $jpp->get_section('build')->subst_body_if(qr'build-classpath objectweb-asm','build-classpath objectweb-asm jarjar',qr'CLASSPATH');
    my $s4=$jpp->add_source('cglib-nodep-2.2.pom');
    $jpp->get_section('install')->push_body(q!# jpp6 compat
cp -p dist/%{name}-nodep-%{version}.jar %{buildroot}%{_javadir}/%{name}-nodep.jar
cp -p %{SOURCE!.$s4.q!} %{buildroot}%{_mavenpomdir}/JPP-%{name}-nodep.pom
%add_to_maven_depmap cglib cglib-nodep %{version} JPP %{name}-nodep
%add_to_maven_depmap net.sf.cglib cglib-nodep %{version} JPP %{name}-nodep
!."\n");
    $jpp->get_section('files')->push_body(q!# jpp6 compat
%{_javadir}/%{name}-nodep.jar
%{_mavenpomdir}/JPP-%{name}-nodep.pom
!."\n");
};

__END__
