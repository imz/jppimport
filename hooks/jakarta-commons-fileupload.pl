#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # they create broken symlink
    $jpp->del_section('post','javadoc');
    $jpp->del_section('postun','javadoc');
}
__END__
