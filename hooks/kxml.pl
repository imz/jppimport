#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->push_body('Provides: kxml2 = %version-%release'."\n");
    $spec->get_section('package','')->push_body('Conflicts: kxml2 < %version-%release'."\n");
    $spec->get_section('package','')->push_body('Obsoletes: kxml2 < %version-%release'."\n");
    $spec->get_section('install')->push_body(q!# jpp compat - just in case
ln -s kxml.jar %buildroot%_javadir/kxml2.jar!."\n");
};

__END__
