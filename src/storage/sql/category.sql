DROP TABLE IF EXISTS `category`;

CREATE TABLE `category` (
    `category_id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL COMMENT '分类名称',
    PRIMARY KEY (`category_id`)
);
