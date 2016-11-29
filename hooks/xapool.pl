#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
# for 1.jpp; we are trying 2jpp
#    $spec->get_section('build')->subst(qr'carol/carol','carol/ow_carol');
#    $spec->get_section('prep')->subst(qr'rm -f \{\}','mv {} {}.no');
#    $spec->get_section('build')->subst(qr'ln -sf \$\(build-classpath oracle-jdbc-thin','#ln -sf $(build-classpath oracle-jdbc-thin');
#    $spec->get_section('build')->unshift_body(q'
#mv externals/classes12.jar.no externals/classes12.jar
#');
}

__END__
