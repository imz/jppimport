#!/usr/bin/perl -w

$spechook = sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->unshift_body('BuildRequires: cglib'."\n");
    $spec->get_section('build')->push_body(q{
cat > JPP-cglib-full.pom <<EOF
<project>
  <modelVersion>4.0.0</modelVersion>
      <groupId>cglib</groupId>
      <artifactId>cglib-full</artifactId>
      <version>2.0</version>
</project>
EOF
});
}


__END__
                <maven>
                        <groupId>cglib</groupId>
                        <artifactId>cglib-full</artifactId>
                        <version>2.0</version>
                </maven>
                <jpp>
                        <groupId>JPP</groupId>
                        <artifactId>cglib</artifactId>
                        <version>2.0</version>
                </jpp>
 
