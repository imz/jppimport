#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('prep')->push_body(q!find . -name '*.orig' -print -delete!."\n");
};

__END__
