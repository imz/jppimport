#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    # 2.2-2
    $spec->get_section('package','')->unshift_body('BuildRequires: xpp3-minimal'."\n");
    $spec->get_section('package','')->unshift_body('Requires: xpp3-minimal'."\n");
};

__END__
