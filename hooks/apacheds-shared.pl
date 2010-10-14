#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
};

__END__
# insert at build (0.9.12-alt1_2jpp6)
install -Dm644 directory-project-12/pom.xml $MAVEN_REPO_LOCAL/org/apache/directory/project/project/12/project-12.pom
install -Dm644  %{SOURCE4} $MAVEN_REPO_LOCAL/org/apache/apache-jar-resource-bundle/1.4/apache-jar-resource-bundle-1.4.jar
