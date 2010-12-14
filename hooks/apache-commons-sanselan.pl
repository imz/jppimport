#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package')->unshift_body('BuildRequires: velocity15'."\n");
}

__END__
