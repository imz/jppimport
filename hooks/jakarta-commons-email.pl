#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # tests hang in sandbox :(
    #$jpp->get_section('build')->subst(qr'^\s*maven(?=\s|$)','maven -Dmaven.test.skip=true ');
    $jpp->get_section('prep')->push_body('# tests hang in sandbox :(
rm src/test/org/apache/commons/mail/EmailTest*
rm src/test/org/apache/commons/mail/HtmlEmailTest*
rm src/test/org/apache/commons/mail/SendWithAttachmentsTest*
');

};

__END__
