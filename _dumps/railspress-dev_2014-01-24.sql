# ************************************************************
# Sequel Pro SQL dump
# Version 4096
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: localhost (MySQL 5.6.10)
# Database: railspress-dev
# Generation Time: 2014-01-24 11:25:43 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table activities
# ------------------------------------------------------------

DROP TABLE IF EXISTS `activities`;

CREATE TABLE `activities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `trackable_id` int(11) DEFAULT NULL,
  `trackable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `owner_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `parameters` text COLLATE utf8_unicode_ci,
  `recipient_id` int(11) DEFAULT NULL,
  `recipient_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `read` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_activities_on_trackable_id_and_trackable_type` (`trackable_id`,`trackable_type`),
  KEY `index_activities_on_owner_id_and_owner_type` (`owner_id`,`owner_type`),
  KEY `index_activities_on_recipient_id_and_recipient_type` (`recipient_id`,`recipient_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `activities` WRITE;
/*!40000 ALTER TABLE `activities` DISABLE KEYS */;

INSERT INTO `activities` (`id`, `trackable_id`, `trackable_type`, `owner_id`, `owner_type`, `key`, `parameters`, `recipient_id`, `recipient_type`, `created_at`, `updated_at`, `read`)
VALUES
	(13,119,'Comment',1,'User','comment.create','---\n:username: creasty\n:post_title: daskgfhadsg\n:excerpt: ! \'fghjkdjh\n\n  sdf\n\n  adgadsgadsga\'\n',2,'User','2013-09-01 09:56:28','2013-09-01 10:44:32',0),
	(14,120,'Comment',2,'User','comment.create','---\n:username: johnsmith\n:post_title: 記事のタイトル\n:excerpt: ! \'fghjklsdkjgfadg\n\n\n  adgadfadsgadsg\'\n',1,'User','2013-09-01 11:10:04','2013-09-01 11:10:04',0),
	(15,121,'Comment',1,'User','comment.create','---\n:username: creasty\n:post_title: daskgfhadsg\n:excerpt: ! \'asdfasdf\n\n  asdfasdfasdf\'\n',2,'User','2013-09-01 11:12:23','2013-09-01 11:12:23',0),
	(16,122,'Comment',1,'User','comment.create','---\n:username: creasty\n:post_title: daskgfhadsg\n:excerpt: ! \'fasdfadsg\n\n  adgadgadgadg\'\n',2,'User','2013-09-01 11:13:20','2013-09-01 11:13:20',0),
	(18,19,'Rating',1,'User','comment.rating.create',NULL,1,'User','2013-09-01 11:34:12','2013-09-01 11:34:12',0),
	(19,20,'Rating',1,'User','comment.rating.create',NULL,1,'User','2013-09-01 11:35:24','2013-09-01 11:35:24',0),
	(20,21,'Rating',1,'User','comment.rating.create',NULL,2,'User','2013-09-01 11:36:59','2013-09-01 11:36:59',0),
	(23,90,'Post',1,'User','post.destroy',NULL,NULL,NULL,'2013-09-01 11:55:46','2013-09-01 11:55:46',0),
	(24,22,'Rating',1,'User','comment.rating.create',NULL,1,'User','2013-09-14 09:56:55','2013-09-14 09:56:55',0),
	(25,23,'Rating',1,'User','comment.rating.create',NULL,1,'User','2013-09-14 10:08:12','2013-09-14 10:08:12',0);

/*!40000 ALTER TABLE `activities` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table comments
# ------------------------------------------------------------

DROP TABLE IF EXISTS `comments`;

CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `post_id` int(11) DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_comments_on_user_id` (`user_id`),
  KEY `index_comments_on_post_id` (`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;

INSERT INTO `comments` (`id`, `user_id`, `post_id`, `content`, `created_at`, `updated_at`)
VALUES
	(2,1,1,'comment comment\r\n\r\n','2013-04-08 10:46:45','2013-04-08 13:07:26'),
	(3,1,1,'comment comment 2\r\ncomment comment 2','2013-04-08 12:31:33','2013-04-08 12:31:33'),
	(5,1,4,'iuhfew4eifbakjhbso','2013-04-11 10:48:54','2013-04-11 10:48:54'),
	(6,2,58,'sdfaiuf983whfqr34p98fhaepirfga','2013-05-12 09:21:52','2013-05-12 09:21:52'),
	(7,2,1,'djkghakd\nasdgadg\na9yrwhdfan\ndsg\nadskgfhadsgja','2013-06-08 12:31:33','2013-06-08 12:31:33'),
	(8,10,1,'398afs\nafdssfasdga\nasdfgaaaa','2013-04-08 12:31:33','2013-04-08 12:31:33'),
	(9,2,1,'437tyfhasdifa\nsdafgbads\nadsg\nads\ngsadfjaksdghkajskdgajdsgjkasdgsgsrgew\ndsg adsga sgdj kahkdsghoa asdfg aopwe','2013-04-08 12:31:33','2013-04-08 12:31:33'),
	(10,1,33,'comment comment\r\n\r\n','2013-04-08 10:46:45','2013-04-08 13:07:26'),
	(11,1,34,'comment comment 2\r\ncomment comment 2','2013-04-08 12:31:33','2013-04-08 12:31:33'),
	(12,1,35,'iuhfew4eifbakjhbso','2013-04-11 10:48:54','2013-04-11 10:48:54'),
	(13,1,36,'comment comment\r\n\r\n','2013-04-08 10:46:45','2013-04-08 13:07:26'),
	(14,1,37,'comment comment\r\n\r\n','2013-04-08 10:46:45','2013-04-08 13:07:26'),
	(15,1,38,'comment comment\r\n\r\n','2013-04-08 10:46:45','2013-04-08 13:07:26'),
	(16,1,39,'comment comment\r\n\r\n','2013-04-08 10:46:45','2013-04-08 13:07:26'),
	(17,1,40,'comment comment\r\n\r\n','2013-04-08 10:46:45','2013-04-08 13:07:26'),
	(18,1,45,'comment comment\r\n\r\n','2013-04-08 10:46:45','2013-04-08 13:07:26'),
	(19,1,42,'comment comment\r\n\r\n','2013-04-08 10:46:45','2013-04-08 13:07:26'),
	(20,1,43,'comment comment\r\n\r\n','2013-04-08 10:46:45','2013-04-08 13:07:26'),
	(21,1,44,'comment comment\r\n\r\n','2013-04-08 10:46:45','2013-04-08 13:07:26'),
	(29,2,1,'dsfasfa','2013-07-01 03:04:05','2013-07-01 03:04:05'),
	(30,1,1,'dsfasfa\ndsf\nasdgasdg\n','2013-07-01 03:04:11','2013-07-01 03:04:11'),
	(31,1,1,'dsfasdfasdg\nsdg349839ry9qwer\nsdf\n\nsdfa','2013-07-01 03:06:59','2013-07-01 05:40:12'),
	(37,1,58,'dsfafsdf\n\nfsadjf','2013-07-01 05:40:24','2013-07-01 05:40:24'),
	(38,1,58,'sdfgagasdga','2013-07-01 05:42:53','2013-07-01 05:42:53'),
	(40,2,1,'sdふぁsdf','2013-07-01 06:25:37','2013-07-01 06:25:37'),
	(47,1,1,'@johnsmith djkfasdfasdfasd','2013-07-01 09:49:32','2013-07-01 09:49:32'),
	(48,1,1,'- sdafasd\n- fsdaf\n- fasdf','2013-07-01 10:38:52','2013-07-01 11:10:48'),
	(49,1,1,'**Markdown**\nnow u can write w/ markdown style in ur comment\n','2013-07-01 11:01:40','2013-07-01 11:10:31'),
	(50,2,1,'sdafas\nfasd\nhttp://www.google.com\nfsadkj','2013-07-01 11:58:22','2013-07-01 13:03:11'),
	(51,1,1,'fdsaf\n`sdf`\nfsaffasdfas','2013-07-01 13:04:28','2013-07-01 13:10:43'),
	(55,1,4,'dsfasdf\nasdfsdfasdfasdfg','2013-07-11 13:49:25','2013-07-11 13:49:25'),
	(56,1,35,'sdgasdgasgda','2013-07-11 13:49:29','2013-07-11 13:49:29'),
	(58,1,35,'dsfasdg\nfasdgadsg','2013-07-12 04:51:11','2013-07-12 04:51:11'),
	(71,1,35,'@creasty sdfasdfasdf\ndsfas **sadfasdf** dsfasdf','2013-07-13 02:47:44','2013-07-13 02:47:44'),
	(72,1,35,'@creasty 6784754823746328983476437289','2013-07-13 03:08:56','2013-07-13 03:08:56'),
	(78,1,35,'@creasty 4579 sdfasdf 9sa87f','2013-07-13 04:05:27','2013-07-13 04:05:27'),
	(79,1,35,'@creasty dsfas','2013-07-13 04:12:29','2013-07-13 04:12:29'),
	(81,1,42,'39udskjf sfdkah9w3r blasdfa','2013-07-13 04:39:56','2013-07-13 04:39:56'),
	(84,2,42,'@creasty yeaaaaaaaaaaaaaaaaaaaaaaah!','2013-07-13 04:45:17','2013-07-13 04:45:17'),
	(87,10,42,'@johnsmith\nthe quick brown fox jumps over the lazy dog.','2013-07-15 10:11:18','2013-07-15 10:11:18'),
	(88,1,42,'@aaa\nLorem ipsum dolor sit amet, consectetur adipisicing elit, \nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua.','2013-07-15 10:13:29','2013-07-15 10:13:29'),
	(120,2,58,'fghjklsdkjgfadg\n\nadgadfadsgadsg','2013-09-01 11:10:04','2013-09-01 11:10:04');

/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table delayed_jobs
# ------------------------------------------------------------

DROP TABLE IF EXISTS `delayed_jobs`;

CREATE TABLE `delayed_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `priority` int(11) DEFAULT '0',
  `attempts` int(11) DEFAULT '0',
  `handler` text COLLATE utf8_unicode_ci,
  `last_error` text COLLATE utf8_unicode_ci,
  `run_at` datetime DEFAULT NULL,
  `locked_at` datetime DEFAULT NULL,
  `failed_at` datetime DEFAULT NULL,
  `locked_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `queue` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `delayed_jobs_priority` (`priority`,`run_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `delayed_jobs` WRITE;
/*!40000 ALTER TABLE `delayed_jobs` DISABLE KEYS */;

