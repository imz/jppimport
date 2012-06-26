push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # todo: disable tests! Out of memory!
    $jpp->get_section('package','')->unshift_body("BuildRequires: maven-scm maven2-default-skin\n");
    # no! reserved for xmlrpc2
#    $jpp->get_section('install')->unshift_body_after(qr'add_to_maven_depmap','%add_to_maven_depmap xmlrpc xmlrpc %{version} JPP/%{name} xmlrpc'."\n");

};

__END__
#============================================================= 
# info; 2nd hacks for xmlrpc3
3a4
> BuildRequires: xmlrpc3-server xmlrpc3-client
154a156,157
> # hack due to test skip
> subst 's,<module>tests</module>,,' pom.xml
>
158a162,185
> mvn-jpp \
>   -e \
>   -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
>   -Djava.home=%{_jvmdir}/java/jre \
>   -Dmaven2.jpp.depmap.file=%{SOURCE1} \
>   install:install-file -DgroupId=org.apache.xmlrpc -DartifactId=xmlrpc-common \
>   -Dversion=3.0 -Dpackaging=jar -Dfile=$(build-classpath xmlrpc3-common)
>
> mvn-jpp \
>   -e \
>   -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
>   -Djava.home=%{_jvmdir}/java/jre \
>   -Dmaven2.jpp.depmap.file=%{SOURCE1} \
>   install:install-file -DgroupId=org.apache.xmlrpc -DartifactId=xmlrpc-server \
>   -Dversion=3.0 -Dpackaging=jar -Dfile=$(build-classpath xmlrpc3-server)
>
> mvn-jpp \
>   -e \
>   -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
>   -Djava.home=%{_jvmdir}/java/jre \
>   -Dmaven2.jpp.depmap.file=%{SOURCE1} \
>   install:install-file -DgroupId=org.apache.xmlrpc -DartifactId=xmlrpc-client \
>   -Dversion=3.0 -Dpackaging=jar -Dfile=$(build-classpath xmlrpc3-client)
>
166a194
>   -Dmaven.test.skip=true \
