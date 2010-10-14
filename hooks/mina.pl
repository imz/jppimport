require 'set_java5.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body("BuildRequires: maven-scm maven2-default-skin\n");
    # with java 5.0
    $jpp->get_section('package','')->unshift_body("BuildRequires: spring spring-core excalibur-avalon-framework easymock-classextension nlog4j spring-beans maven-surefire-provider-junit maven-surefire-provider-junit4
\n");
};

__END__
