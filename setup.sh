#！/bin/sh
# chkconfig: 2345 80 30
default_buiding_service_prop=/etc/abt/building-service.properties
default_hibernate_cfg=/etc/abt/hibernate.cfg.xml
# install the JDK
function install_jdk() {  
echo "                    "
echo "                    "
echo "**********install_jdk"
echo "**********"
echo "                    "
echo "                    "
# 1.unzip and install JDK(jdk-8u51-linux-x64.tar.gz)
  if [ -d  /usr/java ] ;then 
     echo " "
  else    
    sudo mkdir /usr/java
  fi
  #wget -P ~/Downloads --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u51-b16/jdk-8u51-linux-x64.tar.gz
  cd ~/Downloads
  tar -xzvf jdk-8u51-linux-x64.tar.gz 
  sudo chmod 777 jdk1.8.0_51
  sudo mv jdk1.8.0_51  /usr/java
  sudo rm -rf jdk1.8.0_51
 

# 2. config /etc/profile

  sudo cp /etc/profile  /etc/abt/.bak
  chmod 777 /etc/profile 
  sudo cat >> /etc/profile  << EFF
JAVA_HOME=/usr/java/jdk1.8.0_51
JRE_HOME=\$JAVA_HOME/jre
CLASSPATH=:\$JAVA_HOME/lib:\$JRE_HOME/lib
PATH=\$JAVA_HOME/bin:\$JRE_HOME/bin:\$PATH
export JAVA_HOME JRE_HOME CLASSPATH PATH
EFF
  source /etc/profile
  #echo "JAVA_HOME=/usr/java/jdk1.8.0_51" >> /etc/profile
  #echo "export JRE_HOME=/usr/lib/jvm/jdk1.8.0_51/jre" >> /etc/profile
  #echo "PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH" >> /etc/profile
  #echo "CLASSPATH=$CLASSPATH:.:$JAVA_HOME/lib:$JAVA_HOME/jre/lib" >> /etc/profile

  
  echo "**********JDK environment has been successed set**********"

# 3. Test JDK evironment
  echo "                    "
  echo "                    "
  echo "**********Test JDK evironment"
  echo "**********"
  echo "                    "
  echo "                    "
  if [[ ! -z $(ls /user/java/jdk1.8.0_51) ]];
  then
    echo "**********Failed to install JDK (jdk-8u51-linux-x64 : /usr/java/jdk1.8.0_51)"
  else 
    echo "**********JDK has been successed installed**********"
    echo "**********java -version**********"
    java -version
    echo "**********javac -version**********"
    javac -version
    echo "**********ls $JAVA_HOME**********"
    ls $JAVA_HOME

  fi


}


#config the mysql
#default_hibernate_connection_url=jdbc:mysql://localhost:3306/ciengine

