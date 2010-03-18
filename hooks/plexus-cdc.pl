#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    warn "added Requires: qdox16-poms -- temporary hack until qdox will be updated to 1.10\n";
    $jpp->get_section('package','')->unshift_body('Requires: qdox16-poms'."\n");
}

__END__
