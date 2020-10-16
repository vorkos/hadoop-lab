jdk_version=$(ls -al {{ jvm_home }}|grep "^d"|grep "java"| grep "java\-{{ jvm_version }}" |awk '{print$NF}')
export JAVA_HOME={{ jvm_home }}/$jdk_version