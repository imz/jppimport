#!/usr/bin/perl -w

#require 'set_add_fc_osgi_manifest.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
};

__END__

    # takes over asm2 and breaks pure asm2 builds such as:
    # jakarta-commons-javaflow
    # apache-commons-jci
    #%add_to_maven_depmap asm asm %{version} JPP/%{name} asm
    $jpp->get_section('install')->exclude(qr'add_to_maven_depmap asm asm');

    $jpp->get_section('install')->push_body(q!
# poms use asm group now - incompatible with oweb-asm 3.2 and confilcts with asm2 :( 
# seems like we need to patch asm2 to have asm2 group.
sed -i -e 's,<groupId>asm</groupId>,<groupId>org.objectweb.asm</groupId>,g' %buildroot/usr/share/maven2/poms/JPP.objectweb-asm-asm*
!);

