#!/usr/bin/perl -w

require 'set_bootstrap.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'java-1.6.0-openjdk-devel','java-1.5.0-sun-devel');
    $jpp->get_section('package','')->subst_if(qr'openssl','ca-certificates',qr'BuildRequires:');
    $jpp->get_section('package','')->subst(qr'^\%define origin\s+gcj\%{gccsuffix}','%define origin          gcj');
    $jpp->get_section('package','')->subst(qr'^\%define gccver\s.*','%define gccver          4.1.2-alt2'."\n");
    $jpp->get_section('package','')->subst(qr'^\%define gccsuffix\s.*','%define gccsuffix       -4.1'."\n");
    $jpp->get_section('package','')->unshift_body('%define gccrpmsuffix    4.1'."\n");
    $jpp->get_section('package','')->subst_if(qr'gccsuffix','gccrpmsuffix',qr'Requires:\s+(gcc|libgc)');
    $jpp->get_section('package','')->subst(qr'^Requires(triggerin)','#Requires(triggerin)');
    $jpp->get_section('package','devel')->subst_if(qr'gccsuffix','gccrpmsuffix',qr'Requires:\s+(gcc|libgc)');
    $jpp->get_section('package','devel')->subst(qr'^Requires(triggerin)','#Requires(triggerin)');
    $jpp->get_section('package','src')->subst_if(qr'gccsuffix','gccrpmsuffix',qr'Requires:\s+(gcc|libgc)');
    $jpp->get_section('package','src')->subst(qr'^Requires(triggerin)','#Requires(triggerin)');

    foreach my $section ($jpp->get_sections()) {
	if ($section->get_type() eq 'triggerin') {
	    $section->subst_if(qr'gccsuffix','gccrpmsuffix',qr'^\%trigger');
	}
    }


    $jpp->get_section('prep')->push_body('%__subst s,/etc/pki/tls/cert.pem,/usr/share/ca-certificates/ca-bundle.crt, generate-cacerts.pl
# hack: gcc4.1 seems to have no gjavah
for i in Makefile*; do 
%__subst s,gjavah,gjnih, $i
# bootstrap hack; sinjdoc not built yet
%if %{bootstrap}
%__subst s,sinjdoc,gij, $i
%endif
done
');
    $jpp->get_section('install')->push_body('install -d -m755 %buildroot/usr/lib/jvm-exports/%{sdkdir}'."\n");

    $jpp->get_section('files','')->subst(qr'#%ghost','%ghost');
    $jpp->get_section('files','devel')->subst(qr'#%ghost','%ghost');
    # why they intersect... it is better to fix
    $jpp->get_section('files','')->push_body('%dir /usr/lib/jvm-exports/%{sdkdir}'."\n");
    $jpp->get_section('files','devel')->push_body('%dir /usr/lib/jvm-exports/%{sdkdir}'."\n");
    $jpp->get_section('files','devel')->subst(qr'%{python_sitelib}','#%{python_sitelib}');
    $jpp->get_section('files','devel')->push_body('/usr/lib/python*/*'."\n");

#    my @sections=grep {$_->get_type() ne 'triggerin' && !($_->get_type() eq 'postun' && $_->get_package() eq 'plugin')} $jpp->get_sections();
#    $jpp->set_sections(\@sections);
}
