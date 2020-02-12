#!/usr/bin/perl -w

push @SPECHOOKS,
sub {
    my ($spec,) = @_;
    $spec->get_section('package','')->unshift_body(q!%set_verify_elf_method relaxed!."\n");
    $spec->get_section('package','')->push_body(q!ExclusiveArch: %ix86 x86_64!."\n");
    $spec->get_section('prep')->push_body(q!# alt build fixes
sed -i 's, -lnsl,,' j3d-core/src/native/ogl/build*.xml
sed -i '/GLsizeiptr/d;/GLintptr/d' j3d-core/src/native/ogl/gldefs.h!."\n");
};

__END__