INSERT INTO `delayed_jobs` (`id`, `priority`, `attempts`, `handler`, `last_error`, `run_at`, `locked_at`, `failed_at`, `locked_by`, `queue`, `created_at`, `updated_at`)
VALUES
	(25,0,0,'--- !ruby/object:Delayed::PerformableMailer\nobject: !ruby/class \'NotificationMailer\'\nmethod_name: :comment\nargs:\n- !ruby/ActiveRecord:Comment\n  attributes:\n    id: 99\n    user_id: 1\n    post_id: \'42\'\n    content: ! \'sdafa\n\n      sadfadsf\n\n      asdgfadsgggggggggggggg\'\n    created_at: 2013-07-29 14:37:21.447295000 Z\n    updated_at: 2013-07-29 14:37:21.447295000 Z\n',NULL,'2013-07-29 14:37:21',NULL,NULL,NULL,NULL,'2013-07-29 14:37:21','2013-07-29 14:37:21'),
	(26,0,0,'--- !ruby/object:Delayed::PerformableMailer\nobject: !ruby/class \'NotificationMailer\'\nmethod_name: :comment\nargs:\n- !ruby/ActiveRecord:Comment\n  attributes:\n    id: 100\n    user_id: 1\n    post_id: \'42\'\n    content: ! \'sdfas\n\n      sdfsdafasgdsg\'\n    created_at: 2013-08-25 13:50:11.390635000 Z\n    updated_at: 2013-08-25 13:50:11.390635000 Z\n',NULL,'2013-08-25 13:50:11',NULL,NULL,NULL,NULL,'2013-08-25 13:50:11','2013-08-25 13:50:11'),
	(27,0,0,'--- !ruby/object:Delayed::PerformableMailer\nobject: !ruby/class \'NotificationMailer\'\nmethod_name: :comment\nargs:\n- !ruby/ActiveRecord:Comment\n  attributes:\n    id: 101\n    user_id: 1\n    post_id: \'42\'\n    content: ! \'dfghjk\n\n\n      fj:\'\n    created_at: 2013-08-31 06:46:31.268064000 Z\n    updated_at: 2013-08-31 06:46:31.268064000 Z\n',NULL,'2013-08-31 06:46:31',NULL,NULL,NULL,NULL,'2013-08-31 06:46:31','2013-08-31 06:46:31'),
	(28,0,0,'--- !ruby/object:Delayed::PerformableMailer\nobject: !ruby/class \'NotificationMailer\'\nmethod_name: :comment\nargs:\n- !ruby/ActiveRecord:Comment\n  attributes:\n    id: 104\n    user_id: 1\n    post_id: \'42\'\n    content: ! \'sdfesafas\n\n\'\n    created_at: 2013-08-31 10:47:35.130391000 Z\n    updated_at: 2013-08-31 10:47:35.130391000 Z\n',NULL,'2013-08-31 10:47:35',NULL,NULL,NULL,NULL,'2013-08-31 10:47:35','2013-08-31 10:47:35'),
	(29,0,0,'--- !ruby/object:Delayed::PerformableMailer\nobject: !ruby/class \'NotificationMailer\'\nmethod_name: :comment\nargs:\n- !ruby/ActiveRecord:Comment\n  attributes:\n    id: 105\n    user_id: 1\n    post_id: \'42\'\n    content: sdafasdfg\n    created_at: 2013-08-31 10:48:43.313788000 Z\n    updated_at: 2013-08-31 10:48:43.313788000 Z\n',NULL,'2013-08-31 10:48:43',NULL,NULL,NULL,NULL,'2013-08-31 10:48:43','2013-08-31 10:48:43'),
	(31,0,0,'--- !ruby/object:Delayed::PerformableMailer\nobject: !ruby/class \'NotificationMailer\'\nmethod_name: :comment\nargs:\n- !ruby/ActiveRecord:Comment\n  attributes:\n    id: 107\n    user_id: 1\n    post_id: \'42\'\n    content: ! \'dsfasdga\n\n      sdag\n\n      ad\n\n      sgsgddsagadf\'\n    created_at: 2013-08-31 10:55:46.093220000 Z\n    updated_at: 2013-08-31 10:55:46.093220000 Z\n',NULL,'2013-08-31 10:55:46',NULL,NULL,NULL,NULL,'2013-08-31 10:55:46','2013-08-31 10:55:46'),
	(32,0,0,'--- !ruby/object:Delayed::PerformableMailer\nobject: !ruby/class \'NotificationMailer\'\nmethod_name: :comment\nargs:\n- !ruby/ActiveRecord:Comment\n  attributes:\n    id: 108\n    user_id: 1\n    post_id: \'42\'\n    content: ! \'sdfasdfasdf\n\n      sa\n\n      dfasdfasdfsdfgag\'\n    created_at: 2013-08-31 12:40:52.543074000 Z\n    updated_at: 2013-08-31 12:40:52.543074000 Z\n',NULL,'2013-08-31 12:40:53',NULL,NULL,NULL,NULL,'2013-08-31 12:40:53','2013-08-31 12:40:53'),
	(33,0,0,'--- !ruby/object:Delayed::PerformableMailer\nobject: !ruby/class \'NotificationMailer\'\nmethod_name: :comment\nargs:\n- !ruby/ActiveRecord:Comment\n  attributes:\n    id: 109\n    user_id: 1\n    post_id: \'42\'\n    content: ! \'sdfasdfasd\n\n      fasdddaafffffffffffffffff\'\n    created_at: 2013-08-31 12:42:08.958435000 Z\n    updated_at: 2013-08-31 12:42:08.958435000 Z\n',NULL,'2013-08-31 12:42:09',NULL,NULL,NULL,NULL,'2013-08-31 12:42:09','2013-08-31 12:42:09'),
	(34,0,0,'--- !ruby/object:Delayed::PerformableMailer\nobject: !ruby/class \'NotificationMailer\'\nmethod_name: :comment\nargs:\n- !ruby/ActiveRecord:Comment\n  attributes:\n    id: 110\n    user_id: 1\n    post_id: \'42\'\n    content: ! \'dsfasdf\n\n      asd\n\n      gasdgggggggggggggg\'\n    created_at: 2013-08-31 12:43:46.266687000 Z\n    updated_at: 2013-08-31 12:43:46.266687000 Z\n',NULL,'2013-08-31 12:43:46',NULL,NULL,NULL,NULL,'2013-08-31 12:43:46','2013-08-31 12:43:46'),
	(35,0,0,'--- !ruby/object:Delayed::PerformableMailer\nobject: !ruby/class \'NotificationMailer\'\nmethod_name: :comment\nargs:\n- !ruby/ActiveRecord:Comment\n  attributes:\n    id: 112\n    user_id: 1\n    post_id: \'42\'\n    content: ! \'dsgafg\n\n\n      adsga\'\n    created_at: 2013-08-31 12:46:03.750891000 Z\n    updated_at: 2013-08-31 12:46:03.750891000 Z\n',NULL,'2013-08-31 12:46:03',NULL,NULL,NULL,NULL,'2013-08-31 12:46:03','2013-08-31 12:46:03'),
	(36,0,0,'--- !ruby/object:Delayed::PerformableMailer\nobject: !ruby/class \'NotificationMailer\'\nmethod_name: :comment\nargs:\n- !ruby/ActiveRecord:Comment\n  attributes:\n    id: 119\n    user_id: 1\n    post_id: \'42\'\n    content: ! \'fghjkdjh\n\n      sdf\n\n      adgadsgadsga\'\n    created_at: 2013-09-01 09:56:28.741167000 Z\n    updated_at: 2013-09-01 09:56:28.741167000 Z\n',NULL,'2013-09-01 09:56:29',NULL,NULL,NULL,NULL,'2013-09-01 09:56:29','2013-09-01 09:56:29'),
	(37,0,0,'--- !ruby/object:Delayed::PerformableMailer\nobject: !ruby/class \'NotificationMailer\'\nmethod_name: :comment\nargs:\n- !ruby/ActiveRecord:Comment\n  attributes:\n    id: 120\n    user_id: 2\n    post_id: \'58\'\n    content: ! \'fghjklsdkjgfadg\n\n\n      adgadfadsgadsg\'\n    created_at: 2013-09-01 11:10:04.509565000 Z\n    updated_at: 2013-09-01 11:10:04.509565000 Z\n',NULL,'2013-09-01 11:10:04',NULL,NULL,NULL,NULL,'2013-09-01 11:10:04','2013-09-01 11:10:04'),
	(38,0,0,'--- !ruby/object:Delayed::PerformableMailer\nobject: !ruby/class \'NotificationMailer\'\nmethod_name: :comment\nargs:\n- !ruby/ActiveRecord:Comment\n  attributes:\n    id: 121\n    user_id: 1\n    post_id: \'42\'\n    content: ! \'asdfasdf\n\n      asdfasdfasdf\'\n    created_at: 2013-09-01 11:12:23.623733000 Z\n    updated_at: 2013-09-01 11:12:23.623733000 Z\n',NULL,'2013-09-01 11:12:23',NULL,NULL,NULL,NULL,'2013-09-01 11:12:23','2013-09-01 11:12:23'),
	(39,0,0,'--- !ruby/object:Delayed::PerformableMailer\nobject: !ruby/class \'NotificationMailer\'\nmethod_name: :comment\nargs:\n- !ruby/ActiveRecord:Comment\n  attributes:\n    id: 122\n    user_id: 1\n    post_id: \'42\'\n    content: ! \'fasdfadsg\n\n      adgadgadgadg\'\n    created_at: 2013-09-01 11:13:20.853638000 Z\n    updated_at: 2013-09-01 11:13:20.853638000 Z\n',NULL,'2013-09-01 11:13:20',NULL,NULL,NULL,NULL,'2013-09-01 11:13:20','2013-09-01 11:13:20'),
	(40,0,0,'--- !ruby/object:Delayed::PerformableMailer\nobject: !ruby/class \'NotificationMailer\'\nmethod_name: :comment\nargs:\n- !ruby/ActiveRecord:Comment\n  attributes:\n    id: 123\n    user_id: 1\n    post_id: \'42\'\n    content: ! \'fdfgadgad\n\n      adfgadfgadgadg\'\n    created_at: 2013-09-01 11:15:13.825279000 Z\n    updated_at: 2013-09-01 11:15:13.825279000 Z\n',NULL,'2013-09-01 11:15:13',NULL,NULL,NULL,NULL,'2013-09-01 11:15:13','2013-09-01 11:15:13'),
	(41,0,0,'--- !ruby/object:Delayed::PerformableMailer\nobject: !ruby/class \'NotificationMailer\'\nmethod_name: :rating\nargs:\n- !ruby/ActiveRecord:Rating\n  attributes:\n    id: 19\n    user_id: 1\n    ratable_type: Comment\n    ratable_id: 81\n    positive: 0\n    negative: 1\n    created_at: 2013-09-01 11:34:12.748969000 Z\n    updated_at: 2013-09-01 11:34:12.748969000 Z\n',NULL,'2013-09-01 11:34:13',NULL,NULL,NULL,NULL,'2013-09-01 11:34:13','2013-09-01 11:34:13'),
	(42,0,0,'--- !ruby/object:Delayed::PerformableMailer\nobject: !ruby/class \'NotificationMailer\'\nmethod_name: :rating\nargs:\n- !ruby/ActiveRecord:Rating\n  attributes:\n    id: 20\n    user_id: 1\n    ratable_type: Comment\n    ratable_id: 38\n    positive: 0\n    negative: 1\n    created_at: 2013-09-01 11:35:24.140784000 Z\n    updated_at: 2013-09-01 11:35:24.140784000 Z\n',NULL,'2013-09-01 11:35:24',NULL,NULL,NULL,NULL,'2013-09-01 11:35:24','2013-09-01 11:35:24'),
	(43,0,0,'--- !ruby/object:Delayed::PerformableMailer\nobject: !ruby/class \'NotificationMailer\'\nmethod_name: :rating\nargs:\n- !ruby/ActiveRecord:Rating\n  attributes:\n    id: 21\n    user_id: 1\n    ratable_type: Comment\n    ratable_id: 120\n    positive: 1\n    negative: 0\n    created_at: 2013-09-01 11:36:59.841129000 Z\n    updated_at: 2013-09-01 11:36:59.841129000 Z\n',NULL,'2013-09-01 11:36:59',NULL,NULL,NULL,NULL,'2013-09-01 11:36:59','2013-09-01 11:36:59'),
	(44,0,0,'--- !ruby/object:Delayed::PerformableMailer\nobject: !ruby/class \'NotificationMailer\'\nmethod_name: :rating\nargs:\n- !ruby/ActiveRecord:Rating\n  attributes:\n    id: 22\n    user_id: 1\n    ratable_type: Comment\n    ratable_id: 54\n    positive: 1\n    negative: 0\n    created_at: 2013-09-14 09:56:55.275709000 Z\n    updated_at: 2013-09-14 09:56:55.275709000 Z\n',NULL,'2013-09-14 09:56:55',NULL,NULL,NULL,NULL,'2013-09-14 09:56:55','2013-09-14 09:56:55'),
	(45,0,0,'--- !ruby/object:Delayed::PerformableMailer\nobject: !ruby/class \'NotificationMailer\'\nmethod_name: :rating\nargs:\n- !ruby/ActiveRecord:Rating\n  attributes:\n    id: 23\n    user_id: 1\n    ratable_type: Comment\n    ratable_id: 54\n    positive: 1\n    negative: 0\n    created_at: 2013-09-14 10:08:12.046896000 Z\n    updated_at: 2013-09-14 10:08:12.046896000 Z\n',NULL,'2013-09-14 10:08:12',NULL,NULL,NULL,NULL,'2013-09-14 10:08:12','2013-09-14 10:08:12');

