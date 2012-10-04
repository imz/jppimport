#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('install')->unshift_body_before(qr'_sysconfdir',
						    q'# due to maven3fragmentsdir move
    mkdir -p $RPM_BUILD_ROOT%{_sysconfdir}
');
    # vfs2
    $jpp->get_section('prep')->push_body(q!
sed -i -e 's,org\.apache\.commons\.vfs\.,org.apache.commons.vfs2.,g' `grep -rl org.apache.commons.vfs. .`
!);

    # Too early; should test first

#+Provides:       avalon-framework = %{epoch}:%{framework_version}-%{release}
#+Obsoletes:      avalon-framework < %{epoch}:%{framework_version}-%{release}
    $jpp->get_section('package','avalon-framework')->exclude_body(qr'^(?:Provides|Obsoletes):\s+avalon-framework');
    $jpp->get_section('files','avalon-framework')->exclude_body(qr'^\%{_javadir}/avalon-framework');
}
__END__
DONE:
#+Provides:       avalon-logkit = %{epoch}:%{containerkit_version}-%{release}
#+Obsoletes:      avalon-logkit < %{epoch}:%{containerkit_version}-%{release}
    $jpp->get_section('package','avalon-logkit')->exclude_body(qr'^(?:Provides|Obsoletes):\s+avalon-logkit');
    $jpp->get_section('files','avalon-logkit')->exclude_body(qr'^\%{_javadir}/avalon-logkit');
