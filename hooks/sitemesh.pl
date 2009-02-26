push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body(q!BuildRequires: velocity-tools
!);
    # merged in 1.3
    $jpp->get_section('prep')->subst(qr!velocity-tools-view!,'velocity-tools');

    $jpp->get_section('prep')->push_body(q!
# dirty hack :(
rm lib/jflex.jar
mv lib/jflex.jar.no lib/jflex.jar
!);

}