/*!40000 ALTER TABLE `delayed_jobs` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table media
# ------------------------------------------------------------

DROP TABLE IF EXISTS `media`;

CREATE TABLE `media` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `asset_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `asset_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `asset_file_size` int(11) DEFAULT NULL,
  `asset_updated_at` datetime DEFAULT NULL,
  `crop_x` int(11) DEFAULT NULL,
  `crop_y` int(11) DEFAULT NULL,
  `crop_w` int(11) DEFAULT NULL,
  `crop_h` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `media` WRITE;
/*!40000 ALTER TABLE `media` DISABLE KEYS */;

INSERT INTO `media` (`id`, `title`, `description`, `created_at`, `updated_at`, `asset_file_name`, `asset_content_type`, `asset_file_size`, `asset_updated_at`, `crop_x`, `crop_y`, `crop_w`, `crop_h`)
VALUES
	(12,'skjdhfgp09w3rw','','2013-05-06 09:29:06','2013-06-16 04:18:14','new-year-card-2011-1.jpg','image/jpeg',510289,'2013-06-16 04:18:14',439,197,285,226),
	(14,'text upload test','','2013-05-06 09:47:03','2013-06-16 04:18:15','story.txt','text/plain',3559,'2013-06-16 04:18:15',NULL,NULL,NULL,NULL),
	(38,'Tumblr ljxpzc7lse1qg9taqo1 1280',NULL,'2013-05-26 12:02:37','2013-06-16 04:18:17','tumblr_ljxpzc7lSE1qg9taqo1_1280.jpg','image/jpeg',260164,'2013-06-16 04:18:15',NULL,NULL,NULL,NULL),
	(39,'Tumblr m1u8cqkcdn1qg9taqo1 1280',NULL,'2013-05-26 12:02:55','2013-06-16 04:18:18','tumblr_m1u8cqkCDn1qg9taqo1_1280.jpg','image/jpeg',380479,'2013-06-16 04:18:17',NULL,NULL,NULL,NULL),
	(40,'Tumblr mhqen35hrf1qg9taqo1 1280',NULL,'2013-05-26 12:06:12','2013-06-16 04:18:20','tumblr_mhqen35hrf1qg9taqo1_1280.jpg','image/jpeg',316346,'2013-06-16 04:18:18',NULL,NULL,NULL,NULL),
	(41,'Tumblr mhs24hkurr1qg9taqo1 1280',NULL,'2013-05-26 12:19:57','2013-06-16 04:18:22','tumblr_mhs24hkUrR1qg9taqo1_1280.jpg','image/jpeg',382770,'2013-06-16 04:18:20',NULL,NULL,NULL,NULL),
	(42,'Tumblr lzdcc9yblo1qg9taqo1 1280',NULL,'2013-05-26 12:20:11','2013-06-16 04:18:24','tumblr_lzdcc9yblo1qg9taqo1_1280.jpg','image/jpeg',200092,'2013-06-16 04:18:22',NULL,NULL,NULL,NULL),
	(50,'5085474884 fd6b9799eb b',NULL,'2013-05-27 11:35:47','2013-06-16 04:18:25','5085474884_fd6b9799eb_b.jpg','image/jpeg',271021,'2013-06-16 04:18:24',NULL,NULL,NULL,NULL),
	(51,'5275866445 42cbd4028b b',NULL,'2013-05-27 11:35:48','2013-06-16 04:18:27','5275866445_42cbd4028b_b.jpg','image/jpeg',242685,'2013-06-16 04:18:25',NULL,NULL,NULL,NULL),
	(52,'5442990196 ae7b0ace38 b',NULL,'2013-05-27 11:35:50','2013-06-16 04:18:29','5442990196_ae7b0ace38_b.jpg','image/jpeg',405518,'2013-06-16 04:18:27',NULL,NULL,NULL,NULL),
	(54,'5318631164 0d6d533d57 b',NULL,'2013-05-27 11:37:22','2013-06-16 04:18:31','5318631164_0d6d533d57_b.jpg','image/jpeg',245232,'2013-06-16 04:18:29',NULL,NULL,NULL,NULL),
	(55,'5373370511 35e415d35b b',NULL,'2013-05-27 11:37:24','2013-06-16 04:18:32','5373370511_35e415d35b_b.jpg','image/jpeg',385761,'2013-06-16 04:18:31',NULL,NULL,NULL,NULL),
	(80,'Tumblr lkpeyhlqe91qho97ro1 r2 1280',NULL,'2013-05-31 11:49:34','2013-06-16 04:18:34','tumblr_lkpeyhLQE91qho97ro1_r2_1280.jpg','image/jpeg',313363,'2013-06-16 04:18:32',NULL,NULL,NULL,NULL),
	(81,'Tumblr llfka6cvsr1qho97ro1 1280',NULL,'2013-05-31 11:49:34','2013-06-16 04:18:35','tumblr_llfka6CVsR1qho97ro1_1280.jpg','image/jpeg',297615,'2013-06-16 04:18:34',NULL,NULL,NULL,NULL),
	(82,'Tumblr lllzzwyzlu1qho97ro1 r1 1280',NULL,'2013-05-31 11:51:28','2013-06-16 04:18:36','tumblr_lllzzwYZlu1qho97ro1_r1_1280.jpg','image/jpeg',443640,'2013-06-16 04:18:35',NULL,NULL,NULL,NULL),
	(83,'Tumblr llpvkcswmh1qho97ro1 r1 1280','','2013-05-31 11:51:29','2013-06-16 04:18:38','tumblr_llpvkcsWMH1qho97ro1_r1_1280.jpg','image/jpeg',370859,'2013-06-16 04:18:36',NULL,NULL,NULL,NULL),
	(84,'Without Order Nothig Can Exist','Without Chaos Nothing Can Evolve','2013-05-31 11:51:32','2013-06-16 04:18:39','tumblr_lm0zcb3Pu21qho97ro1_1280.jpg','image/jpeg',436569,'2013-06-16 04:18:38',NULL,NULL,NULL,NULL),
	(85,'Eat Right. Exercise. Die Anyway','','2013-05-31 11:51:49','2013-06-16 04:18:41','tumblr_lm4jmsc4kK1qho97ro1_1280.jpg','image/jpeg',288096,'2013-06-16 04:18:39',NULL,NULL,NULL,NULL),
	(86,'If You Work Real Hard','','2013-05-31 11:51:50','2013-06-16 04:18:42','tumblr_lm2qkqxRbY1qho97ro1_r1_1280.jpg','image/jpeg',357582,'2013-06-16 04:18:41',NULL,NULL,NULL,NULL),
	(87,'You\'d be Surprised ','How Often What If Works','2013-05-31 11:52:04','2013-06-16 04:18:43','tumblr_lmnn1zKRrz1qho97ro1_1280.jpg','image/jpeg',422730,'2013-06-16 04:18:42',NULL,NULL,NULL,NULL),
	(88,'The World is Cruel','','2013-05-31 11:52:05','2013-06-16 04:18:45','tumblr_lm8jgwsiqr1qho97ro1_r1_1280.jpg','image/jpeg',446304,'2013-06-16 04:18:43',NULL,NULL,NULL,NULL),
	(91,'All Endings are also Beginnings','','2013-05-31 11:52:27','2013-06-16 04:18:46','tumblr_lohki76o7n1qho97ro1_1280.jpg','image/jpeg',411507,'2013-06-16 04:18:45',NULL,NULL,NULL,NULL),
	(92,'I\'m Afraid I\'ll Forget How Happy We were','','2013-05-31 11:52:28','2013-06-16 04:18:48','tumblr_lojisl2IhE1qho97ro1_1280.jpg','image/jpeg',435868,'2013-06-16 04:18:46',NULL,NULL,NULL,NULL),
	(93,'Sometimes I Just Need Someone to Talk to','','2013-05-31 11:52:36','2013-06-16 04:18:50','tumblr_lphlu9HfWg1qho97ro1_1280.jpg','image/jpeg',305361,'2013-06-16 04:18:48',NULL,NULL,NULL,NULL),
	(94,'We Wander for Distraction','','2013-05-31 11:52:53','2013-06-16 04:18:52','tumblr_lr0g40xI8T1qho97ro1_r1_1280.jpg','image/jpeg',489324,'2013-06-16 04:18:50',NULL,NULL,NULL,NULL),
	(97,'I am an Adventurer','hjgjhg','2013-05-31 11:54:46','2013-06-16 04:18:53','tumblr_lv00dkkCVj1qho97ro1_1280.jpg','image/jpeg',438092,'2013-06-16 04:18:52',NULL,NULL,NULL,NULL),
	(226,'Goals are Dreams with Deadline','','2013-06-15 11:06:46','2013-06-16 04:18:55','tumblr_livryeurae1qho97ro1_1280.jpg','image/jpeg',305827,'2013-06-16 04:18:53',NULL,NULL,NULL,NULL),
	(227,'Courage is the Power to Let Go of the Familiar','','2013-06-15 11:06:46','2013-06-16 04:18:56','tumblr_m00pjatAPZ1qho97ro1_1280.jpg','image/jpeg',288732,'2013-06-16 04:18:55',NULL,NULL,NULL,NULL),
	(228,'A Good Traveler','','2013-06-15 11:06:49','2013-06-16 04:18:57','tumblr_m09yx6a1p11qho97ro1_1280.jpg','image/jpeg',361202,'2013-06-16 04:18:57',210,157,486,231),
	(229,'Standard of Living','','2013-06-15 11:06:49','2013-06-16 04:19:00','tumblr_lxsq433BnZ1qho97ro1_1280.jpg','image/jpeg',361282,'2013-06-16 04:19:00',278,342,148,145),
	(230,'True Friendship is Set on Fire','','2013-06-15 11:06:51','2013-06-16 04:19:03','tumblr_lo2zi2d5Y61qho97ro1_r1_1280.jpg','image/jpeg',380866,'2013-06-16 04:19:03',390,46,227,127),
	(231,'Tracks of My Tears','','2013-06-15 14:20:23','2013-06-16 04:19:05','Tracks_of_My_Tears.mp3','audio/mp3',2463036,'2013-06-16 04:19:04',NULL,NULL,NULL,NULL),
	(233,'Spring','sdfj\ndfghjkr\n345678','2013-06-15 16:02:29','2013-06-28 14:24:48','2560x1600.jpg','image/jpeg',3095728,'2013-06-16 04:19:05',NULL,NULL,NULL,NULL),
	(234,'Story overview','','2013-06-15 16:22:42','2013-06-17 05:37:07','story-overview.jpg','image/jpeg',122535,'2013-06-17 05:37:07',231,535,375,277),
	(249,'5763873044 e7a1a60da7','','2013-06-17 12:51:12','2013-07-26 07:56:58','5763873044_e7a1a60da7_b.jpg','image/jpeg',218622,'2013-06-17 12:51:09',NULL,NULL,NULL,NULL);

