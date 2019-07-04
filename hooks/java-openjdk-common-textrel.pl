#!/usr/bin/perl -w

push @SPECHOOKS,
sub {
    my ($spec,) = @_;
    $spec->get_section('package','')->unshift_body('# from java9/hotspot/make/lib/JvmOverrideFiles.gmk:
# Performance measurements show that by compiling GC related code, we could
# significantly reduce the GC pause time on 32 bit Linux/Unix platforms by
# compiling without the PIC flag (-fPIC on linux).
# See 6454213 for more details.
%if "%_libsuff" != "64"
%set_verify_elf_method textrel=relaxed
%endif
'."\n");
};

__END__
