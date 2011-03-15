#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # 6.0
    $jpp->get_section('package','')->subst(qr'\%bcond_with\s+jdk6','%bcond_without jdk6');
}
__END__
