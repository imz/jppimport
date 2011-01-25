#!/usr/bin/perl -w

# 6.0 hook
push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body('BuildRequires: jstl'."\n");
    $jpp->get_section('package','')->push_body('Requires: myfaces-core-api-parent >= %version-%release'."\n");

    $jpp->add_section('package','parent')->push_body(q!Group: Development/Java
Summary: Parent pom for %name
Provides: myfaces-core-api-parent = %version-%release
Obsoletes: myfaces-core11-api-parent < %version-%release
# pom dependency on jstl:jstl:jar:1.2
Requires: jstl

%description parent
%summary parent

!);
    $jpp->add_section('files','')->push_body(q!%exclude %{_datadir}/maven2/poms/JPP.myfaces-master.pom
!);

    $jpp->add_section('files','parent')->push_body(q!%{_datadir}/maven2/poms/JPP.myfaces-master.pom
!);
}

__END__
