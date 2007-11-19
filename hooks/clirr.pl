#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: sf-maven-plugins'."\n");
    # bug to report: obsolete maven-javaapp-plugin version 1.3.1
    $jpp->get_section('prep')->push_body(q!%__subst s,1.3.1,1.4, %{SOURCE4}
!);

}
__END__
    $jpp->get_section('prep','')->push_body('
%__subst s,maven-javaapp-plugin-1.3.1,maven-javaapp-plugin-1.4, core/project.xml'."\n");
