DROP TABLE IF EXISTS `tag`;

CREATE TABLE `tag` (
    `name` VARCHAR(100) NOT NULL COMMENT '标签名称',
    `tag_id` INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (`tag_id`)
);
