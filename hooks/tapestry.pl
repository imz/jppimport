push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('prep')->push_body(q!
rm ./framework/src/test/org/apache/tapestry/util/io/TestBinaryDumpOutputStream.java
!);

}
