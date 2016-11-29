#!/usr/bin/perl -w

require 'set_bootstrap.pl';

my $gccsuffix='4.6';

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    $spec->add_section('package','aot-compile');
    $spec->get_section('package','aot-compile')->push_body(q!
Summary: java jcj ahead-of-time compile scripts
Group: Development/Java
BuildArch: noarch

%description aot-compile
java jcj ahead-of-time compile scripts
!);
    # tmp hack due t obroken Sisyphus!!!
    #$spec->get_section('package','')->subst_if(qr'libssl-devel','ca-certificates',qr'BuildRequires:');

    # ARM-friendly deps...
    $spec->get_section('package','')->exclude(qr'BuildRequires: jpackage.*-compat');
    $spec->get_section('package','')->unshift_body('BuildRequires(pre): rpm-build-java'."\n");

    $spec->get_section('package','')->subst_if(qr'openssl','ca-certificates',qr'BuildRequires:');
    $spec->get_section('package','')->subst(qr'^\%define origin\s+gcj\%{gccsuffix}','%define origin          gcj');
    $spec->get_section('package','')->subst(qr'^\%define gccver\s.*','%define gccver          '.$gccsuffix.'-alt1'."\n");
    $spec->get_section('package','')->subst(qr'^\%define gccsuffix\s.*','%define gccsuffix       -'.$gccsuffix."\n");
    $spec->get_section('package','')->unshift_body('%define gccrpmsuffix    '.$gccsuffix."\n");
    $spec->get_section('package','')->subst_if(qr'gccsuffix','gccrpmsuffix',qr'Requires:\s+(gcc|libgc)');
    $spec->get_section('package','devel')->subst_if(qr'gccsuffix','gccrpmsuffix',qr'Requires:\s+(gcc|libgc)');
    $spec->get_section('package','devel')->push_body('Requires: %name-aot-compile = %version-%release'."\n");
    $spec->get_section('package','src')->subst_if(qr'gccsuffix','gccrpmsuffix',qr'Requires:\s+(gcc|libgc)');

    foreach my $section ($spec->get_sections()) {
	if ($section->get_type() eq 'triggerin') {
	    $section->get_bodyref()->[0] =~ s/gccsuffix/gccrpmsuffix/g;
	}
    }


    $spec->get_section('prep')->push_body(q!%__subst s,/etc/pki/tls/cert.pem,/usr/share/ca-certificates/ca-bundle.crt, generate-cacerts.pl
for i in Makefile.am Makefile.in; do
    subst 's,python setup.py install --prefix=\$\(DESTDIR\)\$\(prefix\),%__python setup.py install --root=%buildroot  --optimize=2 --record=INSTALLED_FILES,' $i
done
!);

    $spec->get_section('install')->push_body('install -d -m755 %buildroot/usr/lib/jvm-exports/%{sdkdir}'."\n");

    # ghosts. kill?
    #$spec->get_section('install')->subst(qr'^touch \$RPM_BUILD_ROOT','#touch $RPM_BUILD_ROOT');
    # or
    $spec->get_section('files','')->subst(qr'#%ghost','#ghost');
    $spec->get_section('files','devel')->subst(qr'#%ghost','#ghost');
    $spec->get_section('files','src')->subst(qr'#%ghost','#ghost');
    
    $spec->get_section('files','')->push_body('%dir /usr/lib/jvm-exports/%{sdkdir}'."\n");
    $spec->get_section('files','devel')->push_body('%dir /usr/lib/jvm-exports/%{sdkdir}'."\n");


    # separated from -devel
    $spec->get_section('files','devel')->exclude_body(qr'python_sitelib');
    $spec->get_section('files','devel')->exclude_body('%{_bindir}/aot-compile'."\n");
    #$spec->add_section('files','aot-compile');
    $spec->add_section('files','aot-compile')->push_body('# separated from devel
%{_bindir}/aot-compile
%{_bindir}/aot-compile-rpm
%{python_sitelibdir_noarch}/aotcompile.py*
%{python_sitelibdir_noarch}/classfile.py*
%{python_sitelibdir_noarch}/java_gcj_compat-%{jgcver}-py?.?.egg-info'."\n");

#    my @sections=grep {$_->get_type() ne 'triggerin' && !($_->get_type() eq 'postun' && $_->get_package() eq 'plugin')} $spec->get_sections();
#    $spec->set_sections(\@sections);


    $spec->disable_package('');
    $spec->disable_package('devel');
    # TODO: drop triggers instead and use alternatives?
    $spec->disable_package('src');
}
