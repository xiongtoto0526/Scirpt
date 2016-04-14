--1.if provided, this script can not be null.
--2.spring.datasource.schema and spring.datasource.data can be changed to redefine the location of the script
--3.this script will run again,every time the app restart...
drop table book;
CREATE TABLE `book` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL COMMENT 'id标示',
  `author` varchar(64) DEFAULT NULL COMMENT '作者',
  `price` bigint(20) DEFAULT NULL COMMENT '价格',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=77627 DEFAULT CHARSET=utf8 COMMENT='book定义表';
