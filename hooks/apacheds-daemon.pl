#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body("BuildRequires: maven-surefire-plugin maven-surefire-provider-junit4\n");
};

__END__
daemonadded:
install -Dm644 directory-project-12/pom.xml $MAVEN_REPO_LOCAL/org/apache/directory/project/project/12/project-12.pom
install -Dm644 %{SOURCE5} $MAVEN_REPO_LOCAL/org/apache/apache-jar-resource-bundle/1.4/apache-jar-resource-bundle-1.4.jar

daemon10added: for maven 2.0.8
install -Dm644 %{SOURCE1} m2_repo/repository/org/apache/directory/build/1.0.5/build-1.0.5.pom
