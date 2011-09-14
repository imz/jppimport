push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: rpm-build-java-osgi'."\n");
    $jpp->get_section('package','')->push_body(q!
Provides: lucene2 = %{epoch}:%{version}-%{release}
Obsoletes: lucene2 < 2.4.1
!);
    $jpp->get_section('package','demo')->push_body(q!
Provides: lucene2-demo = %{epoch}:%{version}-%{release}
Obsoletes: lucene2-demo < 2.4.1
!);
    $jpp->get_section('install')->push_body(q!
ln -s lucene.jar $RPM_BUILD_ROOT%{_javadir}/lucene2.jar
ln -s lucene-demos.jar $RPM_BUILD_ROOT%{_javadir}/lucene2-demos.jar
!);
    $jpp->get_section('files','')->push_body(q!%{_javadir}/lucene2.jar
!);
    $jpp->get_section('files','demo')->push_body(q!%{_javadir}/lucene2-demos.jar
!);
};

