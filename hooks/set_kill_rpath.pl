#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->get_section('install')->push_body(q!# kill rpath
for i in `find %buildroot{%_bindir,%_libdir,/usr/libexec,/usr/lib,/usr/sbin} -type f -perm -111 \! -name '*.la' `; do
	chrpath -d $i ||:
done!."\n");
    $spec->get_section('package','')->unshift_body('BuildRequires: chrpath'."\n");
};

__END__