function setMysqlConfig() { 
   echo "                    "
   echo "                    "
   echo "**********config the mysql "
   echo "**********"
   echo "                    "
   echo "                    "
   cd /etc/abt
   sudo touch hibernate.cfg.xml
   sudo chmod 777 hibernate.cfg.xml
   sudo cat>>hibernate.cfg.xml<< EFF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE hibernate-configuration PUBLIC
"-//Hibernate/Hibernate Configuration DTD 3.0//EN"
"http://hibernate.sourceforge.net/hibernate-configuration-3.0.dtd">

<hibernate-configuration>
 <session-factory>
  <property name="hibernate.bytecode.use_reflection_optimizer">false</property>
  <property name="hibernate.connection.driver_class">com.mysql.jdbc.Driver</property>
  <property name="hibernate.connection.url">jdbc:mysql://mysql_ip:mysql_port/mysql_databasename</property>
  <property name="hibernate.connection.username">mysql_username</property>
  <property name="hibernate.connection.password">mysql_password</property>
  <property name="hibernate.dialect">org.hibernate.dialect.MySQLDialect</property>
  <property name="show_sql">true</property>
  <property name="hibernate.current_session_context_class">thread</property> 
  
  <mapping resource="tbljob.hbm.xml"/>
  
 </session-factory>
</hibernate-configuration>
EFF
   #source hibernate.cfg.xml
   #sudo cp ${default_hibernate_cfg}  ./bak
   #echo "${package_install_dir}/${default_hibernate_cfg_dir}" 
   echo "                    "
   echo "                    "
   echo -n "mysql_ip"
   echo -n "                                          "
   echo -n "【localhost】:"
   read mysql_ip
   if [ -z $mysql_ip ];then
      mysql_ip=localhost
   else
      echo "                    "
   fi

   echo -n "mysql_port"
   echo -n "                                        "
   echo -n "【3306】:"
   read mysql_port
   if [ -z $mysql_port ];then
      mysql_port=3306
   else
      echo "                    "
   fi

   echo -n "mysql_databasename"
   echo -n "                                "
   echo -n "【ciengine】:"
   read mysql_databasename
   if [ -z $mysql_databasename ];then
      mysql_databasename=ciengine
   else
      echo "                    "
   fi
   
   echo -n "mysql_username"
   echo -n "                                    "
   echo -n "【root】:"
   read mysql_username
   if [ -z $mysql_username ];then
      mysql_username=root
   else
      echo "                    "
   fi

   echo -n "mysql_password"
   echo -n "                                    "
   echo -n "【root】:"
   read mysql_password
   if [ -z $mysql_password ];then
      mysql_password=root
   else
      echo "                    "
   fi
   
   sudo sed -i "s%mysql_ip%${mysql_ip}%g"  ${default_hibernate_cfg}
   sudo sed -i "s/mysql_port/${mysql_port}/g"  ${default_hibernate_cfg}
   sudo sed -i "s/mysql_databasename/${mysql_databasename}/g"  ${default_hibernate_cfg}
   sudo sed -i "s/mysql_username/${mysql_username}/g" ${default_hibernate_cfg}
   sudo sed -i "s/mysql_password/${mysql_password}/g" ${default_hibernate_cfg}
   echo "**********mysql config is ready!**********"
}

#config the gerrit and jenkins config

function setService_prop(){
   echo "                    "
   echo "                    "
   echo "**********config the gerrit and jenkins "
   echo "**********"
   echo "                    "
   echo "                    "
   cd /etc/abt
   sudo touch building-service.properties
   sudo chmod 777 building-service.properties
   sudo cat>>building-service.properties<< EFF
gerritURL=gerrit_url
jenkinsURL=jenkins_url
gerritUsername=gerrit_username
gerritPassword=gerrit_password
EFF
   #source building-service.properties
   #cp ${default_buiding_service_prop}  ./bak
   echo "                    "
   echo "                    "

   echo -n "gerrit_url"
   echo -n "                                        "
   echo -n "【http://abt-node1.sh.intel.com/gerrit/】:"
   read gerrit_url
   if [ -z $gerrit_url ];then
      gerrit_url=http://abt-node1.sh.intel.com/gerrit/
      #gerrit_url=gerrit_url12
   else
      echo "                    "
   fi

   echo -n "jenkins_url"
   echo -n "                                       "
   echo -n "【http://abt-node1.sh.intel.com:8080】:"
   read jenkins_url
   if [ -z $jenkins_url ];then
      jenkins_url=http://abt-node1.sh.intel.com:8080
      #jenkins_url=jenkins_url12
   else
      echo "                    "
   fi

   echo -n "gerrit_username"
   echo -n "                                   "
   echo -n "【junli】:"
   read gerrit_username
   if [ -z $gerrit_username ];then
      gerrit_username=junli
   else
      echo "                    "
   fi
  
   echo -n "gerrit_password"
   echo -n "                                   "
   echo -n "【KmMMP7sTNZVYuZXta4kvB9XJYJbJR89jXvX5OIXMTg】:"
   read gerrit_password
   if [ -z $gerrit_password ];then
      gerrit_password=KmMMP7sTNZVYuZXta4kvB9XJYJbJR89jXvX5OIXMTg
   else
      echo "                    "
   fi
  

   sudo sed -i "s%gerrit_url%${gerrit_url}%g" ${default_buiding_service_prop}
   sudo sed -i "s%jenkins_url%${jenkins_url}%g" ${default_buiding_service_prop}
   sudo sed -i "s%gerrit_username%${gerrit_username}%g" ${default_buiding_service_prop}
   sudo sed -i "s/gerrit_password/${gerrit_password}/g" ${default_buiding_service_prop}
   echo "**********gerrit and jenkins is ready!**********"
}



function checkpid() { 
   
   #sudo /etc/abt/config.sh
   javaps=`$JAVA_HOME/bin/jps -l | grep $project_mainclass` 

   if [ -n "$javaps" ]; then 
      psid=`echo $javaps | awk '{print $1}'` 
   else 
     psid=0 
   fi 
} 

