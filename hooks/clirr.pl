#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    # todo: report?
    $jpp->get_section('package','')->unshift_body('BuildRequires: sf-maven-plugins'."\n");
    $jpp->get_section('package','')->unshift_body('
#[JPackage-announce] [RPM (1.7)] clirr-0.6-3jpp
# does not matter, as we use dependency on maven-plugins
BuildRequires:  maven-plugins-base
BuildRequires:  maven-plugin-changes
BuildRequires:  maven-plugin-developer-activity
BuildRequires:  maven-plugin-file-activity
BuildRequires:  maven-plugin-jdepend
BuildRequires:  maven-plugin-jxr
BuildRequires:  maven-plugin-license
BuildRequires:  maven-plugin-linkcheck
BuildRequires:  maven-plugin-multiproject
BuildRequires:  maven-plugin-tasklist
BuildRequires:  maven-plugin-test
BuildRequires:  maven-plugin-xdoc
');

    $jpp->get_section('build')->unshift_body_before(q!
# dirty hack that finally works
mkdir -p .maven/repository/JPP/plugins/
ln -s /usr/share/java/maven-plugins/maven-javaapp-plugin.jar .maven/repository/JPP/plugins/
!, qr'^maven -Dmaven');

}
__END__
    # is it really needed?
    # bug to report: obsolete maven-javaapp-plugin version 1.3.1?
    $jpp->get_section('prep')->push_body(q!%__subst s,1.3.1,1.4, %{SOURCE4}
!);

    $jpp->get_section('prep','')->push_body('
%__subst s,maven-javaapp-plugin-1.3.1,maven-javaapp-plugin-1.4, core/project.xml'."\n");
