#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $alt) = @_;
    $spec->spec_apply_patch(PATCHFILE => 'azureus.spec.diff');
    $spec->get_section('package','')->unshift_body('Requires: java'."\n");
    $spec->get_section('package','')->unshift_body('Conflicts: vuse < 4.2.0.3'."\n");
    $spec->get_section('package','')->unshift_body('Obsoletes: vuse < 4.2.0.3'."\n");
    $spec->get_section('install')->push_body(q!# alt adaptation
sed -i s,JAVA_HOME=/usr/lib/jvm/java-openjdk,JAVA_HOME=/usr/lib/jvm/java,g %buildroot%_bindir/%name
sed -i 's,uname -i,uname -m,' %buildroot%_bindir/%name
!);
};

__END__
