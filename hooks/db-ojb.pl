#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('db-ojb-1.0.4-alt-java7.patch',STRIP=>1);
    $jpp->get_section('build')->unshift_body('export LANG=en_US.ISO8859-1'."\n");
    $jpp->get_section('build')->unshift_body('export ANT_OPTS="$ANT_OPTS -Xms512m -Xmx2048m -Xss1m"'."\n");

}
__END__
    #$jpp->get_section('package','')->subst('village','db-torque-village');
