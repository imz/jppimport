#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->get_section('package','')->push_body('# jpackage deprecations
Conflicts: xml-commons-apis12 < 0:1.2.05
Obsoletes: xml-commons-apis12 < 0:1.2.05
Conflicts: xml-commons-jaxp-1.1-apis < 0:1.3.05
Obsoletes: xml-commons-jaxp-1.1-apis < 0:1.3.05
Conflicts: xml-commons-jaxp-1.2-apis < 0:1.3.05
Obsoletes: xml-commons-jaxp-1.2-apis < 0:1.3.05
Conflicts: xml-commons-jaxp-1.3-apis < 0:1.3.05
Obsoletes: xml-commons-jaxp-1.3-apis < 0:1.3.05
Conflicts: xml-commons-jaxp-1.4-apis < %version-%release
Obsoletes: xml-commons-jaxp-1.4-apis < %version-%release
'."\n");
};

__END__
