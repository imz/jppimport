#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: jakarta-commons-primitives11'."\n");
!);

}

__END__
diff ../SOURCES/portals-bridges-jpp-depmap.xml{~,}
410a411,424
>  <dependency>
>    <maven>
>      <groupId>javax.servlet</groupId>
>      <artifactId>servlet-api</artifactId>
>      <version>2.3</version>
>    </maven>
>    <jpp>
>      <groupId>JPP</groupId>
>      <artifactId>servlet_2_3_api</artifactId>
>      <version>2.3</version>
>      <jar>servlet_2_3_api.jar</jar>
>    </jpp>
>  </dependency>
> 
