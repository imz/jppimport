#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec,) = @_;
    $spec->get_section('build')->unshift_body(q!
# due to javadoc x86_64 out of memory
subst 's,maxmemory="256m",maxmemory="512m",' build.xml
!);

}

__END__