/*!40000 ALTER TABLE `media` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table oauths
# ------------------------------------------------------------

DROP TABLE IF EXISTS `oauths`;

CREATE TABLE `oauths` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `uid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `provider` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `token_expires_at` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `token_secret` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `avatar_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `avatar_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `avatar_file_size` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_oauths_on_uid` (`uid`),
  KEY `index_oauths_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `oauths` WRITE;
/*!40000 ALTER TABLE `oauths` DISABLE KEYS */;

INSERT INTO `oauths` (`id`, `user_id`, `uid`, `provider`, `token`, `token_expires_at`, `token_secret`, `avatar_file_name`, `avatar_content_type`, `avatar_file_size`, `created_at`, `updated_at`)
VALUES
	(19,1,'148334424','twitter','148334424-tfeF62cliaJcIfYJjHzAz7FVDs1lSFDjiY4onGup',NULL,'PzWHUVGuYA5TCA15nk8kdxihKHD60FTxYg24KiNJqfg','open-uri20130624-98197-fv5gc6','image/png',11234,'2013-06-24 10:07:54','2013-06-24 10:07:54');

/*!40000 ALTER TABLE `oauths` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table pages
# ------------------------------------------------------------

DROP TABLE IF EXISTS `pages`;

CREATE TABLE `pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `slug` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `excerpt` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_pages_on_slug` (`slug`),
  KEY `index_pages_on_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `pages` WRITE;
/*!40000 ALTER TABLE `pages` DISABLE KEYS */;

