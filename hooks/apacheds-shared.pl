#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
};

__END__
# jpp 5

    $jpp->add_patch('apacheds-shared-0.9.12-alt-use-maven2-plugin-shade.patch',STRIP=>1);
    $jpp->get_section('package','')->subst_if('mojo-maven2-plugin-shade','maven2-plugin-shade',qr'Requires:');

# ?
#    $jpp->get_section('package','')->push_body('BuildRequires: maven2-plugin-shade'."\n");
    # to fix apacheds build due to shadowed junit
    $jpp->get_section('build')->unshift_body_after(qr'rm -rf META-INF',
'# alt; remove embedded junit
rm -rf junit org/junit org/hamcrest
# end alt
');

    $jpp->get_section('package','')->subst_if('jakarta-commons-collections32','jakarta-commons-collections',qr'Requires:');

# insert at build (0.9.12-alt1_2jpp6)
install -Dm644 directory-project-12/pom.xml $MAVEN_REPO_LOCAL/org/apache/directory/project/project/12/project-12.pom
install -Dm644  %{SOURCE4} $MAVEN_REPO_LOCAL/org/apache/apache-jar-resource-bundle/1.4/apache-jar-resource-bundle-1.4.jar

# jpp depmap fix commons-collections32 -> commons-collections
