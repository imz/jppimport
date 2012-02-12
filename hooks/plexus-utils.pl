#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # strange hack
    $jpp->get_section('install')->subst('cp -pr target/site/apidocs','cp -pr target/target/site/apidocs');
}
__END__
    $jpp->get_section('package','')->subst_if('mojo-maven2-plugin-shade','maven2-plugin-shade',qr'Requires:');
