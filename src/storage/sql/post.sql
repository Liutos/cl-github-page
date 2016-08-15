DROP TABLE IF EXISTS `post`;

CREATE TABLE `post` (
    `body` TEXT NOT NULL COMMENT '文章正文',
    `post_id` INT NOT NULL AUTO_INCREMENT,
    `source` TEXT NOT NULL COMMENT '源文件内容',
    `title` VARCHAR(100) NOT NULL COMMENT '文章标题',
    PRIMARY KEY (`post_id`)
);
