#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package')->unshift_body('BuildRequires: /bin/ping'."\n");
    # inet :(
    $jpp->get_section('build')->subst(qr'mvn-jpp ','mvn-jpp -Dmaven.test.skip=true ');
}

__END__
