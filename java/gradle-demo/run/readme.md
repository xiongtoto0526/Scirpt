questions:

1. use a mac, start with error:"Access to DialectResolutionInfo cannot be null when 'hibernate.dialect' not set"
- solution: add this line in application.properties:
 spring.jpa.properties.hibernate.dialect = org.hibernate.dialect.MySQL5Dialect
 
2. use a mac, start with error:"The server time zone value 'CST' is unrecognized or represents"
- solution: modify the mysql timezone. if you install by homebrew,the location is supposed to be "/usr/local/Cellar/mysql/5.6.25". and add this line.
- default-time-zone='+8:00' , and restart mysql.



