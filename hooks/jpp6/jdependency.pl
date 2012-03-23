#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    #$jpp->add_patch('',STRIP=>1);
    $jpp->get_section('prep')->push_body(q!# asm >= 3.3
sed -i -e 's,<groupId>asm</groupId>,<groupId>org.objectweb.asm</groupId>,' pom.xml!."\n");
};

__END__
