#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('install')->subst(qr's/\@VERSION\@/\%{version_full}-brew','s/@VERSION@/%{version}-brew');
}

__END__
5.0
    $jpp->get_section('install')->unshift_body('
[ -f $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.slide-webdavlib.pom ] && exit 1;
mkdir -p $RPM_BUILD_ROOT%_datadir/maven2/poms/
cat > $RPM_BUILD_ROOT%_datadir/maven2/poms/JPP.slide-webdavlib.pom <<END
<project>
  <modelVersion>4.0.0</modelVersion>
  <groupId>slide</groupId>
  <artifactId>slide-webdavlib</artifactId>
  <version>2.1</version>
<!-- todo: check/add poms to repository
  <dependencies>
    <dependency> 
      <groupId>commons-httpclient</groupId> 
      <artifactId>commons-httpclient</artifactId> 
      <version>2.0.2</version> 
    </dependency>
    <dependency> 
      <groupId>jdom</groupId> 
      <artifactId>jdom</artifactId> 
      <version>1.0</version> 
    </dependency> 
    <dependency> 
      <groupId>de.zeigermann.xml</groupId> 
      <artifactId>xml-im-exporter</artifactId> 
      <version>1.1</version> 
    </dependency> 
  </dependencies> 
-->
</project>
END
');

    $jpp->get_section('install')->push_body('
pushd $RPM_BUILD_ROOT%{_javadir}/%{base_name}
for jar in jakarta-slide-webdavclient-*.jar; do ln -sf ${jar} `echo $jar| sed  "s|jakarta-slide-webdavclient-|slide-|g"`; done
popd

%add_to_maven_depmap slide slide-webdavlib %{version} JPP/slide jakarta-slide-webdavclient-webdavlib
');

    $jpp->get_section('files','')->unshift_body('%_datadir/maven2/poms/*.pom
%{_mavendepmapfragdir}
');

    $jpp->add_section('post','')->unshift_body('%update_maven_depmap
');
    $jpp->add_section('postun','')->unshift_body('%update_maven_depmap
');