INSERT INTO `pages` (`id`, `user_id`, `status`, `slug`, `title`, `excerpt`, `content`, `created_at`, `updated_at`)
VALUES
	(1,NULL,0,'test','テストページ','','this is test page','2013-05-11 10:09:54','2013-05-11 10:13:16');

/*!40000 ALTER TABLE `pages` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table posts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `posts`;

CREATE TABLE `posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` int(11) DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `excerpt` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `thumbnail_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_posts_on_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;

INSERT INTO `posts` (`id`, `status`, `title`, `excerpt`, `content`, `user_id`, `created_at`, `updated_at`, `thumbnail_id`)
VALUES
	(1,0,'Post Title #1','','post content #1',1,'2013-04-08 01:38:06','2013-04-08 01:38:06',NULL),
	(2,0,'Post Title #2','','post content #2',1,'2013-04-08 01:38:37','2013-04-08 01:38:37',NULL),
	(4,0,'67876567876567',NULL,'dsfajksdhbfailsdhbfasdjfabhksdblvcasdbjlhvcads\r\n\r\n',1,'2013-04-17 14:15:12','2013-04-26 07:04:37',NULL),
	(5,0,'dksfhadksg',NULL,'dkfasdjgads',1,'2013-04-18 06:06:21','2013-04-18 06:06:21',NULL),
	(7,0,'589678isfhaios',NULL,'dsfhadfhajdshkjfasdjkfhkajs\r\n\r\njfapsdf\r\n\r\ndasf',1,'2013-04-18 06:08:58','2013-04-18 06:09:14',NULL),
	(8,0,'aaaodshfaipsdhfa',NULL,'',1,'2013-04-18 06:15:28','2013-04-18 06:15:28',NULL),
	(9,0,'dsbfaoierubfpaiedubfaidsbf',NULL,'',1,'2013-04-18 06:18:08','2013-04-18 06:18:08',NULL),
	(11,0,'kasjdfhgaoiefasda',NULL,'ads\r\n\r\n',1,'2013-04-18 06:22:36','2013-04-18 13:52:43',NULL),
	(20,0,'45678i9op',NULL,'',1,'2013-04-19 15:07:00','2013-04-19 15:07:00',NULL),
	(21,0,'45678i',NULL,'',1,'2013-04-19 15:07:23','2013-04-19 15:07:23',NULL),
	(23,0,'aaaaa',NULL,'sdfghjkl;',1,'2013-04-20 02:20:48','2013-04-20 02:20:57',NULL),
	(24,0,'ghhhuj',NULL,'',1,'2013-04-20 02:43:24','2013-04-20 02:43:24',NULL),
	(25,0,'ugoigoigoiuouoi',NULL,'\r\n\r\ndsaf\r\n\r\nsfas',1,'2013-04-20 02:47:40','2013-04-22 12:29:45',NULL),
	(30,0,'fjkbsdkjfbakdsjbflkjadsbkjgfabdsk',NULL,'',1,'2013-04-26 13:41:06','2013-04-26 13:41:06',NULL),
	(32,0,'a',NULL,'',1,'2013-04-26 13:41:34','2013-04-26 13:41:34',NULL),
	(33,0,'ab',NULL,'',1,'2013-04-26 13:41:42','2013-04-26 13:41:42',NULL),
	(34,0,'abc',NULL,'',1,'2013-04-26 13:41:48','2013-04-26 13:41:48',NULL),
	(35,0,'dsfasdfasdf',NULL,'',1,'2013-04-26 13:41:57','2013-04-26 13:41:57',NULL),
	(36,0,'f34rfwer34qafds',NULL,'',1,'2013-04-26 13:42:03','2013-04-26 13:42:03',NULL),
	(37,0,'43tfw43qtdsq34q4t3g',NULL,'',1,'2013-04-26 13:42:15','2013-04-26 13:42:15',NULL),
	(38,0,'mMMjMKJfjhsda',NULL,'',1,'2013-04-26 13:42:24','2013-04-26 13:42:24',NULL),
	(39,0,'IYGODIYBEHJLSVHJSF',NULL,'',1,'2013-04-26 13:42:31','2013-04-26 13:42:31',NULL),
	(40,0,'daehkwfgljkhwaefiweudfhbaedsfasd',NULL,'',1,'2013-04-26 13:42:38','2013-04-26 13:42:38',NULL),
	(42,1,'daskgfhadsg',NULL,'dsafasfasdf\n\nsdaf\n\n<img src=\"/system/media/000/000/249/small.jpg?1371473469\" alt=\"\" />\n<img src=\"/system/media/000/000/229/small.jpg?1371356340\" alt=\"\" />\n<img src=\"/system/media/000/000/226/small.jpg?1371356333\" alt=\"\" />\n',2,'2013-04-27 04:51:00','2013-07-05 05:17:42',94),
	(43,1,'0101010101010101',NULL,'sdafsdf\nsdf\nasd\nf\nasdf',2,'2013-04-27 04:51:00','2013-07-05 15:54:15',50),
	(44,0,'qwertyuio',NULL,'',1,'2013-04-27 04:51:00','2013-06-17 13:17:17',NULL),
	(45,1,'asdfghjkl',NULL,'',1,'2013-04-27 04:51:00','2013-06-18 15:01:48',NULL),
	(46,1,'zxcvbnm',NULL,'',1,'2013-04-27 04:51:00','2013-06-18 15:01:48',NULL),
	(49,0,'tgbnhy',NULL,'',1,'2013-04-27 04:52:00','2013-06-22 09:25:47',38),
	(50,1,'yhnmju',NULL,'',1,'2013-04-27 04:52:00','2013-06-09 08:57:38',39),
	(52,0,'adsfadsgads7898346732898374',NULL,'adsf\r\n\r\ndsaf',1,'2013-04-27 13:59:00','2013-06-09 08:57:00',40),
	(53,1,'skadfghlaksdf',NULL,'\ndsaf\n\nsdaf\nafas\n\ndag\nd\nga\nd\n\n\nsdaf\ndafgad',1,'2013-06-27 09:56:00','2013-07-11 13:11:06',41),
	(58,0,'記事のタイトル',NULL,'<p>そのころわたくしは、モリーオ市の博物局に勤めて居りました。</p>\n\n<p>十八等官でしたから役所のなかでも、ずうっと下の方でしたし俸給ほうきゅうもほんのわずかでしたが、受持ちが標本の採集や整理で生れ付き好きなことでしたから、わたくしは毎日ずいぶん愉快にはたらきました。殊にそのころ、モリーオ市では競馬場を植物園に拵こしらえ直すというので、その景色のいいまわりにアカシヤを植え込んだ広い地面が、切符売場や信号所の建物のついたまま、わたくしどもの役所の方へまわって来たものですから、わたくしはすぐ宿直という名前で月賦で買った小さな蓄音器と二十枚ばかりのレコードをもって、その番小屋にひとり住むことになりました。わたくしはそこの馬を置く場所に板で小さなしきいをつけて一疋の山羊を飼いました。毎朝その乳をしぼってつめたいパンをひたしてたべ、それから黒い革のかばんへすこしの書類や雑誌を入れ、靴もきれいにみがき、並木のポプラの影法師を大股にわたって市の役所へ出て行くのでした。</p>\n\n<p>あのイーハトーヴォのすきとおった風、夏でも底に冷たさをもつ青いそら、うつくしい森で飾られたモリーオ市、郊外のぎらぎらひかる草の波。</p>\n\n<p>またそのなかでいっしょになったたくさんのひとたち、ファゼーロとロザーロ、羊飼のミーロや、顔の赤いこどもたち、地主のテーモ、山猫博士のボーガント・デストゥパーゴなど、いまこの暗い巨きな石の建物のなかで考えていると、みんなむかし風のなつかしい青い幻燈のように思われます。では、わたくしはいつかの小さなみだしをつけながら、しずかにあの年のイーハトーヴォの五月から十月までを書きつけましょう。</p>\n',1,'2013-06-27 16:52:00','2013-07-11 12:58:00',12),
	(88,0,'どうでもいい記事213',NULL,'　高瀬舟たかせぶねは京都の高瀬川を上下する小舟である。徳川時代に京都の罪人が遠島ゑんたうを申し渡されると、本人の親類が牢屋敷へ呼び出されて、そこで暇乞いとまごひをすることを許された。それから罪人は高瀬舟に載せられて、大阪へ廻されることであつた。それを護送するのは、京都町奉行の配下にゐる同心で、此同心は罪人の親類の中で、主立つた一人を大阪まで同船させることを許す慣例であつた。これは上へ通つた事ではないが、所謂大目に見るのであつた、默許であつた。\n\n> 當時遠島を申し渡された罪人は、\n> 勿論重い科を犯したものと認められた人ではあるが、\n> 決して盜をするために、\n> 人を殺し火を放つたと云ふやうな、\n> 獰惡だうあくな人物が多數を占めてゐたわけではない。\n\n高瀬舟に乘る罪人の過半は、所謂心得違のために、想はぬ科とがを犯した人であつた。有り觸れた例を擧げて見れば、當時相對死と云つた情死を謀つて、相手の女を殺して、自分だけ活き殘つた男と云ふやうな類である。\n\n　さう云ふ罪人を載せて、入相いりあひの鐘の鳴る頃に漕ぎ出された高瀬舟は、黒ずんだ京都の町の家々を兩岸に見つつ、東へ走つて、加茂川を横ぎつて下るのであつた。此舟の中で、罪人と其親類の者とは夜どほし身の上を語り合ふ。いつもいつも悔やんでも還らぬ繰言である。護送の役をする同心は、傍でそれを聞いて、罪人を出した親戚眷族けんぞくの悲慘な境遇を細かに知ることが出來た。所詮町奉行所の白洲しらすで、表向の口供を聞いたり、役所の机の上で、口書くちがきを讀んだりする役人の夢にも窺ふことの出來ぬ境遇である。\n　同心を勤める人にも、種々の性質があるから、此時只うるさいと思つて、耳を掩ひたく思ふ冷淡な同心があるかと思へば、又しみじみと人の哀を身に引き受けて、役柄ゆゑ氣色には見せぬながら、無言の中に私かに胸を痛める同心もあつた。場合によつて非常に悲慘な境遇に陷つた罪人と其親類とを、特に心弱い、涙脆い同心が宰領して行くことになると、其同心は不覺の涙を禁じ得ぬのであつた。\n　そこで高瀬舟の護送は、町奉行所の同心仲間で、不快な職務として嫌はれてゐた。\n\n　いつの頃であつたか。多分江戸で白河樂翁侯が政柄せいへいを執つてゐた寛政の頃ででもあつただらう。智恩院ちおんゐんの櫻が入相の鐘に散る春の夕に、これまで類のない、珍らしい罪人が高瀬舟に載せられた。\n　それは名を喜助と云つて、三十歳ばかりになる、住所不定の男である。固より牢屋敷に呼び出されるやうな親類はないので、舟にも只一人で乘つた。\n　護送を命ぜられて、一しよに舟に乘り込んだ同心羽田庄兵衞は、只喜助が弟殺しの罪人だと云ふことだけを聞いてゐた。さて牢屋敷から棧橋まで連れて來る間、この痩肉やせじしの、色の蒼白い喜助の樣子を見るに、いかにも神妙に、いかにもおとなしく、自分をば公儀の役人として敬つて、何事につけても逆はぬやうにしてゐる。しかもそれが、罪人の間に往々見受けるやうな、温順を裝つて權勢に媚びる態度ではない。\n　庄兵衞は不思議に思つた。そして舟に乘つてからも、單に役目の表で見張つてゐるばかりでなく、絶えず喜助の擧動に、細かい注意をしてゐた。\n　其日は暮方から風が歇やんで、空一面を蔽つた薄い雲が、月の輪廓をかすませ、やうやう近寄つて來る夏の温さが、兩岸の土からも、川床の土からも、靄になつて立ち昇るかと思はれる夜であつた。下京の町を離れて、加茂川を横ぎつた頃からは、あたりがひつそりとして、只舳へさきに割かれる水のささやきを聞くのみである。\n　夜舟で寢ることは、罪人にも許されてゐるのに、喜助は横にならうともせず、雲の濃淡に從つて、光の増したり減じたりする月を仰いで、默つてゐる。其額は晴やかで目には微かなかがやきがある。\n　庄兵衞はまともには見てゐぬが、始終喜助の顏から目を離さずにゐる。そして不思議だ、不思議だと、心の内で繰り返してゐる。それは喜助の顏が縱から見ても、横から見ても、いかにも樂しさうで、若し役人に對する氣兼がなかつたなら、口笛を吹きはじめるとか、鼻歌を歌ひ出すとかしさうに思はれたからである。\n　庄兵衞は心の内に思つた。これまで此高瀬舟の宰領をしたことは幾度だか知れない。しかし載せて行く罪人は、いつも殆ど同じやうに、目も當てられぬ氣の毒な樣子をしてゐた。それに此男はどうしたのだらう。遊山船にでも乘つたやうな顏をしてゐる。罪は弟を殺したのださうだが、よしや其弟が惡い奴で、それをどんな行掛りになつて殺したにせよ、人の情として好い心持はせぬ筈である。この色の蒼い痩男が、その人の情と云ふものが全く缺けてゐる程の、世にも稀な惡人であらうか。どうもさうは思はれない。ひよつと氣でも狂つてゐるのではあるまいか。いやいや。それにしては何一つ辻褄の合はぬ言語や擧動がない。此男はどうしたのだらう。庄兵衞がためには喜助の態度が考へれば考へる程わからなくなるのである。\n\n　　　　　――――――――――――――――\n\n　暫くして、庄兵衞はこらへ切れなくなつて呼び掛けた。「喜助。お前何を思つてゐるのか。」\n「はい」と云つてあたりを見廻した喜助は、何事をかお役人に見咎められたのではないかと氣遣ふらしく、居ずまひを直して庄兵衞の氣色を伺つた。\n　庄兵衞は自分が突然問を發した動機を明して、役目を離れた應對を求める分疏いひわけをしなくてはならぬやうに感じた。そこでかう云つた。「いや。別にわけがあつて聞いたのではない。實はな、己は先刻からお前の島へ往く心持が聞いて見たかつたのだ。己はこれまで此舟で大勢の人を島へ送つた。それは隨分いろいろな身の上の人だつたが、どれもどれも島へ往くのを悲しがつて、見送りに來て、一しよに舟に乘る親類のものと、夜どほし泣くに極まつてゐた。それにお前の樣子を見れば、どうも島へ往くのを苦にしてはゐないやうだ。一體お前はどう思つてゐるのだい。」\n　喜助はにつこり笑つた。「御親切に仰やつて下すつて、難有うございます。なる程島へ往くといふことは、外の人には悲しい事でございませう。其心持はわたくしにも思ひ遣つて見ることが出來ます。しかしそれは世間で樂をしてゐた人だからでございます。京都は結構な土地ではございますが、その結構な土地で、これまでわたくしのいたして參つたやうな苦みは、どこへ參つてもなからうと存じます。お上のお慈悲で、命を助けて島へ遣つて下さいます。島はよしやつらい所でも、鬼の栖すむ所ではございますまい。わたくしはこれまで、どこと云つて自分のゐて好い所と云ふものがございませんでした。こん度お上で島にゐろと仰やつて下さいます。そのゐろと仰やる所に落ち著いてゐることが出來ますのが、先づ何よりも難有い事でございます。それにわたくしはこんなにかよわい體ではございますが、つひぞ病氣をいたしたことがございませんから、島へ往つてから、どんなつらい爲事をしたつて、體を痛めるやうなことはあるまいと存じます。それからこん度島へお遣下さるに付きまして、二百文の鳥目てうもくを戴きました。それをここに持つてをります。」かう云ひ掛けて、喜助は胸に手を當てた。遠島を仰せ附けられるものには、鳥目二百銅を遣すと云ふのは、當時の掟であつた。\n　喜助は語を續いだ。「お恥かしい事を申し上げなくてはなりませぬが、わたくしは今日まで二百文と云ふお足を、かうして懷に入れて持つてゐたことはございませぬ。どこかで爲事しごとに取り附きたいと思つて、爲事を尋ねて歩きまして、それが見附かり次第、骨を惜まずに働きました。そして貰つた錢は、いつも右から左へ人手に渡さなくてはなりませなんだ。それも現金で物が買つて食べられる時は、わたくしの工面の好い時で、大抵は借りたものを返して、又跡を借りたのでございます。それがお牢に這入つてからは、爲事をせずに食べさせて戴きます。わたくしはそればかりでも、お上に對して濟まない事をいたしてゐるやうでなりませぬ。それにお牢を出る時に、此二百文を戴きましたのでございます。かうして相變らずお上の物を食べてゐて見ますれば、此二百文はわたくしが使はずに持つてゐることが出來ます。お足を自分の物にして持つてゐると云ふことは、わたくしに取つては、これが始でございます。島へ往つて見ますまでは、どんな爲事が出來るかわかりませんが、わたくしは此二百文を島でする爲事の本手にしようと樂しんでをります。」かう云つて、喜助は口を噤んだ。\n　庄兵衞は「うん、さうかい」とは云つたが、聞く事毎に餘り意表に出たので、これも暫く何も云ふことが出來ずに、考へ込んで默つてゐた。\n　庄兵衞は彼此初老に手の屆く年になつてゐて、もう女房に子供を四人生ませてゐる。それに老母が生きてゐるので、家は七人暮しである。平生人には吝嗇と云はれる程の、儉約な生活をしてゐて、衣類は自分が役目のために著るものの外、寢卷しか拵へぬ位にしてゐる。しかし不幸な事には、妻を好い身代の商人の家から迎へた。そこで女房は夫の貰ふ扶持米で暮しを立てて行かうとする善意はあるが、裕な家に可哀がられて育つた癖があるので、夫が滿足する程手元を引き締めて暮して行くことが出來ない。動もすれば月末になつて勘定が足りなくなる。すると女房が内證で里から金を持つて來て帳尻を合はせる。それは夫が借財と云ふものを毛蟲のやうに嫌ふからである。さう云ふ事は所詮夫に知れずにはゐない。庄兵衞は五節句だと云つては、里方から物を貰ひ、子供の七五三の祝だと云つては、里方から子供に衣類を貰ふのでさへ、心苦しく思つてゐるのだから、暮しの穴を填うめて貰つたのに氣が附いては、好い顏はしない。格別平和を破るやうな事のない羽田の家に、折々波風の起るのは、是が原因である。\n　庄兵衞は今喜助の話を聞いて、喜助の身の上をわが身の上に引き比べて見た。喜助は爲事をして給料を取つても、右から左へ人手に渡して亡くしてしまふと云つた。いかにも哀な、氣の毒な境界である。しかし一轉して我身の上を顧みれば、彼と我との間に、果してどれ程の差があるか。自分も上から貰ふ扶持米ふちまいを、右から左へ人手に渡して暮してゐるに過ぎぬではないか。彼と我との相違は、謂はば十露盤そろばんの桁が違つてゐるだけで、喜助の難有がる二百文に相當する貯蓄だに、こつちはないのである。\n　さて桁を違へて考へて見れば、鳥目二百文をでも、喜助がそれを貯蓄と見て喜んでゐるのに無理はない。其心持はこつちから察して遣ることが出來る。しかしいかに桁を違へて考へて見ても、不思議なのは喜助の慾のないこと、足ることを知つてゐることである。\n　喜助は世間で爲事を見附けるのに苦んだ。それを見附けさへすれば、骨を惜まずに働いて、やうやう口を糊することの出來るだけで滿足した。そこで牢に入つてからは、今まで得難かつた食が、殆ど天から授けられるやうに、働かずに得られるのに驚いて、生れてから知らぬ滿足を覺えたのである。\n　庄兵衞はいかに桁を違へて考へて見ても、ここに彼と我との間に、大いなる懸隔のあることを知つた。自分の扶持米で立てて行く暮しは、折々足らぬことがあるにしても、大抵出納が合つてゐる。手一ぱいの生活である。然るにそこに滿足を覺えたことは殆ど無い。常は幸とも不幸とも感ぜずに過してゐる。しかし心の奧には、かうして暮してゐて、ふいとお役が御免になつたらどうしよう、大病にでもなつたらどうしようと云ふ疑懼ぎくが潜んでゐて、折々妻が里方から金を取り出して來て穴填をしたことなどがわかると、此疑懼が意識の閾の上に頭を擡げて來るのである。\n　一體此懸隔はどうして生じて來るだらう。只上邊だけを見て、それは喜助には身に係累がないのに、こつちにはあるからだと云つてしまへばそれまでである。しかしそれはである。よしや自分が一人者であつたとしても、どうも喜助のやうな心持にはなられさうにない。この根柢はもつと深い處にあるやうだと、庄兵衞は思つた。\n　庄兵衞は只漠然と、人の一生といふやうな事を思つて見た。人は身に病があると、此病がなかつたらと思ふ。其日其日の食がないと、食つて行かれたらと思ふ。萬一の時に備へる蓄がないと、少しでも蓄があつたらと思ふ。蓄があつても、又其蓄がもつと多かつたらと思ふ。此の如くに先から先へと考へて見れば、人はどこまで往つて踏み止まることが出來るものやら分からない。それを今目の前で踏み止まつて見せてくれるのが此喜助だと、庄兵衞は氣が附いた。\n　庄兵衞は今さらのやうに驚異の目をみはつて喜助を見た。此時庄兵衞は空を仰いでゐる喜助の頭から毫光がうくわうがさすやうに思つた。\n',1,'2013-07-01 01:21:00','2013-08-31 11:56:57',234);

/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table ratings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `ratings`;

CREATE TABLE `ratings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `ratable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ratable_id` int(11) DEFAULT NULL,
  `positive` int(11) DEFAULT NULL,
  `negative` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_ratings_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `ratings` WRITE;
/*!40000 ALTER TABLE `ratings` DISABLE KEYS */;

