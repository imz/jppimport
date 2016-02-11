#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->unshift_body('BuildRequires: gcc-c++'."\n");
};

__END__
