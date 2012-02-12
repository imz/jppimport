#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # 6.0
    $jpp->get_section('package','')->subst(qr'\%bcond_with\s+jdk6','%bcond_without jdk6');

    # Too early; should test first

#+Provides:       avalon-logkit = %{epoch}:%{containerkit_version}-%{release}
#+Obsoletes:      avalon-logkit < %{epoch}:%{containerkit_version}-%{release}
    $jpp->get_section('package','avalon-logkit')->exclude_body(qr'^(?:Provides|Obsoletes):\s+avalon-logkit');
#+Provides:       avalon-framework = %{epoch}:%{framework_version}-%{release}
#+Obsoletes:      avalon-framework < %{epoch}:%{framework_version}-%{release}
    $jpp->get_section('package','avalon-framework')->exclude_body(qr'^(?:Provides|Obsoletes):\s+avalon-framework');

# %files avalon-logkit
# %{_javadir}/%{name}/avalon-logkit*
#+%{_javadir}/avalon-logkit*
#+
# %files avalon-framework
# %{_javadir}/%{name}/avalon-framework-%{framework_version}.jar
# %{_javadir}/%{name}/avalon-framework.jar
#+%{_javadir}/avalon-framework-%{framework_version}.jar
#+%{_javadir}/avalon-framework.jar
    $jpp->get_section('files','avalon-logkit')->exclude_body(qr'^\%{_javadir}/avalon-logkit');
    $jpp->get_section('files','avalon-framework')->exclude_body(qr'^\%{_javadir}/avalon-framework');
}
__END__
