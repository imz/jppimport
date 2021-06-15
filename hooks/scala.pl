#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->get_section('package','')->unshift_body('%filter_from_requires /osgi(org.apache.ant*/d'."\n");
};

__END__
