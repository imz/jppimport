#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->unshift_body('%filter_from_requires /^.usr.bin.run/d'."\n");
};

__END__
