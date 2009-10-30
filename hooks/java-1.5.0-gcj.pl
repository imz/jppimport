#!/usr/bin/perl -w

require 'set_bootstrap.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->add_section('package','aot-compile');
    $jpp->get_section('package','aot-compile')->push_body(q!
Summary: java jcj ahead-of-time compile scripts
Group: Development/Java
BuildArch: noarch

%description aot-compile
java jcj ahead-of-time compile scripts
!);
    # tmp hack due t obroken Sisyphus!!!
    #$jpp->get_section('package','')->subst_if(qr'libssl-devel','ca-certificates',qr'BuildRequires:');

    # ARM-friendly deps...
    $jpp->get_section('package','')->exclude(qr'BuildRequires: jpackage-.*-compat');
    $jpp->get_section('package','')->unshift_body('BuildRequires(pre): rpm-build-java'."\n");

    $jpp->get_section('package','')->subst_if(qr'openssl','ca-certificates',qr'BuildRequires:');
    $jpp->get_section('package','')->subst(qr'^\%define origin\s+gcj\%{gccsuffix}','%define origin          gcj');
    $jpp->get_section('package','')->subst(qr'^\%define gccver\s.*','%define gccver          4.4-alt1'."\n");
    $jpp->get_section('package','')->subst(qr'^\%define gccsuffix\s.*','%define gccsuffix       -4.4'."\n");
    $jpp->get_section('package','')->unshift_body('%define gccrpmsuffix    4.4'."\n");
    $jpp->get_section('package','')->subst_if(qr'gccsuffix','gccrpmsuffix',qr'Requires:\s+(gcc|libgc)');
    $jpp->get_section('package','devel')->subst_if(qr'gccsuffix','gccrpmsuffix',qr'Requires:\s+(gcc|libgc)');
    $jpp->get_section('package','devel')->push_body('Requires: %name-aot-compile = %version-%release'."\n");
    $jpp->get_section('package','src')->subst_if(qr'gccsuffix','gccrpmsuffix',qr'Requires:\s+(gcc|libgc)');

    foreach my $section ($jpp->get_sections()) {
	if ($section->get_type() eq 'triggerin') {
	    $section->subst_if(qr'gccsuffix','gccrpmsuffix',qr'^\%trigger');
	}
    }


    $jpp->get_section('prep')->push_body(q!%__subst s,/etc/pki/tls/cert.pem,/usr/share/ca-certificates/ca-bundle.crt, generate-cacerts.pl
for i in Makefile.am Makefile.in; do
    subst 's,python setup.py install --prefix=\$\(DESTDIR\)\$\(prefix\),%__python setup.py install --root=%buildroot  --optimize=2 --record=INSTALLED_FILES,' $i
done
!);

    $jpp->get_section('install')->push_body('install -d -m755 %buildroot/usr/lib/jvm-exports/%{sdkdir}'."\n");

    # ghosts. kill?
    #$jpp->get_section('install')->subst(qr'^touch \$RPM_BUILD_ROOT','#touch $RPM_BUILD_ROOT');
    # or
    $jpp->get_section('files','')->subst(qr'#%ghost','%ghost');
    $jpp->get_section('files','devel')->subst(qr'#%ghost','%ghost');
    
    # why they intersect... it is better to fix
    $jpp->get_section('files','')->push_body('%dir /usr/lib/jvm-exports/%{sdkdir}'."\n");
    $jpp->get_section('files','devel')->push_body('%dir /usr/lib/jvm-exports/%{sdkdir}'."\n");
    $jpp->get_section('files','devel')->subst(qr'%{python_sitelib}','#%{python_sitelib}');
    $jpp->get_section('files','devel')->push_body('%exclude %_bindir/aot-compile*'."\n");

    $jpp->add_section('files','aot-compile');
    $jpp->get_section('files','aot-compile')->push_body('%_bindir/aot-compile*
/usr/lib/python*/site-packages/*'."\n");

#    my @sections=grep {$_->get_type() ne 'triggerin' && !($_->get_type() eq 'postun' && $_->get_package() eq 'plugin')} $jpp->get_sections();
#    $jpp->set_sections(\@sections);


    $jpp->disable_package('');
    $jpp->disable_package('devel');
    $jpp->disable_package('src');
}
