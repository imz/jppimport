push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst_body(qr'^BuildRequires:\s+mojo-maven2-plugin-findbugs','#BuildRequires: mojo-maven2-plugin-findbugs');
    $jpp->get_section('package','')->subst_body(qr'^BuildRequires:\s+mojo-maven2-plugin-shitty','#BuildRequires: mojo-maven2-plugin-shitty');
    $jpp->get_section('package','')->subst_body_if(qr'>=?\s+17','= 17','^Obsoletes:');
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven-plugin-cobertura maven-surefire-provider-junit4 maven-enforcer-plugin maven-antrun-plugin'."\n");
    $jpp->get_section('install')->subst_body(qr'^ln -sf \%{name}-\%{version}.jar (?:\$RPM_BUILD_ROOT|\%{buildroot})\%{_javadir}/mojo/','ln -sf ../%{name}-%{version}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/');
};

__END__
    $jpp->get_section('package','')->subst_body_if(qr'','',qr'Requires:');
    $jpp->get_section('prep')->push_body(q!!."\n");
