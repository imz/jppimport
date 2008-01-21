#require 'set_target_14.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # TODO: lucene1
    $jpp->get_section('package','')->unshift_body("BuildRequires: checkstyle jakarta-commons-beanutils jakarta-commons-logging regexp\n");
    $jpp->get_section('package','')->subst_if('lucene','lucene1', qr'Requires:');

};

# TODO: report (no bugzilla yet)
__END__
+ build-jar-repository external ant antlr checkstyle commons-beanutils commons-logging junit log4j lucene-demos lucene regexp xerces-j2 xml-commons-apis
/usr/bin/build-jar-repository: error: Could not find checkstyle Java extension for this JVM
/usr/bin/build-jar-repository: error: Could not find commons-beanutils Java extension for this JVM
/usr/bin/build-jar-repository: error: Could not find commons-logging Java extension for this JVM
/usr/bin/build-jar-repository: error: Could not find regexp Java extension for this JVM
/usr/bin/build-jar-repository: error: Some specified jars were not found for this jvm
error: Bad exit status from /usr/src/tmp/rpm-tmp.25444 (%build)
