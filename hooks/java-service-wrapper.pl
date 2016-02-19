#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('prep')->push_body(q!# -Wl,as-needed
perl -i -npe 's,(\$[({]COMPILE[)}](?: -pthread)?) -lm(.*)$,$1$2 -lm,' src/c/Makefile-linux-*!."\n");
};

__END__
