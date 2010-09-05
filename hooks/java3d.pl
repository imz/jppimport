#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    #$jpp->get_section('build')->subst(qr'-Xmx256m','-Xmx512m');
    # TODO: something like 
    # -Djavadoc.maxmemory="128m" in the ant command line
    # implement as an ant patch
}



__END__
