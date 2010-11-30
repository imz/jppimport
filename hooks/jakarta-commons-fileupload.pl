#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
}
__END__
5.0
    # they create broken symlink
    $jpp->del_section('post','javadoc');
    $jpp->del_section('postun','javadoc');