INSERT INTO `ratings` (`id`, `user_id`, `ratable_type`, `ratable_id`, `positive`, `negative`, `created_at`, `updated_at`)
VALUES
	(2,1,'Comment',87,1,0,'2013-07-18 07:10:01','2013-07-18 07:10:01'),
	(3,10,'Comment',88,0,1,'2013-07-18 07:10:01','2013-07-18 07:10:01'),
	(5,1,'Comment',88,1,0,'2013-07-18 12:29:40','2013-07-18 12:29:40'),
	(6,2,'Comment',87,1,0,'2013-07-18 07:10:01','2013-07-18 07:10:01'),
	(18,1,'Comment',84,0,1,'2013-08-31 09:41:00','2013-08-31 09:41:00'),
	(19,1,'Comment',81,0,1,'2013-09-01 11:34:12','2013-09-01 11:34:12'),
	(20,1,'Comment',38,0,1,'2013-09-01 11:35:24','2013-09-01 11:35:24'),
	(21,1,'Comment',120,1,0,'2013-09-01 11:36:59','2013-09-01 11:36:59');

/*!40000 ALTER TABLE `ratings` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table schema_migrations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `schema_migrations`;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;

INSERT INTO `schema_migrations` (`version`)
VALUES
	('20130406133327'),
	('20130406165339'),
	('20130406170043'),
	('20130407235928'),
	('20130408025504'),
	('20130408045419'),
	('20130408045543'),
	('20130408045739'),
	('20130427072717'),
	('20130427131041'),
	('20130428102645'),
	('20130501011407'),
	('20130501011618'),
	('20130502060033'),
	('20130505081337'),
	('20130506054332'),
	('20130511093840'),
	('20130511114516'),
	('20130512073154'),
	('20130622083518'),
	('20130622083857'),
	('20130701011647'),
	('20130701012543'),
	('20130705151031'),
	('20130705151320'),
	('20130705152221'),
	('20130705153408'),
	('20130706061734'),
	('20130706061803'),
	('20130713024608'),
	('20130713033453'),
	('20130715131406'),
	('20130718065555'),
	('20130718101358'),
	('20130831103608'),
	('20130831145042'),
	('20130901121252');

/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table settings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `settings`;

CREATE TABLE `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `params` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_settings_on_user_id` (`user_id`),
  KEY `index_settings_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;

INSERT INTO `settings` (`id`, `user_id`, `params`, `name`)
VALUES
	(1,1,'---\n:type: 134329857\n','option_01');

/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table taggings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `taggings`;

CREATE TABLE `taggings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_id` int(11) DEFAULT NULL,
  `taggable_id` int(11) DEFAULT NULL,
  `taggable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tagger_id` int(11) DEFAULT NULL,
  `tagger_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `context` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_taggings_on_tag_id` (`tag_id`),
  KEY `index_taggings_on_taggable_id_and_taggable_type_and_context` (`taggable_id`,`taggable_type`,`context`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `taggings` WRITE;
/*!40000 ALTER TABLE `taggings` DISABLE KEYS */;

