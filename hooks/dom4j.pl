#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec,) = @_;
    $spec->get_section('build')->unshift_body(q!export LANG=en_US.ISO8859-1!."\n");
};

1;
__END__
