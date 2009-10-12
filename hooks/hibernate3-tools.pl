#!/usr/bin/perl -w

require 'set_eclipse_core_plugins.pl';
require 'set_target_15.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
}

__END__
bug in 5.0 to report:
--- hibernate3-tools.spec.0	2009-08-25 18:56:36 +0000
+++ hibernate3-tools.spec	2009-08-25 18:58:55 +0000
@@ -129,9 +129,9 @@
 %patch0 -b .sav0
 %patch1 -b .sav1
 # temporarily patch to hibernate-3.2.0.cr2
-%patch2 -b .sav2
+#%patch2 -b .sav2
 %patch3 -b .sav3
-%patch4 -b .sav4
+#%patch4 -b .sav4
 %patch5 -b .sav5
 # temporarily remove for hibernate-3.2.0.cr2
 rm src/test/org/hibernate/tool/hbmlint/FakeNonLazy.java
