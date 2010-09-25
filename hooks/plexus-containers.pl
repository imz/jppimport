#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # delete some -javadoc there in triggers
}

__END__
  x86_64: plexus-containers-component-annotations-javadoc=0:1.0-alt2_0.1.a34.5jpp6 post-install filelist check failed:
realpath: /usr/share/javadoc/plexus-containers-component-annotations-javadoc: No such file or directory
  i586: plexus-containers-component-annotations-javadoc=0:1.0-alt2_0.1.a34.5jpp6 post-install filelist check failed:
realpath: /usr/share/javadoc/plexus-containers-component-annotations-javadoc: No such file or directory
  x86_64: plexus-containers-container-default-javadoc=0:1.0-alt2_0.1.a34.5jpp6 post-install filelist check failed:
realpath: /usr/share/javadoc/plexus-containers-container-default-javadoc: No such file or directory
  i586: plexus-containers-container-default-javadoc=0:1.0-alt2_0.1.a34.5jpp6 post-install filelist check failed:
realpath: /usr/share/javadoc/plexus-containers-container-default-javadoc: No such file or directory
