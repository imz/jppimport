#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package')->subst_if(qr'xml-commons-resolver','xml-commons-resolver12',qr'Requires:');

# 6u26 bug :(
#    $jpp->get_section('build')->subst(qr'orbitDeps -a "\$OPTIONS"','orbitDeps -a "$OPTIONS" -j "-Xmx2048m"');
};

