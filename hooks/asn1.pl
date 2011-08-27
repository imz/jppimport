#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('asn1-0.3.3-alt-project.xml.patch', STRIP=>1);
    $jpp->get_section('build')->unshift_body_before( qr'^maven',q!
mkdir -p .maven/repository/JPP/plugins/
ln -s /usr/share/java/maven-plugins/maven-site-plugin.jar .maven/repository/JPP/plugins/
!);
    # they use SNAPSHOT API :(
    $jpp->get_section('package','')->unshift_body('BuildRequires: jakarta-commons-primitives >= 1.1'."\n");
    $jpp->get_section('package','')->subst(qr`Requires:\s*mina`,q!Requires: mina-jdk14 = 0.8.0!);
    $jpp->get_section('prep')->unshift_body(q!
%__subst 's,<jar>mina.jar</jar>,<jar>mina-jdk14.jar</jar>,' %{SOURCE4}
!);

}

__END__
