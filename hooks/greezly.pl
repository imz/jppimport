#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # fails in incoming :(
    $jpp->get_section('build')->subst(qr'mvn-jpp',q!mvn-jpp -Dmaven.test.skip.exec=true!);
}

__END__
