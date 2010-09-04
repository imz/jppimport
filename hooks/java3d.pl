#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->subst(qr'-Xmx256m','-Xmx512m');
}



__END__
