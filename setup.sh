#！/bin/sh
# chkconfig: 2345 80 30
# install the JDK
function install_jdk() {  

# 1.unzip and install JDK(jdk-7u79-linux-x64.bin)
  if [-d /usr/java] ;then 
     echo "---/usr/java is exist!---"
  else    
    mkdir /usr/java
  fi
  tar -xzvf ./jdk-7u79-linux-x64.tar.gz 
  chmod u+x ./jdk1.7.0_79
  ./jdk1.7.0_79 
  mv ./jdk1.7.0_79  /usr/java/jdk1.7.0_79
  rm -rf ./jdk1.7.0_79
 

# 2. config /etc/profile

  cp /etc/profile  ./bak

  echo "JAVA_HOME=/usr/java/jdk1.7.0_79" >> /etc/profile
  echo "export JRE_HOME=/usr/lib/jvm/jdk1.7.0_45/jre" >> /etc/profile
  echo "PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH" >> /etc/profile
  echo "CLASSPATH=$CLASSPATH:.:$JAVA_HOME/lib:$JAVA_HOME/jre/lib" >> /etc/profile

  
  echo "-->JDK environment has been successed set in /etc/profile."

# 3. Test JDK evironment
  if [[ ! -z $(ls /user/java/jdk1.7.0_45) ]];
  then
    echo "-->Failed to install JDK (jdk-7u79-linux-x64 : /usr/java/jdk1.7.0_45)"
  else 
    echo "-->JDK has been successed installed."
    echo "java -version"
    java -version
    echo "javac -version"
    javac -version
    echo "ls \$JAVA_HOME"$JAVA_HOME
    ls $JAVA_HOME

  fi


}

#get package_install_dir
function getPackge_dir(){
   echo "---please input the package_install_dir---"
   echo "---for example:/home/zlj/myspace/ciengine---"
   read package_install_dir
   return $(package_install_dir)   
}

#config the mysql
default_hibernate_connection_url=jdbc:mysql://localhost:3306/ciengine
default_hibernate_cfg=${package_install_dir}/BSData/src/main/resources/hibernate.cfg.xml
function setMysqlConfig() { 
   cp ${default_hibernate_cfg}  ./bak
   #echo "${package_install_dir}/${default_hibernate_cfg_dir}" 
   echo "---do you want to use default hibernate.connection.url like this:${default_hibernate_connection_url}---"
   echo "---yes or no---"
   read bool
   if ["$bool"="yes"];then
      hibernate_connection_url=${default_hibernate_connection_url}
   else
     echo "---please input a new hibernate.connection.url---"
     echo "---for example:$default_hibernate_connection_url---"
     read hibernate_connection_url
   fi
   echo "---please input the mysql_username---"
   read mysql_username
   echo "---please input the mysql_password---"
   read mysql_password
   sed 's/${default_hibernate_connection_url}/${hibernate_connection_url}/g'  ${default_hibernate_cfg}
   sed 's/mysql_username/${mysql_username}/g' ${default_hibernate_cfg}
   sed 's/mysql_password/${mysql_password}/g' ${default_hibernate_cfg}
   echo "---mysql config is ready!---"
}

#config the gerrit and jenkins config
default_buiding_service_prop=${package_install_dir}/BuildingService/src/main/resources/building-service.properties
function setService_prop(){
   cp ${default_buiding_service_prop}  ./bak
   echo "---please input the gerrit_server---"
   read gerrit_server
   echo "---please input the gerrit_port---"
   read gerrit_port
   echo "---please input the jenkins_server---"
   read jenkins_server
   echo "---please input the jenkins_port---"
   read jenkins_port
   sed 's/gerrit server/${gerrit_server}/g' ${default_buiding_service_prop}
   sed 's/port/${gerrit_port}/' ${default_buiding_service_prop}
   sed 's/gerrit server/${jenkins_server}/g' ${default_buiding_service_prop}
   sed 's/port/${jenkins_port}/' ${default_buiding_service_prop}
   echo "---gerrit and jenkins is ready!---"
}

JAVA_HOME=/usr/java/jdk1.7.0_79
echo $JAVA_HOME

running_user=root

project_mainclass=

CLASSPATH=$package_install_dir 
for i in "$package_install_dir"/lib/*.*; do 
CLASSPATH="$CLASSPATH":"$i" 
done 

JAVA_OPTS="-ms512m -mx512m -Xmn256m -Djava.awt.headless=true -XX:MaxPermSize=128m" 

psid=0 

function checkpid() { 
   javaps=`$JAVA_HOME/bin/jps -l | grep $project_mainclass` 

   if [ -n "$javaps" ]; then 
      psid=`echo $javaps | awk '{print $1}'` 
   else 
     psid=0 
   fi 
} 

function startService() { 
   checkpid 

   if [ $psid -ne 0 ]; then 
      echo "================================" 
      echo "warn: $project_mainclass already started! (pid=$psid)" 
      echo "================================" 
   else 
      echo -n "Starting $project_mainclass ..." 
      JAVA_CMD="nohup $JAVA_HOME/bin/java $JAVA_OPTS -classpath $CLASSPATH $project_mainclass >/dev/null 2>&1 &" 
      su - $running_user -c "$JAVA_CMD" 
      checkpid 
      if [ $psid -ne 0 ]; then 
         echo "(pid=$psid) [OK]" 
      else 
         echo "[Failed]" 
      fi 
    fi 
} 

function stopService() { 
   checkpid 

   if [ $psid -ne 0 ]; then 
      echo -n "Stopping $project_mainclass ...(pid=$psid) " 
      su - $running_user -c "kill -9 $psid" 
      if [ $? -eq 0 ]; then 
         echo "[OK]" 
      else 
          echo "[Failed]" 
      fi 

      checkpid 
      if [ $psid -ne 0 ]; then 
         stopService 
      fi 
   else 
      echo "================================" 
      echo "warn: $project_mainclass is not running" 
      echo "================================" 
   fi 
} 

function serviceStatus() { 
   checkpid 

   if [ $psid -ne 0 ]; then 
      echo "$project_mainclass is running! (pid=$psid)" 
   else 
      echo "$project_mainclass is not running" 
   fi 
} 

function serviceInfo() { 
   echo "System Information:" 
   echo "****************************" 
   echo `head -n 1 /etc/issue` 
   echo `uname -a` 
   echo 
   echo "JAVA_HOME=$JAVA_HOME" 
   echo `$JAVA_HOME/bin/java -version` 
   echo 
   echo "package_install_dir=$package_install_dir" 
   echo "project_mainclass=$project_mainclass" 
   echo "****************************" 
} 

usetime=0

function main {
   if [${usetime} -eq 0];then
      install_jdk
      setMysqlConfig
      setService_prop
      usetime=1
   else
      case "$1" in 
      'startService') 
       startService 
       ;; 
      'stopService') 
       stopService 
       ;; 
      'restart') 
       stopService 
       startService 
       ;; 
      'serviceStatus') 
       serviceStatus 
       ;; 
      'serviceInfo') 
       serviceInfo 
       ;; 
      *) 
       echo "Usage: $0 {startService|stopService|restart|serviceStatus|serviceInfo}" 
        exit 1 
       ;;
      esac 
   exit 0

}

getPackge_dir
main $1
