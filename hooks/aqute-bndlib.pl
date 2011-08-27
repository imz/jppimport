#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
};

__END__
addclasspath()
{
for arg in "$@"; do
      if [ -e $arg ]; then
              CLASSPATH=${CLASSPATH}:$arg
      else
              echo $arg failed
              exit 1
      fi
done
}
addclasspath $(ls %{_libdir}/eclipse/dropins/jdt/plugins/org.eclipse.jdt.junit.*.jar)