function start() { 
   echo "                    "
   echo "                    "
   echo "**********run the service "
   echo "**********"
   echo "                    "
   echo "                    "
   #sudo /etc/abt/config.sh
   checkpid 

   if [ $psid -ne 0 ]; then 
      echo "================================" 
      echo "warn: $project_mainclass already started! (pid=$psid)" 
      echo "================================" 
   else 
      echo -n "Starting $project_mainclass ..." 
      JAVA_CMD="nohup $JAVA_HOME/bin/java $JAVA_OPTS -classpath $CLASSPATH $project_mainclass & " 
      #echo "$JAVA_CMD"
      $JAVA_CMD
      checkpid 
      if [ $psid -ne 0 ]; then 
         echo "(pid=$psid) [OK]" 
      else 
	 echo "[OK]" 
     #    echo "[Failed]" 
      fi 
    fi 
} 

function stop() {
   #sudo /etc/abt/config.sh 
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

function status() { 
   #sudo /etc/abt/config.sh
   checkpid 

   if [ $psid -ne 0 ]; then 
      echo "$project_mainclass is running! (pid=$psid)" 
   else 
      echo "$project_mainclass is not running" 
   fi 
} 

function serviceInfo() { 
   sudo /etc/abt/config.sh
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


function deploy(){
   #get package_install_dir
   echo "                    "
   echo "                    "
   echo "**********config the package_install_dir"
   echo "**********"
   echo "                    "
   echo "                    "
   echo -n "package_install_dir"
   echo -n "                               "
   echo -n "【/home/zlj/workspace/ciengine】:"
   read package_install_dir
   if [ -z $package_install_dir ];then
      package_install_dir=/home/zlj/workspace/ciengine
   else
      echo "                    "
   fi
   #echo "$package_install_dir"
   echo "                    "
   echo "                    "
   echo "**********install the JDK! "
   echo "**********"
   echo "                    "
   echo "                    "
   echo -n "do you want to install the JDK!"
   echo -n "                   "
   echo -n "【yes or no】:"
   read jdk_no
   if [ -z $jdk_no ];then
      jdk_no=no
      echo -n "JAVA_HOME"
      echo -n "                                         "
      echo -n "【/usr/java/jdk1.8.0_51】:"
      read JAVA_HOME
      if [ -z $JAVA_HOME ];then
         JAVA_HOME=/usr/java/jdk1.8.0_51
      else
         echo "                    "
      fi
   else
      install_jdk
   fi

   sudo mkdir /etc/abt   
   setMysqlConfig
   setService_prop
   cd /etc/abt
   sudo touch config.sh
   sudo chmod 777 config.sh
   sudo cat>>config.sh<< EFF
#！/bin/sh
JAVA_HOME=javahome

package_install_dir=package_dir

project_mainclass=com.intel.cpeg.bs.business.BSServer

default_buiding_service_prop=/etc/abt/building-service.properties

default_hibernate_cfg=/etc/abt/hibernate.cfg.xml

default_config_path=/etc/abt/config.sh

CLASSPATH=package_dir/BuildingService/target/BuildingService-1.0-jar-with-dependencies.jar

JAVA_OPTS="-ms512m -mx512m -Xmn256m -Djava.awt.headless=true -XX:MaxPermSize=128m" 

psid=0 

echo "good config!!!"
EFF
   
   default_config_path=/etc/abt/config.sh
   #echo "${JAVA_HOME}"
   #echo "${package_install_dir}"
   sudo sed -i "s%javahome%${JAVA_HOME}%g" ${default_config_path}
   sudo sed -i "s%package_dir%${package_install_dir}%g" ${default_config_path} 


}



function main {
      if [ $1 = "deploy" ];then
         echo ""
      else
         source  /etc/abt/config.sh 
      fi
      #echo "${JAVA_HOME}"
      case "$1" in 
      start) 
       start 
       ;; 
      stop) 
       stop 
       ;; 
      restart) 
       stop 
       start 
       ;; 
      status) 
       status 
       ;; 
      info) 
       serviceInfo 
       ;;
      deploy) 
       deploy 
       ;; 
      *) 
       echo "Usage: $0 {start|stop|restart|status|info|deploy}" 
       exit 1 
       ;;
      esac 
   exit 0
}

  
   
   main $1
