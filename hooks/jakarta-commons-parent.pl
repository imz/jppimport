#!/usr/bin/perl -w

push @SPECHOOKS, 

sub  {
    my ($jpp, $alt) = @_;
    # TODO: breaks the build of mojo-maven2-plugins
    $jpp->get_section('package','')->subst(qr'^Requires:\s+mojo-maven2-plugin','#Requires: mojo-maven2-plugin');

};
__END__
