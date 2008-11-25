push @SPECHOOKS, \&set_fix_jboss17_java5;

sub set_fix_jboss17_java5 {
    my ($jpp, $alt) = @_;
	$jpp->applied_block(
	"set_fix_jboss17_java5",
	sub {
	    $jpp->get_section('build')->subst(qr'export JAVA_HOME','#export JAVA_HOME');
	    $jpp->get_section('build')->subst(qr'^ant ','ant -Dant.build.javac.source=1.4 -Dant.build.javac.target=1.4 ');
	    $jpp->get_section('build')->unshift_body(q!
for i in `grep -rl 'available classname="java.lang.Enum" property="HAVE_JDK_1.5' .`; do subst 's,available classname="java.lang.Enum" property="HAVE_JDK_1.5,available classname="java.lang.Enum" property="HAVE_JDK_1.4,' $i; done
!);
	    });
}
