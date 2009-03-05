#!/usr/bin/perl -w

require 'set_target_14.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->subst(qr'carol/carol','carol/ow_carol');
    $jpp->get_section('prep')->subst(qr'rm -f \{\}','mv {} {}.no');
    $jpp->get_section('build')->subst(qr'ln -sf \$\(build-classpath oracle-jdbc-thin','#ln -sf $(build-classpath oracle-jdbc-thin');
    $jpp->get_section('build')->unshift_body(q'
mv externals/classes12.jar.no externals/classes12.jar
');
}

__END__
