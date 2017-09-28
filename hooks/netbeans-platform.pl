push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->push_body(q!
# macos proxy detection code :(
#+ Requires: /usr/bin/grep
#+ Requires: /usr/sbin/scutil
%add_findreq_skiplist /usr/share/netbeans/platform*/lib/nbexec
!);
#    $spec->get_section('package','')->subst_body_if(qr/\%{nb_platform_ver}/,'{nb_ver}', qr/^Summary:/);
    $spec->get_section('package','')->unshift_body(q!%set_verify_elf_method fhs=relaxed
!);

};

__END__
