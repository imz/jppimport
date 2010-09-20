#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    #$jpp->get_section('build')->subst(qr'-Xmx256m','-Xmx512m');
    # -Djavadoc.maxmemory="128m" in the ant command line
    # implemented as an alt-specific ant patch
    $jpp->get_section('build')->subst(qr'\%ant ','%ant -Dant.javadoc.maxmemory=512m ');
}



__END__
