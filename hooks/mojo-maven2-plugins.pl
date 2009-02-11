#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: modello-maven-plugin saxpath'."\n");
    $jpp->get_section('package','')->subst(qr'BuildRequires: batik','BuildRequires: xmlgraphics-batik');

    $jpp->get_section('package','')->subst(qr'BuildRequires: hibernate2','#BuildRequires: hibernate2');
    $jpp->get_section('package','')->subst(qr'BuildRequires: spring2','#BuildRequires: spring2');
    $jpp->get_section('package','')->subst(qr'BuildRequires: spring-beandoc','#BuildRequires: spring-beandoc');
    $jpp->get_section('package','')->subst(qr'BuildRequires: xbean','#BuildRequires: xbean');
    $jpp->get_section('package','')->subst(qr'BuildRequires: xfire','#BuildRequires: xfire');
    $jpp->get_section('package','')->subst(qr'BuildRequires: gmaven','#BuildRequires: gmaven');
};

__END__
2.0.4
    # bug in asm2: 
    # looks like missing group causes ...
    # but it is wise to replace asm-parent to asm-all!
#    $jpp->get_section('package','')->unshift_body('BuildRequires: asm2 mojo-maven2-plugins'."\n");
