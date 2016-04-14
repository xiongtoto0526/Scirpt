how to run?

-- eclipse
1. import ->maven->exist maven project ->
编译出错：
ArtifactTransferException: Failure to transfer org.javassist:javassist:jar:3.18.1-GA from http://repo.maven.apache.org/maven2 was cached in the local repository, resolution will not be reattempted until the update interval of central has elapsed or updates are forced. Original error: Could not transfer artifact org.javassist:javassist:jar:3.18.1-GA from/to central (http://repo.maven.apache.org/maven2): The operation was cancelled.	pom.xml	/spring-boot-actuator-example	line 1	Maven Dependency Problem
解决方法：
直接删除本地对应的cache库，然后重新update Dependency.

2. use h2-database 
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-devtools</artifactId>
        <optional>true</optional>
    </dependency>
</dependencies>

3. view data
http://localhost:8080/h2-console
user：sa
pw:
jdbc-url:jdbc:h2:mem:testdb

4. reference
http://www.javabeat.net/spring-data-jpa/?et_monarch_popup=true

http://blog.techdev.de/querying-the-embedded-h2-database-of-a-spring-boot-application/

http://docs.spring.io/spring-boot/docs/current-SNAPSHOT/reference/htmlsingle/#boot-features-sql-h2-console