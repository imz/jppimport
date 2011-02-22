#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
}

__END__
158c158
< %patch3 -b .sav
---
> %patch3 -b .sav -p2
