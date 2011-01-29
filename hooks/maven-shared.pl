
push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst_if(qr'maven-plugin-modello','modello-maven-plugin',qr'Requires:');
};

__END__
# deprecated
    <dependency>
        <maven>
            <groupId>org.apache.maven</groupId>
            <artifactId>maven-model-v3</artifactId>
            <version>2.0</version>
        </maven>
        <jpp>
            <groupId>JPP</groupId>
            <artifactId>maven-model-all</artifactId>
            <version>2.0.8</version>
        </jpp>
    </dependency>


