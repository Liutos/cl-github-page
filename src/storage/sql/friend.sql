DROP TABLE IF EXISTS `friend`;

CREATE TABLE `friend` (
    `friend_id` INT NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(100) NOT NULL COMMENT '站点名称',
    `url` VARCHAR(100) NOT NULL COMMENT '友情链接',
    PRIMARY KEY (`friend_id`)
);