INSERT INTO `taggings` (`id`, `tag_id`, `taggable_id`, `taggable_type`, `tagger_id`, `tagger_type`, `context`, `created_at`)
VALUES
	(1,1,88,'Post',NULL,NULL,'tags','2013-06-22 08:48:25'),
	(2,2,88,'Post',NULL,NULL,'tags','2013-06-22 08:48:25'),
	(3,3,58,'Post',NULL,NULL,'tags','2013-06-22 09:23:57'),
	(4,4,58,'Post',NULL,NULL,'tags','2013-06-22 09:23:57'),
	(5,5,58,'Post',NULL,NULL,'tags','2013-06-22 09:24:20'),
	(6,6,58,'Post',NULL,NULL,'tags','2013-06-22 09:24:20'),
	(7,7,53,'Post',NULL,NULL,'tags','2013-06-22 09:25:02'),
	(8,8,53,'Post',NULL,NULL,'tags','2013-06-22 09:25:02'),
	(9,9,53,'Post',NULL,NULL,'tags','2013-06-22 09:25:02'),
	(10,10,53,'Post',NULL,NULL,'tags','2013-06-22 09:25:02'),
	(11,11,49,'Post',NULL,NULL,'tags','2013-06-22 09:25:47'),
	(12,12,49,'Post',NULL,NULL,'tags','2013-06-22 09:25:47'),
	(13,13,49,'Post',NULL,NULL,'tags','2013-06-22 09:25:47');

