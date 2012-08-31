#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body('Provides: kxml2 = %version-%release'."\n");
    $jpp->get_section('package','')->push_body('Conflicts: kxml2 < %version-%release'."\n");
    $jpp->get_section('package','')->push_body('Obsoletes: kxml2 < %version-%release'."\n");
    $jpp->get_section('install')->push_body(q!# jpp compat - just in case
ln -s kxml.jar %buildroot%_javadir/kxml2.jar!."\n");
};

__END__
