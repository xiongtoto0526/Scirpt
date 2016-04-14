how to run?

-- eclipse
1. import ->maven->exist maven project ->
编译出错：
ArtifactTransferException: Failure to transfer org.javassist:javassist:jar:3.18.1-GA from http://repo.maven.apache.org/maven2 was cached in the local repository, resolution will not be reattempted until the update interval of central has elapsed or updates are forced. Original error: Could not transfer artifact org.javassist:javassist:jar:3.18.1-GA from/to central (http://repo.maven.apache.org/maven2): The operation was cancelled.	pom.xml	/spring-boot-actuator-example	line 1	Maven Dependency Problem
解决方法：
直接删除本地对应的cache库，然后重新update Dependency.

2. use mysql-database 
  <dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
  </dependency>

2.1 application-properties
tomcat.datasource.username=xgsdk2_xht
tomcat.datasource.password=xgsdk2_xht
tomcat.datasource.url=jdbc:mysql://127.0.0.1:3306/xgsdk2_xht?useUnicode=true&characterEncoding=UTF-8
tomcat.datasource.driverClassName=com.mysql.jdbc.Driver


3. view data
mysql-workbench

4. 出错
5. org.springframework.beans.factory.BeanCreationException: Error creating bean with name 'org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration': Injection of autowired dependencies failed; nested exception is org.springframework.beans.factory.BeanCreationException: Could not autowire field: private javax.sql.DataSource org.springframework.boot.autoconfigure.orm.jpa.JpaBaseConfiguration.dataSource; nested exception is org.springframework.beans.factory.BeanCreationException: Error creating bean with name 'dataSource' defined in class path resource [org/springframework/boot/autoconfigure/jdbc/DataSourceAutoConfiguration$NonEmbeddedConfiguration.class]: Bean instantiation via factory method failed; nested exception is org.springframework.beans.BeanInstantiationException: Failed to instantiate [javax.sql.DataSource]: Factory method 'dataSource' threw exception; nested exception is org.springframework.boot.autoconfigure.jdbc.DataSourceProperties$DataSourceBeanCreationException: Cannot determine embedded database driver class for database type NONE. If you want an embedded database please put a supported one on the classpath. If you have database settings to be loaded from a particular profile you may need to active it (no profiles are currently active).


#reference
http://www.tuicool.com/articles/zEz2QrY



