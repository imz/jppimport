#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: xdoclet'."\n");
    $jpp->get_section('build')->unshift_body('export ANT_OPTS="$ANT_OPTS -Xms512m -Xmx2048m -Xss1m"'."\n");
}
__END__
note: ojb does not support new db-torque 3.3, but there is no new releases yet :(
189a190,194
> pushd lib
> mv torque-gen-3.1.1.jar.no db-torque-gen.jar
> popd
> 
222c227
< ln -sf $(build-classpath db-torque-gen) .
---
> #ln -sf $(build-classpath db-torque-gen) .

