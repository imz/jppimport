#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
};

__END__
# old 5.0
    $jpp->get_section('package','')->unshift_body('BuildRequires: servletapi4 apache-axiom'."\n");
    $jpp->get_section('prep')->push_body(q!
cat project.xml | grep -v '<name>WS-Policy Implementation</name>' > project.xml.0
mv project.xml.0 project.xml
!);

};

