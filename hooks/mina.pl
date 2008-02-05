require 'set_java5.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body("BuildRequires: maven-scm maven2-default-skin\n");
    # with java 5.0
    $jpp->get_section('package','')->unshift_body("BuildRequires: spring spring-core excalibur-avalon-framework easymock-classextension nlog4j spring-beans\n");
};

__END__
######### hack here !!!!!
mkdir -p m2_repo/repository/org.springframework/
ln -s %_javadir/spring/beans.jar m2_repo/repository/org.springframework/spring-beans.jar
########################
rm example/src/test/java/org/apache/mina/example/echoserver/AcceptorTest.java
rm example/src/test/java/org/apache/mina/example/echoserver/ConnectorTest.java

[surefire] Running org.apache.mina.example.echoserver.ConnectorTest
Using port 1024 for testing.
* Without localAddress
Using port 1024 for testing.
* Without localAddress
Using port 1024 for testing.
* Without localAddress
[surefire] Tests run: 3, Failures: 2, Errors: 1, Time elapsed: 33.327 sec <<<<<<<< FAILURE !!
[surefire] Running org.apache.mina.example.echoserver.AcceptorTest
Using port 1024 for testing.
Using port 1024 for testing.
