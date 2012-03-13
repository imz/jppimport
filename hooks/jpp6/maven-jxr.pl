#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    #$jpp->get_section('package','')->subst('velocity14','velocity');
    #$jpp->get_section('package','')->unshift_body('BuildRequires: velocity14');
    # TODO: enable if this req will cause trouble
    #$jpp->get_section('package','')->subst(qr'^Requires:\s+velocity14','#Requires: velocity14');
};

__END__
