#!/usr/bin/perl -w

require 'set_target_14.pl';
require 'set_bin_755.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # hack; not needed
    #$jpp->get_section('package','')->push_body("Provides: osgi(org.apache.xerces) = %version\n");
    $jpp->get_section('package','')->unshift_body("BuildRequires: xml-commons-resolver\n");

    $jpp->get_section('package','')->push_body("Provides: xerces-j = %version-%release\n");
    $jpp->get_section('package','')->push_body("Obsoletes: xerces-j <= 2.9.0-alt4\n");
    $jpp->get_section('install')->push_body('ln -s xerces-j2.jar $RPM_BUILD_ROOT%_javadir/xerces-j.jar'."\n");
    $jpp->get_section('files','')->push_body('%_javadir/xerces-j.jar'."\n");
    
    # TODO: replace version and patches...

}

__END__
''
51a62
Source33:        xercesImpl-%{version}.pom
build---
 ln -sf $(build-classpath xalan-j2) xalan.jar
+ln -sf $(build-classpath xalan-j2-serializer) serializer.jar
install---
%add_to_maven_depmap xerces xercesImpl %{version} JPP %{name}

# pom
install -d -m 755 $RPM_BUILD_ROOT%{_datadir}/maven2/poms
install -pm 644 %{SOURCE33} \
    $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.%{name}.pom

files ---
%{_datadir}/maven2/poms/*
%{_mavendepmapfragdir}
---files
s.doc ISSUES LICENSE* NOTICE README STATUS TODO,doc LICENSE* NOTICE README,
