#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # jpp5 bug to report (requires quartz instead of quartz16)
    $jpp->get_section('package','demo')->subst_if('quartz ','quartz16 ',qr'^Requires:');

    $jpp->get_section('package','')->push_body('
# nothing but examples
%add_findreq_skiplist %_datadir/%name-%version/bin/*
%add_findprov_skiplist %_datadir/%name-%version/bin/*
');

#  -Dskip.checkstyle for checkstyle4/5 conflict
}

__END__
--- quartz16.spec~      2012-08-14 16:22:35.938993026 +0000
+++ quartz16.spec       2012-08-14 16:34:25.272361415 +0000
@@ -159,7 +159,8 @@
 %patch0 -b .sav0
 
 %build
-ant -Dant.build.javac.source=1.5 -Dant.build.javac.target=1.5
+ant -Dant.build.javac.source=1.5 -Dant.build.javac.target=1.5 -Dskip.checkstyle=true
+
 %install
 
 # jars
