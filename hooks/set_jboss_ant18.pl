#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('prep')->unshift_body2_after(q!
# ant 1.8 support hack
for i in `find . -name buildmagic.ent`; do sed -i 's,fail unless="buildmagic.ant.compatible",fail if="never",' $i; done
!,qr'\%setup');
};

