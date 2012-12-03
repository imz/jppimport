#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    #$jpp->add_patch('',STRIP=>1);
    #Obsoletes:        jakarta-%{short_name} < 1:1.2.1-2
    $jpp->get_section('package','')->subst_body_if(qr'1.2.1-2','1.2.2',qr'Obsoletes:');
    $jpp->get_section('package','')->push_body(q!Conflicts:	jakarta-%{short_name} < 1:%version!."\n");
};

__END__
