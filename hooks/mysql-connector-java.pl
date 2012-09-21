#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # does not exclude export JAVA_HOME=(1.5), does not use target=5, it is required for odbc 3.0
    $jpp->get_section('package','')->unshift_body(q'BuildRequires: java-1.5.0-devel'."\n");
    $jpp->get_section('install')->unshift_body(q'JAVA_HOME=/usr/lib/jvm/java-1.5.0'."\n");
    $jpp->get_section('build')->unshift_body(q'JAVA_HOME=/usr/lib/jvm/java-1.5.0'."\n");
    $jpp->get_section('build')->subst(qr'build-classpath jdbc-stdext jta junit slf4j commons-logging.jar',
				      'build-classpath jdbc-stdext jta junit slf4j commons-logging.jar ant-contrib');


    ##### mysql-connector-jdbc ##################
    $jpp->get_section('package','')->push_body(q'
Provides: mysql-connector-jdbc = %{epoch}:%version-%release
Obsoletes: mysql-connector-jdbc < %version
');
    $jpp->get_section('install')->push_body(q'
pushd %buildroot%_javadir
ln -s mysql-connector-java.jar mysql-connector-jdbc.jar
popd
');
    $jpp->get_section('files')->push_body(q'%_javadir/mysql-connector-jdbc.jar
');
    ##########################################
};

__END__
