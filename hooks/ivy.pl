push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # TODO: fix cli!
    $jpp->get_section('package','')->unshift_body("BuildRequires: jakarta-commons-cli-1\n");
    $jpp->get_section('prep')->push_body("rm -r test/java/fr/jayasoft/ivy/xml/XmlModuleDescriptorWriterTest.java\n");
};
