#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: xdoclet'."\n");
    $jpp->get_section('build')->unshift_body('export ANT_OPTS="$ANT_OPTS -Xms512m -Xmx2048m -Xss1m"'."\n");

    #$jpp->get_section('package','')->subst('village','db-torque-village');
}
__END__
