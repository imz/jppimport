push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body(q!
# macos proxy detection code :(
#+ Requires: /usr/bin/grep
#+ Requires: /usr/sbin/scutil
%add_findreq_skiplist /usr/share/netbeans/platform*/lib/nbexec
!);
    $jpp->get_section('package','')->subst_if(qr/\%{nb_platform_ver}/,'{nb_ver}', qr/^Summary:/);
    $jpp->get_section('package','')->unshift_body(q!%set_verify_elf_method fhs=relaxed
!);

};

__END__
BuildRequires: felix-framework felix-osgi-core felix-osgi-compendium
    $jpp->get_section('package','')->subst(qr'^Requires: felix','#Requires: felix');
    $jpp->get_section('package','')->subst(qr'^BuildRequires: felix','#BuildRequires: felix');
