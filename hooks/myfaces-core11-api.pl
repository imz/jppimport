#!/usr/bin/perl -w

# 6.0 hook
push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('prep')->push_body(q!# alt; aspectj 1.5.4
sed -i 's,<groupId>aspectj</groupId>,<groupId>org.aspectj</groupId>,' api/pom.xml
!);
}

__END__
