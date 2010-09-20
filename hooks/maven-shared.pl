#require 'set_without_maven.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
};

__END__
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


