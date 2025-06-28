export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

### START MVN JAVA
export M2_HOME=/opt/apache-maven-3.9.5
export MAVEN_HOME=/opt/apache-maven-3.9.5
export PATH=${M2_HOME}/bin:${PATH}
export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
### START MVN JAVA
