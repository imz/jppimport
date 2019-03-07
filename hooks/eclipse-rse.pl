#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->get_section('package','')->unshift_body('BuildRequires: perl(Authen/PAM.pm)'."\n");
};

__END__
