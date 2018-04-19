#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('prep')->push_body(q!# e2k support
(cd src/c; cp Makefile-linux-ppc64le-64.make Makefile-linux-e2k-64.make)
# e2k: lcc is not --pedantic
perl -i -npe 's,--pedantic,,' src/c/Makefile-linux-*
# -Wl,as-needed
perl -i -npe 's,(\$[({]COMPILE[)}](?: -pthread)?) -lm(.*)$,$1$2 -lm,' src/c/Makefile-linux-*!."\n");
};

__END__
