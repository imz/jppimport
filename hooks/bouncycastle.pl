#!/usr/bin/perl -w

#set java 6

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
}
__END__
    # tmp hack
    $jpp->get_section('package','')->push_body('Requires: bouncycastle-tsp = %version'."\n");
