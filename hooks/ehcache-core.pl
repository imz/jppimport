#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: hsqldb'."\n");
    $jpp->get_section('prep')->push_body(q!
sed -i 's,<filter>${project.build.directory}/filter.properties</filter>,<filter>src/assemble/filter.properties</filter>,' pom.xml!."\n");
};

__END__
