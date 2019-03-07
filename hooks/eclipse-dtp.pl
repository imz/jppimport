#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec,) = @_;
    $spec->get_section('package')->subst_body_if(qr'xml-commons-resolver','xml-commons-resolver12',qr'Requires:');


};

__END__
+    $spec->get_section('package','')->unshift_body('BuildRequires: eclipse-emf-sdk'."\n");


--- eclipse-dtp.spec	2012-09-28 19:50:42.000000000 +0300
+++ eclipse-dtp.spec	2012-09-28 20:16:15.000000000 +0300
@@ -1,3 +1,5 @@
+%def_disable lucene3
+
 # BEGIN SourceDeps(oneline):
 BuildRequires: unzip
 # END SourceDeps(oneline)
@@ -160,17 +162,17 @@
 popd
 
 %build
-OPTIONS="-DjavacTarget=1.5 -DjavacSource=1.5 -DforceContextQualifier=%{qualifier}"
+OPTIONS="-DjavacTarget=1.5 -DjavacSource=1.5 -DforceContextQualifier=%{qualifier} -Dtycho.targetPlatform=%_libdir/eclipse"
 
 # build all features except for documentation and SDK features TODO: build everything
 eclipse-pdebuild -f org.eclipse.datatools.modelbase.feature \
-  -d "emf gef" -o `pwd`/orbitDeps -a "$OPTIONS"
+  -d "emf emf-sdk gef" -o `pwd`/orbitDeps -a "$OPTIONS"
 eclipse-pdebuild -f org.eclipse.datatools.connectivity.feature \
-  -d "emf gef" -o `pwd`/orbitDeps -a "$OPTIONS"
+  -d "emf emf-sdk gef" -o `pwd`/orbitDeps -a "$OPTIONS"
 eclipse-pdebuild -f org.eclipse.datatools.sqldevtools.feature \
-  -d "emf gef" -o `pwd`/orbitDeps -a "$OPTIONS"
+  -d "emf emf-sdk gef" -o `pwd`/orbitDeps -a "$OPTIONS"
 eclipse-pdebuild -f org.eclipse.datatools.enablement.feature \
-  -d "emf gef" -o `pwd`/orbitDeps -a "$OPTIONS"
+  -d "emf emf-sdk gef" -o `pwd`/orbitDeps -a "$OPTIONS"
 
 %install
 install -d -m 755 %{buildroot}%{eclipse_dropin}
@@ -195,8 +197,13 @@
 pushd %{buildroot}%{eclipse_dropin}/dtp-sqldevtools/eclipse/plugins
 rm net.sourceforge.lpg.lpgjavaruntime_*.jar
 ln -s ../../../../../java/lpgjavaruntime.jar net.sourceforge.lpg.lpgjavaruntime_1.1.0.jar
-rm org.apache.lucene.core_3.5.0.v20120319-2345.jar
+%if_enabled lucene3
+rm -f org.apache.lucene.core_3.5.0.v20120319-2345.jar
 ln -s  %{_javadir}/lucene.jar org.apache.lucene.core_3.5.0.v20120319-2345.jar
+%else
+rm -f org.apache.lucene.core_2.9.1.v201101211721.jar
+ln -s  %{_javadir}/lucene.jar org.apache.lucene.core_2.9.1.v201101211721.jar
+%endif
 popd
 
 %files
