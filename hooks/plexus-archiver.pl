#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
}
__END__
    # for a7
    $jpp->get_section('prep')->push_body('rm src/test/java/org/codehaus/plexus/archiver/zip/ZipArchiverTest.java'."\n");
