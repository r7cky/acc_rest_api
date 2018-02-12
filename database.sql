SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = '+00:00';

-- --------------------------------------------------------

--
-- Table structure for table `misc__device_type`
--

CREATE TABLE IF NOT EXISTS `misc__device_type` (
  `device_type_id` int(11) NOT NULL AUTO_INCREMENT,
  `device_type_name` varchar(250) NOT NULL,
  PRIMARY KEY (`device_type_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=353 ;

--
-- Dumping data for table `misc__device_type`
--

INSERT INTO `misc__device_type` (`device_type_id`, `device_type_name`) VALUES
(1, 'iOS'),
(2, 'Android'),
(3, 'Windows');

-- --------------------------------------------------------

--
-- Table structure for table `user__info`
--

CREATE TABLE IF NOT EXISTS `user__info` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(250) NOT NULL,
  `password` varchar(250) NOT NULL,
  `device_id` varchar(250) DEFAULT NULL,
  `device_type_id` int(11) DEFAULT NULL,
  `first_name` varchar(250) NOT NULL,
  `last_name` varchar(250) NOT NULL,
  `email` varchar(250) DEFAULT NULL,
  `session_key` varchar(250),
  `created_date` datetime NOT NULL,
  `updated_date` datetime NOT NULL,
  `last_login` datetime NOT NULL,
  `is_disabled` BOOLEAN NOT NULL DEFAULT 0,
  CONSTRAINT `fk_device_type_id_user__info` FOREIGN KEY (`device_type_id`) REFERENCES `misc__device_type` (`device_type_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=122 ;

--
-- Dumping data for table `user__info`
--

INSERT INTO `user__info` (`user_id`, `user_name`, `password`, `device_id`, `device_type_id`, `first_name`, `last_name`, `email`, `created_date`, `updated_date`) VALUES
(1, 'admin', '$2y$10$mTDnE0wE11jCX/VbwkKvpuEU41jJACPAwpJvqCAjVc3k3mBrFleLO', 'device1', 1, 'Admin', 'LastName', 'admin@example.com', '2015-04-28 10:52:39', '2016-05-21 12:44:19'),
(2, 'user1', '$2y$10$mTDnE0wE11jCX/VbwkKvpuEU41jJACPAwpJvqCAjVc3k3mBrFleLO', 'device2', 1, 'User', 'One', 'user1@example.com', '2016-10-04 02:11:45', '2016-10-04 02:11:45'),
(3, 'user2', '$2y$10$mTDnE0wE11jCX/VbwkKvpuEU41jJACPAwpJvqCAjVc3k3mBrFleLO', 'device3', 1, 'User', 'Two', 'user2@example.com', '2016-10-04 02:11:45', '2016-10-04 02:11:45');

-- --------------------------------------------------------

--
-- Table structure for table `admin__info`
--

CREATE TABLE IF NOT EXISTS `admin__info` (
  `admin_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  CONSTRAINT `fk_user_id_admin__info` FOREIGN KEY (`user_id`) REFERENCES `user__info` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  PRIMARY KEY (`admin_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=26 ;

--
-- Dumping data for table `admin__info`
--
INSERT INTO `admin__info` (`admin_id`, `user_id`) VALUES
(1, 1);


-- --------------------------------------------------------

--
-- Table structure for table `teacher__info`
--

CREATE TABLE IF NOT EXISTS `teacher__info` (
  `teacher_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  CONSTRAINT `fk_user_id_teacher__info` FOREIGN KEY (`user_id`) REFERENCES `user__info` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  PRIMARY KEY (`teacher_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=26 ;

--
-- Dumping data for table `teacher__info`
--

INSERT INTO `teacher__info` (`teacher_id`, `user_id`) VALUES
(1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `class__info`
--

CREATE TABLE IF NOT EXISTS `class__info` (
  `class_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL,
  `description` varchar(250) NOT NULL,
  `created_date` datetime NOT NULL,
  `updated_date` datetime NOT NULL,
  PRIMARY KEY (`class_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=122 ;

--
-- Dumping data for table `class__info`
--

INSERT INTO `class__info` (`class_id`, `name`, `description`, `created_date`, `updated_date`) VALUES
(1, 'Science Class', 'Description for science class', '2016-10-04 02:11:45', '2016-10-04 02:11:45');

-- --------------------------------------------------------

--
-- Table structure for table `class__teacher`
--

CREATE TABLE IF NOT EXISTS `class__teacher` (
  `class_id` int(11) NOT NULL,
  `teacher_id` int(11) NOT NULL,
  CONSTRAINT `fk_class_id_class__teacher` FOREIGN KEY (`class_id`) REFERENCES `class__info` (`class_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_teacher_id_class__teacher` FOREIGN KEY (`teacher_id`) REFERENCES `teacher__info` (`teacher_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  PRIMARY KEY (`class_id`, `teacher_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=90 ;

--
-- Dumping data for table `class__teacher`
--

INSERT INTO `class__teacher` (`class_id`, `teacher_id`) VALUES
(1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `post__type`
--

CREATE TABLE IF NOT EXISTS `post__type` (
  `post_type_id` int(11) NOT NULL AUTO_INCREMENT,
  `post_type_name` varchar(250) NOT NULL,
  PRIMARY KEY (`post_type_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=353 ;

--
-- Dumping data for table `post__type`
--

INSERT INTO `post__type` (`post_type_id`, `post_type_name`) VALUES
(1, 'Teacher Post'),
(2, 'Question Post');

-- --------------------------------------------------------

--
-- Table structure for table `post__info`
--

CREATE TABLE IF NOT EXISTS `post__info` (
  `post_id` int(11) NOT NULL AUTO_INCREMENT,
  `class_id` int(11) NOT NULL,
  `owner_user_id` int(11) NOT NULL,
  `post_type_id` int(11) NOT NULL,
  `post_title` varchar(250) NOT NULL,
  `post_date` datetime NOT NULL,
  `updated_date` datetime NOT NULL,
  `is_deleted` BOOLEAN NOT NULL DEFAULT 0,
  CONSTRAINT `fk_class_id_post__info` FOREIGN KEY (`class_id`) REFERENCES `class__info` (`class_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_owner_user_id_post__info` FOREIGN KEY (`owner_user_id`) REFERENCES `user__info` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_post_type_id_post__info` FOREIGN KEY (`post_type_id`) REFERENCES `post__type` (`post_type_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  PRIMARY KEY (`post_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=122 ;

--
-- Dumping data for table `post__info`
--

INSERT INTO `post__info` (`post_id`, `class_id`, `owner_user_id`, `post_type_id`, `post_title`, `post_date`, `updated_date`, `is_deleted`) VALUES
(1, 1, 2, 1, 'First ever post title', '2015-04-28 10:52:39', '2016-05-21 12:44:19', 0);

-- --------------------------------------------------------

--
-- Table structure for table `post__detail`
--

CREATE TABLE IF NOT EXISTS `post__detail` (
  `post_detail_id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` int(11) NOT NULL,
  `post_character_count` int(11) NOT NULL,
  `post_text` TEXT NOT NULL,
  CONSTRAINT `fk_post_id_post__detail` FOREIGN KEY (`post_id`) REFERENCES `post__info` (`post_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  PRIMARY KEY (`post_detail_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=122 ;

--
-- Dumping data for table `post__detail`
--

INSERT INTO `post__detail` (`post_detail_id`, `post_id`, `post_character_count`, `post_text`) VALUES
(1, 1, 15, 'First post ever');

-- --------------------------------------------------------

--
-- Table structure for table `comment__info`
--

CREATE TABLE IF NOT EXISTS `comment__info` (
  `comment_id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` int(11) NOT NULL,
  `parent_comment_id` int(11) DEFAULT NULL,
  `owner_user_id` int(11) NOT NULL,
  `comment_text` TEXT NOT NULL,
  `is_deleted` BOOLEAN NOT NULL DEFAULT 0,
  `comment_date` datetime NOT NULL,
  `updated_date` datetime NOT NULL,
  CONSTRAINT `fk_parent_comment_id_comment__info` FOREIGN KEY (`parent_comment_id`) REFERENCES `comment__info` (`comment_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_post_id_comment__info` FOREIGN KEY (`post_id`) REFERENCES `post__info` (`post_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_id_comment__info` FOREIGN KEY (`owner_user_id`) REFERENCES `user__info` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  PRIMARY KEY (`comment_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=122 ;

--
-- Dumping data for table `comment__info`
--

INSERT INTO `comment__info` (`comment_id`, `owner_user_id`, `post_id`, `comment_text`, `is_deleted`, `comment_date`, `updated_date`) VALUES
(1, 1, 1, 'Good post :)', 0, '2015-04-28 10:52:39', '2016-05-21 12:44:19');

-- --------------------------------------------------------

--
-- Table structure for table `vote__post_info`
--

CREATE TABLE IF NOT EXISTS `vote__post_info` (
  `user_id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `is_upvote` BOOLEAN NOT NULL,
  `vote_date` datetime NOT NULL,
  `updated_date` datetime NOT NULL,
  CONSTRAINT `fk_user_id_vote__post_info` FOREIGN KEY (`user_id`) REFERENCES `user__info` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_post_id_vote__post_info` FOREIGN KEY (`post_id`) REFERENCES `post__info` (`post_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  PRIMARY KEY (`user_id`, `post_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=122;

--
-- Dumping data for table `vote__post_info`
--

INSERT INTO `vote__post_info` (`user_id`, `post_id`, `is_upvote`, `vote_date`, `updated_date`) VALUES
(2, 1, 1, '2015-04-28 10:52:39', '2016-05-21 12:44:19');

-- --------------------------------------------------------

--
-- Table structure for table `vote__comment_info`
--

CREATE TABLE IF NOT EXISTS `vote__comment_info` (
  `user_id` int(11) NOT NULL,
  `comment_id` int(11) NOT NULL,
  `is_upvote` BOOLEAN NOT NULL,
  `vote_date` datetime NOT NULL,
  `updated_date` datetime NOT NULL,
  CONSTRAINT `fk_user_id_vote__comment_info` FOREIGN KEY (`user_id`) REFERENCES `user__info` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_comment_id_vote__comment_info` FOREIGN KEY (`comment_id`) REFERENCES `comment__info` (`comment_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  PRIMARY KEY (`user_id`, `comment_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=122;

--
-- Dumping data for table `vote__comment_info`
--

INSERT INTO `vote__comment_info` (`user_id`, `comment_id`, `is_upvote`, `vote_date`, `updated_date`) VALUES
(2, 1, 1, '2015-04-28 10:52:39', '2016-05-21 12:44:19');

-- --------------------------------------------------------

--
-- Table structure for table `report__post_info`
--

CREATE TABLE IF NOT EXISTS `report__post_info` (
  `reporter_user_id` int(11) NOT NULL,
  `reported_post_id` int(11) NOT NULL,
  `reported_date` datetime NOT NULL,
  CONSTRAINT `fk_reporter_user_id_vote__post_info` FOREIGN KEY (`reporter_user_id`) REFERENCES `user__info` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_reported_post_id_report__post_info` FOREIGN KEY (`reported_post_id`) REFERENCES `post__info` (`post_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  PRIMARY KEY (`reporter_user_id`, `reported_post_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=122;

--
-- Dumping data for table `report__post_info`
--

INSERT INTO `report__post_info` (`reporter_user_id`, `reported_post_id`, `reported_date`) VALUES
(2, 1, '2016-05-21 12:44:19');

-- --------------------------------------------------------

--
-- Table structure for table `report__comment_info`
--

CREATE TABLE IF NOT EXISTS `report__comment_info` (
  `reporter_user_id` int(11) NOT NULL,
  `reported_comment_id` int(11) NOT NULL,
  `reported_date` datetime NOT NULL,
  CONSTRAINT `fk_reporter_user_id_vote__comment_info` FOREIGN KEY (`reporter_user_id`) REFERENCES `user__info` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_reported_comment_id_report__comment_info` FOREIGN KEY (`reported_comment_id`) REFERENCES `comment__info` (`comment_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  PRIMARY KEY (`reporter_user_id`, `reported_comment_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=122;

--
-- Dumping data for table `report__comment_info`
--

INSERT INTO `report__comment_info` (`reporter_user_id`, `reported_comment_id`, `reported_date`) VALUES
(2, 1, '2016-05-21 12:44:19');