CREATE TABLE `book` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL COMMENT 'id标示',
  `author` varchar(64) DEFAULT NULL COMMENT '作者',
  `price` bigint(256) DEFAULT NULL COMMENT '价格',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=77627 DEFAULT CHARSET=utf8 COMMENT='book定义表';
