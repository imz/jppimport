#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
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

    ## alt bug #18941 :)
    $jpp->get_section('install')->push_body(q'## alt bug #18941 :)
find %buildroot%_datadir -name README.txt -delete
');

    # E: Версия >='0:1.0.1-0.a.1' для 'jta' не найдена
    $jpp->get_section('package','')->subst_if(qr'0:1.0.1-0.a.1','0:1.0.1',qr'Requires:');

};

__END__

    $jpp->get_section('package','')->subst('BuildRequires: jboss','#BuildRequires: jboss');
    ######## jboss ################
# disable jboss integration 
rm -rf src/com/mysql/jdbc/integration/jboss
rm src/testsuite/regression/ConnectionRegressionTest.java
rm src/testsuite/regression/DataSourceRegressionTest.java
