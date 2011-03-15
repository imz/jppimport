#!/usr/bin/perl -w

require 'windows-thumbnail-database-in-package.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: avalon-framework'."\n");
};
__END__
hack; see
http://jira.springframework.org/browse/SPR-5145
ALSO
http://jira.springframework.org/secure/attachment/14674/junit4.5.patch
986c986,987
< ln -sf $(build-classpath junit4) lib/junit/junit-4.4.jar
---
> #ln -sf $(build-classpath junit4) lib/junit/junit-4.4.jar
> mv lib/junit/junit-4.4.jar.no lib/junit/junit-4.4.jar

# slf4j 1.6
1136c1136
< ln -sf $(build-classpath slf4j/api) lib/slf4j/slf4j-api-1.5.0.jar
---
> ln -sf $(build-classpath slf4j/slf4j-api) lib/slf4j/slf4j-api-1.5.0.jar
1138c1138
< ln -sf $(build-classpath slf4j/log4j12) lib/slf4j/slf4j-log4j12-1.5.0.jar
---
> ln -sf $(build-classpath slf4j/slf4j-log4j12) lib/slf4j/slf4j-log4j12-1.5.0.jar

