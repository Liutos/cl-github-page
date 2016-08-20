DROP TABLE IF EXISTS `post`;

CREATE TABLE `post` (
    `author` VARCHAR(100) COMMENT '文章作者',
    `body` TEXT NOT NULL COMMENT '文章正文',
    `build_at` DATETIME DEFAULT NULL COMMENT '文章最后一次写入到页面文件的时刻',
    `create_at` DATETIME NOT NULL COMMENT '文章创建的时刻',
    `is_active` BOOLEAN NOT NULL COMMENT '文章是否可见',
    `post_id` INT NOT NULL AUTO_INCREMENT,
    `source` TEXT NOT NULL COMMENT '源文件内容',
    `title` VARCHAR(100) NOT NULL COMMENT '文章标题',
    `update_at` DATETIME NOT NULL COMMENT '文章最后一次修改的时刻',
    `write_at` DATETIME NOT NULL COMMENT '文章被创作的时刻',
    PRIMARY KEY (`post_id`)
);
