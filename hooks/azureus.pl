#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('Conflicts: vuse < 4.2.0.3'."\n");
    $jpp->get_section('install')->push_body(q!# alt adaptation
sed -i s,JAVA_HOME=/usr/lib/jvm/java-openjdk,JAVA_HOME=/usr/lib/jvm/java,g %buildroot%_bindir/%name
sed -i 's,uname -i,uname -m,' %buildroot%_bindir/%name
!);
};

__END__
