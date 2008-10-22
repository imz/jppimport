#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: jboss4-common qdox'."\n");
    $jpp->get_section('build')->subst(qr'build-classpath ejb\)','build-classpath ejb_2_1_api)');
};
__END__
    # due to our ant that does not support 'OPT_JAR_LIST
$ diff spring.spec.0  spring.spec
523c525
< ln -sf $(build-classpath ejb) .
---
> ln -sf $(build-classpath ejb_2_1_api) .


655,656c657,658
< export JAVA_HOME=%{_jvmdir}/java-1.5.0
< export OPT_JAR_LIST="ant-launcher ant/ant-junit junit xjavadoc commons-collections commons-attributes-compiler qdox"
---
> #export JAVA_HOME=%{_jvmdir}/java-1.5.0
> export OPT_JAR_LIST="ant-launcher ant/ant-junit junit xjavadoc commons-collections commons-attributes-compiler qdox ant"
659,661c661,667
< ant \
<     -Djava.endorsed.dir=lib/endorsed \
<     alljars tests
---
> #ant \
> #    -Djava.endorsed.dir=lib/endorsed \
> #    alljars tests
>
> java -Dant.home="/usr/share/ant" -cp $(build-classpath $OPT_JAR_LIST):"$JAVA_HOME"/lib/tools.jar \
>         org.apache.tools.ant.launch.Launcher -lib "$CLASSPATH" alljars tests
>