/*!40000 ALTER TABLE `taggings` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table tags
# ------------------------------------------------------------

DROP TABLE IF EXISTS `tags`;

CREATE TABLE `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;

INSERT INTO `tags` (`id`, `name`)
VALUES
	(1,'banana'),
	(2,'apple'),
	(3,'cat'),
	(4,'desk'),
	(5,'egg'),
	(6,'flower'),
	(7,'glove'),
	(8,'hotel'),
	(9,'ink'),
	(10,'jam'),
	(11,'king'),
	(12,'lion'),
	(13,'melon');

/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `admin` tinyint(1) DEFAULT '0',
  `username` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;

INSERT INTO `users` (`id`, `email`, `encrypted_password`, `remember_created_at`, `sign_in_count`, `current_sign_in_at`, `last_sign_in_at`, `current_sign_in_ip`, `last_sign_in_ip`, `created_at`, `updated_at`, `name`, `admin`, `username`)
VALUES
	(1,'yuki@creasty.com','$2a$10$4fE5HGX7IbUGri7PSRnLkevdVHfPzuz4XR11hdrT.ToOBaUNDY4Dq',NULL,90,'2013-06-24 02:14:37','2013-06-23 03:55:21','127.0.0.1','127.0.0.1','2013-04-08 01:36:55','2014-01-24 11:06:03','岩永勇輝',1,'creasty'),
	(2,'john.smith@creasty.com','$2a$10$Shs/WZqCGxwtHOQiaPQEl.raaEcqawl/f.OuqPO3m9VLkIKTh1AZq',NULL,0,NULL,NULL,NULL,NULL,'2013-05-01 02:26:25','2013-09-01 10:57:22','John Smith',1,'johnsmith'),
	(10,'test@user.com','$2a$10$MO7eJ7f5szJmff6raRE1KOihmMx2mUI/BEslrgwP8jI3QON4HZk.e',NULL,0,NULL,NULL,NULL,NULL,'2013-06-23 13:47:51','2013-06-23 13:49:02','あああ',0,'aaa');

/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
