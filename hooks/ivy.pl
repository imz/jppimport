push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('prep')->push_body("rm -r test/java/fr/jayasoft/ivy/xml/XmlModuleDescriptorWriterTest.java\n");
};
