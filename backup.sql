-- MySQL dump 10.13  Distrib 8.0.28, for Linux (x86_64)
--
-- Host: localhost    Database: upload_project
-- ------------------------------------------------------
-- Server version	8.0.28-0ubuntu0.20.04.3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add category',7,'add_category'),(26,'Can change category',7,'change_category'),(27,'Can delete category',7,'delete_category'),(28,'Can view category',7,'view_category'),(29,'Can add user',8,'add_user'),(30,'Can change user',8,'change_user'),(31,'Can delete user',8,'delete_user'),(32,'Can view user',8,'view_user'),(33,'Can add file',9,'add_file'),(34,'Can change file',9,'change_file'),(35,'Can delete file',9,'delete_file'),(36,'Can view file',9,'view_file');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(7,'fdfs','category'),(9,'fdfs','file'),(8,'fdfs','user'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2022-06-28 16:19:45.150187'),(2,'auth','0001_initial','2022-06-28 16:19:47.242455'),(3,'admin','0001_initial','2022-06-28 16:19:47.696303'),(4,'admin','0002_logentry_remove_auto_add','2022-06-28 16:19:47.716034'),(5,'admin','0003_logentry_add_action_flag_choices','2022-06-28 16:19:47.729208'),(6,'contenttypes','0002_remove_content_type_name','2022-06-28 16:19:48.080896'),(7,'auth','0002_alter_permission_name_max_length','2022-06-28 16:19:48.246049'),(8,'auth','0003_alter_user_email_max_length','2022-06-28 16:19:48.286103'),(9,'auth','0004_alter_user_username_opts','2022-06-28 16:19:48.307459'),(10,'auth','0005_alter_user_last_login_null','2022-06-28 16:19:48.429490'),(11,'auth','0006_require_contenttypes_0002','2022-06-28 16:19:48.438598'),(12,'auth','0007_alter_validators_add_error_messages','2022-06-28 16:19:48.456757'),(13,'auth','0008_alter_user_username_max_length','2022-06-28 16:19:48.640892'),(14,'auth','0009_alter_user_last_name_max_length','2022-06-28 16:19:48.817589'),(15,'auth','0010_alter_group_name_max_length','2022-06-28 16:19:48.866356'),(16,'auth','0011_update_proxy_permissions','2022-06-28 16:19:48.887167'),(17,'auth','0012_alter_user_first_name_max_length','2022-06-28 16:19:49.109310'),(18,'fdfs','0001_initial','2022-06-28 16:19:49.483496'),(19,'sessions','0001_initial','2022-06-28 16:19:49.608697');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('7uyt94h75c9bdeedkxncoiareaw0jvr3','.eJxVjEEOwiAQRe_C2hCgmQFcuvcMZGCmUjU0Ke3KeHdt0oVu_3vvv1Siba1p67KkidVZWXX63TKVh7Qd8J3abdZlbusyZb0r-qBdX2eW5-Vw_w4q9fqtDaMViMaNHMg5LEIDG_BeoNiRQDJH9C7iIGic58wskC1CDB5tiOr9AedpN7Y:1uRpzI:qV66VboY6mEr836aMSGZ7JMvBlDd1XozNhEFbui5S_o','2025-07-02 18:25:48.082376');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fdfs_category`
--

DROP TABLE IF EXISTS `fdfs_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fdfs_category` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(25) NOT NULL,
  `create_time` datetime(6) NOT NULL,
  `modify_time` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fdfs_category`
--

LOCK TABLES `fdfs_category` WRITE;
/*!40000 ALTER TABLE `fdfs_category` DISABLE KEYS */;
/*!40000 ALTER TABLE `fdfs_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fdfs_file`
--

DROP TABLE IF EXISTS `fdfs_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fdfs_file` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `file_id` varchar(100) NOT NULL,
  `size` varchar(10) NOT NULL,
  `create_time` datetime(6) NOT NULL,
  `modify_time` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fdfs_file_user_id_4f5f2518_fk_fdfs_user_id` (`user_id`),
  CONSTRAINT `fdfs_file_user_id_4f5f2518_fk_fdfs_user_id` FOREIGN KEY (`user_id`) REFERENCES `fdfs_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=185 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fdfs_file`
--

LOCK TABLES `fdfs_file` WRITE;
/*!40000 ALTER TABLE `fdfs_file` DISABLE KEYS */;
INSERT INTO `fdfs_file` VALUES (10,'IMG_20221114_084229.jpg','group1/M00/00/00/mIigM2NxunyAK7bMABfy1-J2e_U027.jpg','1.50MB','2022-11-14 11:48:12.980144','2022-11-14 11:48:12.980167',3),(13,'IMG_20230401_164515.jpg','group1/M00/00/00/mIigM2QsV9GAFIkLACc4MgW_Ub0009.jpg','2.45MB','2023-04-05 01:01:05.769452','2023-04-05 01:01:05.769479',1),(14,'IMG_20230401_164505.jpg','group1/M00/00/00/mIigM2QsWEaAZHtbACjNsjmqM0I090.jpg','2.55MB','2023-04-05 01:03:02.049028','2023-04-05 01:03:02.049054',1),(15,'IMG_20230401_164459_2.jpg','group1/M00/00/00/mIigM2QsWGaAbtgmAC_k5bBM1hQ136.jpg','2.99MB','2023-04-05 01:03:34.467690','2023-04-05 01:03:34.467716',1),(16,'IMG_20230401_164500.jpg','group1/M00/00/00/mIigM2QsWHmAEHwAAC_KJHWgoqs536.jpg','2.99MB','2023-04-05 01:03:53.673021','2023-04-05 01:03:53.673047',1),(17,'IMG_20230401_164112.jpg','group1/M00/00/00/mIigM2QsWJ6AYkHUAC8c2-Ch-YA139.jpg','2.94MB','2023-04-05 01:04:30.784415','2023-04-05 01:04:30.784442',1),(18,'IMG_20220712_120929.jpg','group1/M00/00/00/mIigM2StTo2AZQbNADUq5zAyGEc920.jpg','3.32MB','2023-07-11 20:43:57.440628','2023-07-11 20:43:57.440657',1),(19,'IMG_20220623_134656.jpg','group1/M00/00/00/mIigM2StTp-ATtfuAAGsy4mHpSQ875.jpg','107.20KB','2023-07-11 20:44:15.049321','2023-07-11 20:44:15.049347',1),(20,'mmexport1659801661858.jpg','group1/M00/00/00/mIigM2StTqmACSacAAmSR_kkKzY920.jpg','612.57KB','2023-07-11 20:44:25.334684','2023-07-11 20:44:25.334718',1),(21,'IMG_20220707_121839.jpg','group1/M00/00/00/mIigM2StUGCAUIarACmCskaxgVo334.jpg','2.59MB','2023-07-11 20:51:44.564354','2023-07-11 20:51:44.564385',1),(22,'IMG_20230611_170747_1.jpg','group1/M00/00/00/mIigM2StU1WABu0wADhMxsX9XBo330.jpg','3.52MB','2023-07-11 21:04:21.754739','2023-07-11 21:04:21.754765',1),(23,'mmexport1684167527225(1).jpg','group1/M00/00/00/mIigM2StU1eAZLkMAAJ1gj8R4y8123.jpg','157.38KB','2023-07-11 21:04:23.036267','2023-07-11 21:04:23.036294',1),(24,'mmexport1684167673779(1).jpg','group1/M00/00/00/mIigM2StU1eADpDsAAK2cqsk81M770.jpg','173.61KB','2023-07-11 21:04:23.091195','2023-07-11 21:04:23.091222',1),(25,'mmexport1685287194689(1).jpg','group1/M00/00/00/mIigM2StU1eAaXKRAADqXt5vF_g975.jpg','58.59KB','2023-07-11 21:04:23.133326','2023-07-11 21:04:23.133353',1),(26,'mmexport1685287247389(1).jpg','group1/M00/00/00/mIigM2StU1eAesvNAACoQPs95PQ857.jpg','42.06KB','2023-07-11 21:04:23.159931','2023-07-11 21:04:23.159958',1),(27,'mmexport1685983317092(1).jpg','group1/M00/00/00/mIigM2StU1iAbLqxAAEjtEL_5S0828.jpg','72.93KB','2023-07-11 21:04:24.325026','2023-07-11 21:04:24.325055',1),(28,'mmexport1685985508971(1).jpg','group1/M00/00/00/mIigM2StU1iAEzyRAAG9N_Z0v_4561.jpg','111.30KB','2023-07-11 21:04:24.401062','2023-07-11 21:04:24.401089',1),(29,'mmexport1686937034341.jpg','group1/M00/00/00/mIigM2StU1iATwA8AAE-jajF-pg254.jpg','79.64KB','2023-07-11 21:04:24.439716','2023-07-11 21:04:24.439742',1),(30,'mmexport1688114225535.jpg','group1/M00/00/00/mIigM2StU1iAN57nAAGqbhjuPUQ357.jpg','106.61KB','2023-07-11 21:04:24.482003','2023-07-11 21:04:24.482031',1),(31,'mmexport1688116014377.jpg','group1/M00/00/00/mIigM2StU1iAJ7EmAADTnQHUucM395.jpg','52.90KB','2023-07-11 21:04:24.512027','2023-07-11 21:04:24.512054',1),(32,'mmexport1695095247569.jpg','group1/M00/00/00/mIigM2UJb9GASdQ5AAHs8746PGQ506.jpg','123.24KB','2023-09-19 17:54:25.037055','2023-09-19 17:54:25.037082',1),(33,'mmexport1695095321999.jpg','group1/M00/00/00/mIigM2UJb-CAE5abADO6stn7Ge0347.jpg','3.23MB','2023-09-19 17:54:40.361241','2023-09-19 17:54:40.361268',1),(34,'mmexport1695095399206.jpg','group1/M00/00/00/mIigM2UJb-mAG6eYAAUK4G-z-f8259.jpg','322.72KB','2023-09-19 17:54:49.772551','2023-09-19 17:54:49.772578',1),(35,'mmexport1695095415665.jpg','group1/M00/00/00/mIigM2UJcAGAf68HAARk1nbjhGk710.jpg','281.21KB','2023-09-19 17:55:13.324186','2023-09-19 17:55:13.324211',1),(37,'mmexport1695095354453.jpg','group1/M00/00/00/mIigM2UJcCOAeYpkAATWC5Kp7K4412.jpg','309.51KB','2023-09-19 17:55:47.746509','2023-09-19 17:55:47.746540',1),(38,'mmexport1687186758253.jpg','group1/M00/00/00/mIigM2UJcC2AeZU7AAwHFXEj4LQ287.jpg','769.77KB','2023-09-19 17:55:57.975413','2023-09-19 17:55:57.975439',1),(39,'mmexport1691931145826.jpg','group1/M00/00/00/mIigM2UJcDaAPo7HAAvWhbCt6Nc364.jpg','757.63KB','2023-09-19 17:56:06.352475','2023-09-19 17:56:06.352505',1),(40,'IMG_20230826_155323.jpg','group1/M00/00/00/mIigM2UJcGCAYNSpADqBppVrd_A165.jpg','3.66MB','2023-09-19 17:56:48.206861','2023-09-19 17:56:48.206887',1),(41,'IMG_20230827_082938.jpg','group1/M00/00/00/mIigM2UJcHeALrWjACijDMFqoZA433.jpg','2.54MB','2023-09-19 17:57:11.061989','2023-09-19 17:57:11.062020',1),(42,'IMG_20230827_081805.jpg','group1/M00/00/00/mIigM2UJcIuAZGAjADXTZMiZnAY448.jpg','3.36MB','2023-09-19 17:57:31.090061','2023-09-19 17:57:31.090110',1),(43,'Screens.jpg','group1/M00/00/00/mIigM2UJcLqABrJ9AAvQ0ekR5kk371.jpg','756.20KB','2023-09-19 17:58:18.810264','2023-09-19 17:58:18.810291',1),(44,'IMG_20230520_151513.jpg','group1/M00/00/00/mIigM2VfUbyAXOjYADp0c7c8L4Q893.jpg','3.65MB','2023-11-23 21:21:00.687671','2023-11-23 21:21:00.687697',1),(45,'IMG_20230520_171548.jpg','group1/M00/00/01/mIigM2VfUgOAAlmwABdur5xSzV0304.jpg','1.46MB','2023-11-23 21:22:11.604840','2023-11-23 21:22:11.604866',1),(46,'IMG_20230520_171559.jpg','group1/M00/00/01/mIigM2VfUg-AGTfXABehlJIbcc4664.jpg','1.48MB','2023-11-23 21:22:23.578565','2023-11-23 21:22:23.578589',1),(47,'IMG_20230520_172106.jpg','group1/M00/00/01/mIigM2VfUkGAAYRuABiXULxd9Hc621.jpg','1.54MB','2023-11-23 21:23:13.950410','2023-11-23 21:23:13.950434',1),(49,'zhizhuxia.jpg','group1/M00/00/01/mIigM2VfVe-ALMT5AA8Bz4fNVyU328.jpg','960.45KB','2023-11-23 21:38:55.471574','2023-11-23 21:38:55.471601',1),(51,'xt1.jpg','group1/M00/00/01/mIigM2WU9pKAPbLvAAcVI_FzYKQ355.jpg','453.28KB','2024-01-03 13:54:26.990850','2024-01-03 13:54:26.990874',1),(52,'qy.jpg','group1/M00/00/01/mIigM2WU9pyAcLhNAAra55q5MKI553.jpg','694.73KB','2024-01-03 13:54:36.270084','2024-01-03 13:54:36.270108',1),(53,'xt2.jpg','group1/M00/00/01/mIigM2WU9qSAKLIdAAc03xthRmg516.jpg','461.22KB','2024-01-03 13:54:44.231190','2024-01-03 13:54:44.231214',1),(54,'xt3.jpg','group1/M00/00/01/mIigM2WU9quADYsxAAiBi-9MuBs927.jpg','544.39KB','2024-01-03 13:54:51.726162','2024-01-03 13:54:51.726187',1),(55,'xt4.jpg','group1/M00/00/01/mIigM2WU9rKAXOl3AAiE4jPxK_o049.jpg','545.22KB','2024-01-03 13:54:58.991008','2024-01-03 13:54:58.991032',1),(56,'xt5.jpg','group1/M00/00/01/mIigM2WU9r2ALs6rAA-b9N4oc6w198.jpg','998.99KB','2024-01-03 13:55:09.521595','2024-01-03 13:55:09.521620',1),(57,'xt6.jpg','group1/M00/00/01/mIigM2WU9sWAI0kUAA0GndFAXdc645.jpg','833.65KB','2024-01-03 13:55:17.513729','2024-01-03 13:55:17.513753',1),(58,'new.png','group1/M00/00/01/mIigM2Wj20GAWlluAA1cOg1tTtQ069.png','855.06KB','2024-01-14 21:01:53.975116','2024-01-14 21:01:53.975142',1),(59,'yyhkc.jpg','group1/M00/00/01/mIigM2Wj3KaAYArAAAe2CgHnFi8419.jpg','493.51KB','2024-01-14 21:07:50.728727','2024-01-14 21:07:50.728750',1),(60,'yykc.jpg','group1/M00/00/01/mIigM2Wj3KiAWM0TAAk6fD15GsQ446.jpg','590.62KB','2024-01-14 21:07:52.362540','2024-01-14 21:07:52.362564',1),(61,'yyquan.jpg','group1/M00/00/01/mIigM2Wj3LmAP8d3AAfl0keRhKA230.jpg','505.46KB','2024-01-14 21:08:09.807935','2024-01-14 21:08:09.807958',1),(62,'yyxiong.jpg','group1/M00/00/01/mIigM2Wj3LuADnFWAAi-vT1ntrE334.jpg','559.68KB','2024-01-14 21:08:11.471142','2024-01-14 21:08:11.471167',1),(63,'yyzw.jpg','group1/M00/00/01/mIigM2Wj3L2AF8VoAA2zuxU3cUA501.jpg','876.93KB','2024-01-14 21:08:13.460338','2024-01-14 21:08:13.460362',1),(64,'ju.jpg','group1/M00/00/01/mIigM2Wj3NyAPP97AAkodVHaqEo476.jpg','586.11KB','2024-01-14 21:08:44.291088','2024-01-14 21:08:44.291111',1),(65,'ju1.jpg','group1/M00/00/01/mIigM2Wj3N6AEoWRAA4LQ5w5LTg703.jpg','898.82KB','2024-01-14 21:08:46.377631','2024-01-14 21:08:46.377658',1),(66,'juxiong.jpg','group1/M00/00/01/mIigM2Wj3OCARjOmAAsWJXyrN74760.jpg','709.54KB','2024-01-14 21:08:48.261094','2024-01-14 21:08:48.261118',1),(67,'px.jpg','group1/M00/00/01/mIigM2WvMh6AVGJ7ACGzmprTyK0477.jpg','2.11MB','2024-01-23 11:27:26.005917','2024-01-23 11:27:26.005944',1),(69,'louxiong.jpg','group1/M00/00/01/mIigM2XRwDOAIh3hAAL4xxa84V0169.jpg','190.19KB','2024-02-18 16:30:43.238718','2024-02-18 16:30:43.238743',1),(70,'louxiong1.jpg','group1/M00/00/01/mIigM2XRwEeAYfgAAAH5bj-bSEg761.jpg','126.36KB','2024-02-18 16:31:03.928091','2024-02-18 16:31:03.928142',1),(71,'dabai.jpg','group1/M00/00/01/mIigM2XRwSOAC0c3AAcWk0lUbjM632.jpg','453.64KB','2024-02-18 16:34:43.606593','2024-02-18 16:34:43.606622',1),(72,'mei.jpg','group1/M00/00/01/mIigM2XRwS6AOcs0AA0aXwY1ECg390.jpg','838.59KB','2024-02-18 16:34:54.649739','2024-02-18 16:34:54.649766',1),(74,'spg.jpg','group1/M00/00/01/mIigM2XRw6GAFMB9AAVgICKVpLY649.jpg','344.03KB','2024-02-18 16:45:21.991982','2024-02-18 16:45:21.992008',1),(75,'saopingquan.jpg','group1/M00/00/01/mIigM2XRxC-AMQ9AAA8qphsi84M774.jpg','970.66KB','2024-02-18 16:47:43.637026','2024-02-18 16:47:43.637072',1),(76,'saopingxiong.jpg','group1/M00/00/01/mIigM2XRxD2AXHiwAA6RWbPFJ7k089.jpg','932.34KB','2024-02-18 16:47:57.453395','2024-02-18 16:47:57.453427',1),(77,'bz.jpg','group1/M00/00/01/mIigM2XRxEqAYtFqAA4pba0bXeg628.jpg','906.36KB','2024-02-18 16:48:10.416881','2024-02-18 16:48:10.416905',1),(78,'saoping.jpg','group1/M00/00/01/mIigM2XRxFWAActnAA0Flq7G_eU250.jpg','833.40KB','2024-02-18 16:48:21.697645','2024-02-18 16:48:21.697669',1),(79,'pigu.png','group1/M00/00/01/mIigM2XRxGSAfqvaAACwTtR8Cck862.png','44.08KB','2024-02-18 16:48:36.064733','2024-02-18 16:48:36.064756',1),(80,'lidan.jpg','group1/M00/00/01/mIigM2XRxHOAMu13ABI59EZMQ3k693.jpg','1.14MB','2024-02-18 16:48:51.666949','2024-02-18 16:48:51.666974',1),(81,'danni.jpg','group1/M00/00/01/mIigM2XRxH6AWOLCAAuV62oxk0c711.jpg','741.48KB','2024-02-18 16:49:02.785927','2024-02-18 16:49:02.785951',1),(82,'wangqian.jpg','group1/M00/00/01/mIigM2XRxJSAepwnAAncLG8i6w8972.jpg','631.04KB','2024-02-18 16:49:24.665433','2024-02-18 16:49:24.665458',1),(83,'loupig.jpg','group1/M00/00/01/mIigM2XRxKKAC9bsAA1hq3Uo-c0139.jpg','856.42KB','2024-02-18 16:49:38.262064','2024-02-18 16:49:38.262088',1),(84,'loupg.jpg','group1/M00/00/01/mIigM2XRxLKAZHlCABG0RRgJUoE181.jpg','1.11MB','2024-02-18 16:49:54.886915','2024-02-18 16:49:54.886940',1),(85,'huanghan.jpg','group1/M00/00/01/mIigM2XRxL2AMkTHAAj0MeS4Y14033.jpg','573.05KB','2024-02-18 16:50:05.249238','2024-02-18 16:50:05.249262',1),(86,'sb.jpg','group1/M00/00/01/mIigM2XRxqWAGoBRAAJ9bslIOyc635.jpg','159.36KB','2024-02-18 16:58:13.429431','2024-02-18 16:58:13.429456',1),(87,'sjykoub.jpg','group1/M00/00/01/mIigM2XRxq6ARKtDABNr9ltbvTc993.jpg','1.21MB','2024-02-18 16:58:22.617154','2024-02-18 16:58:22.617188',1),(88,'sjyqin.jpg','group1/M00/00/01/mIigM2XRxreAatAfAA2w34PqFM8798.jpg','876.22KB','2024-02-18 16:58:31.733217','2024-02-18 16:58:31.733242',1),(89,'sjyxiong.jpg','group1/M00/00/01/mIigM2XRxsOAG835AA6wyXrf23U137.jpg','940.20KB','2024-02-18 16:58:43.274195','2024-02-18 16:58:43.274220',1),(90,'sjyxiongdai.jpg','group1/M00/00/01/mIigM2XRxs6APXTgAA-dAkRRGAs689.jpg','999.25KB','2024-02-18 16:58:54.582350','2024-02-18 16:58:54.582374',1),(91,'plq.jpg','group1/M00/00/01/mIigM2XRx62AOEqRAAN3FcOtDgo487.jpg','221.77KB','2024-02-18 17:02:37.689971','2024-02-18 17:02:37.689995',1),(92,'pll.jpg','group1/M00/00/01/mIigM2XRx7WANxGTAA2oz1QwmYU667.jpg','874.20KB','2024-02-18 17:02:45.461878','2024-02-18 17:02:45.461907',1),(93,'pl.jpg','group1/M00/00/01/mIigM2XRx72Aea2rAAy4pPeNRMY454.jpg','814.16KB','2024-02-18 17:02:53.538202','2024-02-18 17:02:53.538226',1),(94,'sq.jpg','group1/M00/00/01/mIigM2XRx86ASiyWAArIZyo5S3I239.jpg','690.10KB','2024-02-18 17:03:10.350849','2024-02-18 17:03:10.350873',1),(95,'smox.jpg','group1/M00/00/01/mIigM2XRx9eAIr_eAArvY46rZGY516.jpg','699.85KB','2024-02-18 17:03:19.996536','2024-02-18 17:03:19.996562',1),(96,'luoxiaoxiao.jpg','group1/M00/00/01/mIigM2XRyOmAGEwdABVIKX8vxIg966.jpg','1.33MB','2024-02-18 17:07:53.594809','2024-02-18 17:07:53.594834',1),(97,'lxxkb.jpg','group1/M00/00/01/mIigM2XRyfGAKe3iAAEx2anPetk529.jpg','76.46KB','2024-02-18 17:12:17.288698','2024-02-18 17:12:17.288723',1),(98,'lxxwub.jpg','group1/M00/00/01/mIigM2XRyfqAN3K8AACAVwir-bc772.jpg','32.08KB','2024-02-18 17:12:26.161468','2024-02-18 17:12:26.161504',1),(99,'lxxzuo.jpg','group1/M00/00/01/mIigM2XRygeANhSYAAQmJJf6Xbs838.jpg','265.54KB','2024-02-18 17:12:39.828891','2024-02-18 17:12:39.828940',1),(100,'IMG_1144(1)(1).jpg','group1/M00/00/01/mIigM2XuaqqAPmxdAADePwg3kH0506.jpg','55.56KB','2024-03-11 10:21:30.846879','2024-03-11 10:21:30.846907',1),(101,'IMG_1147(1).png','group1/M00/00/01/mIigM2XuawOAS-fNAAoUvE-9xWE944.png','645.18KB','2024-03-11 10:22:59.009792','2024-03-11 10:22:59.009823',1),(102,'IMG_1167(1).png','group1/M00/00/01/mIigM2Xua36AMZiMACcsDLUC1as963.png','2.45MB','2024-03-11 10:25:02.059275','2024-03-11 10:25:02.059299',1),(103,'IMG_1149(1).png','group1/M00/00/01/mIigM2Xub7GAPTqFAAycHxcBSlU572.png','807.03KB','2024-03-11 10:42:57.779807','2024-03-11 10:42:57.779831',1),(104,'csheyou.jpg','group1/M00/00/01/mIigM2XwSe6AHFOyAAHHUpPZ7ok377.jpg','113.83KB','2024-03-12 20:26:22.798376','2024-03-12 20:26:22.798404',1),(105,'chabaidao.png','group1/M00/00/01/mIigM2XwSjOAT-EDAAR4wyyR8Fc601.png','286.19KB','2024-03-12 20:27:31.198313','2024-03-12 20:27:31.198337',1),(106,'qunzi.png','group1/M00/00/01/mIigM2XwTMOAMUrtACMZkxtNG4w021.png','2.19MB','2024-03-12 20:38:27.954841','2024-03-12 20:38:27.954865',1),(107,'qingxin.jpg','group1/M00/00/01/mIigM2XwTkmAabNJAAx4dLNRCss570.jpg','798.11KB','2024-03-12 20:44:57.108999','2024-03-12 20:44:57.109028',1),(108,'qingxin1.jpg','group1/M00/00/01/mIigM2XwTmSAFuoXAAeXCRHwbZY417.jpg','485.76KB','2024-03-12 20:45:24.544182','2024-03-12 20:45:24.544205',1),(109,'qingxin2.jpg','group1/M00/00/01/mIigM2XwTmSAAu_pAAX43gozdlc034.jpg','382.22KB','2024-03-12 20:45:24.766756','2024-03-12 20:45:24.766779',1),(110,'baiqunzi.jpg','group1/M00/00/01/mIigM2XwUWaAXNd1AAThZipNeGA920.jpg','312.35KB','2024-03-12 20:58:14.568212','2024-03-12 20:58:14.568235',1),(111,'baiqunziw.jpg','group1/M00/00/01/mIigM2XwUWaAPGaSAAGEN1NamB4855.jpg','97.05KB','2024-03-12 20:58:14.610075','2024-03-12 20:58:14.610095',1),(112,'st.jpg','group1/M00/00/01/mIigM2XwUreAUchsAAbxJWHQzM8361.jpg','444.29KB','2024-03-12 21:03:51.358677','2024-03-12 21:03:51.358700',1),(116,'IMG_20241228_221545.jpg','group1/M00/00/02/mIigM2g32ruAGQv0AAZ8HeFQsq8861.jpg','415.03KB','2025-05-29 11:55:39.060921','2025-05-29 11:55:39.060947',1),(117,'IMG_20241007_093541.jpg','group1/M00/00/02/mIigM2g32tOAOt2gACkJC8bZcsc344.jpg','2.56MB','2025-05-29 11:56:03.292574','2025-05-29 11:56:03.292600',1),(118,'jyx.jpg','group1/M00/00/02/mIigM2g322iABxIrAA68oZE_c2w225.jpg','943.16KB','2025-05-29 11:58:32.808182','2025-05-29 11:58:32.808208',1),(119,'jyx1.jpg','group1/M00/00/02/mIigM2g322uAR1N1ABFZzEsH2dk288.jpg','1.08MB','2025-05-29 11:58:35.366911','2025-05-29 11:58:35.366940',1),(120,'jyzp.jpg','group1/M00/00/02/mIigM2g3222ADXojAAzpyanmEzE119.jpg','826.45KB','2025-05-29 11:58:37.483255','2025-05-29 11:58:37.483285',1),(121,'lmpg.jpg','group1/M00/00/02/mIigM2g322-AeSdXAAyog_mLlE8707.jpg','810.13KB','2025-05-29 11:58:39.585048','2025-05-29 11:58:39.585077',1),(122,'zkxpg1.jpg','group1/M00/00/02/mIigM2g323KAIMJTAA8OxVmz6zI617.jpg','963.69KB','2025-05-29 11:58:42.027225','2025-05-29 11:58:42.027251',1),(123,'jypg.jpg','group1/M00/00/02/mIigM2g324OAEzYvABIcTnRd_ls228.jpg','1.13MB','2025-05-29 11:58:59.032337','2025-05-29 11:58:59.032377',1),(124,'jypg1.jpg','group1/M00/00/02/mIigM2g324WANme7ABMBBQHdIPo800.jpg','1.19MB','2025-05-29 11:59:01.291411','2025-05-29 11:59:01.291437',1),(125,'jypg2.jpg','group1/M00/00/02/mIigM2g324eAe9qzABMESsqBY6o312.jpg','1.19MB','2025-05-29 11:59:03.853597','2025-05-29 11:59:03.853624',1),(126,'mmexport1742173183768.jpg','group1/M00/00/02/mIigM2g324mAPlm-AAdYwo4ArS8159.jpg','470.19KB','2025-05-29 11:59:05.278046','2025-05-29 11:59:05.278072',1),(127,'pingjiandai.jpg','group1/M00/00/02/mIigM2g324uAbctuABQvWXQLFs0887.jpg','1.26MB','2025-05-29 11:59:07.872694','2025-05-29 11:59:07.872720',1),(128,'wkz.jpg','group1/M00/00/02/mIigM2g3246AbayPAA84a1G9J3I110.jpg','974.10KB','2025-05-29 11:59:10.196115','2025-05-29 11:59:10.196141',1),(129,'jy5.jpg','group1/M00/00/02/mIigM2g327iAW9xjAA4wOWPJb4Y188.jpg','908.06KB','2025-05-29 11:59:52.214769','2025-05-29 11:59:52.214795',1),(130,'jy6.jpg','group1/M00/00/02/mIigM2g327qAZinoABBZzkJqxR0290.jpg','1.02MB','2025-05-29 11:59:54.033485','2025-05-29 11:59:54.033510',1),(132,'lidan.jpg','group1/M00/00/02/mIigM2g39qmAZO1UAAoceplvo20311.jpg','647.12KB','2025-05-29 13:54:49.189005','2025-05-29 13:54:49.189031',1),(133,'IMG_20240711_110155.jpg','group1/M00/00/02/mIigM2g3-t6ATlmAAFoFdYqqulg843.jpg','5.63MB','2025-05-29 14:12:46.451722','2025-05-29 14:12:46.451755',1),(134,'IMG_20240711_120513.jpg','group1/M00/00/02/mIigM2g3-wmAaMLfAFA1no897qM784.jpg','5.01MB','2025-05-29 14:13:29.807176','2025-05-29 14:13:29.807203',1),(135,'IMG_20240715_103637.jpg','group1/M00/00/02/mIigM2g3-xGAITvYAE8PzDgJV8A895.jpg','4.94MB','2025-05-29 14:13:37.416352','2025-05-29 14:13:37.416380',1),(136,'IMG_20240716_093149.jpg','group1/M00/00/02/mIigM2g3-xSAFWrAAB02Ue6I_XY987.jpg','1.83MB','2025-05-29 14:13:40.569006','2025-05-29 14:13:40.569032',1),(137,'IMG_20240719_094952.jpg','group1/M00/00/02/mIigM2g3-x2AWCY6AFjAUVr6gjU023.jpg','5.55MB','2025-05-29 14:13:49.392733','2025-05-29 14:13:49.392761',1),(138,'IMG_20240801_195722.jpg','group1/M00/00/02/mIigM2g3-ySALRRCAEL9_bp-xag983.jpg','4.19MB','2025-05-29 14:13:56.118985','2025-05-29 14:13:56.119015',1),(139,'IMG_20241017_162526.jpg','group1/M00/00/02/mIigM2g3-yyATlbPAFXGT-LUNvo520.jpg','5.36MB','2025-05-29 14:14:04.741799','2025-05-29 14:14:04.741827',1),(140,'IMG_20250422_142250.jpg','group1/M00/00/02/mIigM2g3-zaANBPZAGIDFRLZD9Q756.jpg','6.13MB','2025-05-29 14:14:14.346659','2025-05-29 14:14:14.346689',1),(141,'IMG_20250422_142350.jpg','group1/M00/00/02/mIigM2g3-0mAVxwfAMc2gRxfy84214.jpg','12.45MB','2025-05-29 14:14:33.345889','2025-05-29 14:14:33.345915',1),(142,'jy3.jpg','group1/M00/00/02/mIigM2g3-06AEU_fABJSog8wQpM642.jpg','1.15MB','2025-05-29 14:14:38.227838','2025-05-29 14:14:38.227864',1),(144,'jy4.jpg','group1/M00/00/02/mIigM2g3-1WAAbcqABP4MRS-0Fs902.jpg','1.25MB','2025-05-29 14:14:45.219419','2025-05-29 14:14:45.219446',1),(154,'IMG_20241227_203459.jpg','group1/M00/00/02/mIigM2g3_RCAUFs6AAW6CkqU4wk241.jpg','366.51KB','2025-05-29 14:22:08.613419','2025-05-29 14:22:08.613450',1),(155,'jykoub.jpg','group1/M00/00/02/mIigM2g3_RmAYg1BAGATrT6dEKc364.jpg','6.00MB','2025-05-29 14:22:17.529862','2025-05-29 14:22:17.529890',1),(156,'IMG_20250529_143446.jpg','group1/M00/00/02/mIigM2g4AFGAI0gaAA9jXgiAEPc158.jpg','984.84KB','2025-05-29 14:36:01.346634','2025-05-29 14:36:01.346661',1),(157,'IMG_20250529_143429.jpg','group1/M00/00/02/mIigM2g4AFSAbotfAAiAqQJdoX8415.jpg','544.17KB','2025-05-29 14:36:04.495086','2025-05-29 14:36:04.495114',1),(158,'IMG_20250529_143414.jpg','group1/M00/00/02/mIigM2g4AFaAX4GbAARz_M_5mxk558.jpg','285.00KB','2025-05-29 14:36:06.189471','2025-05-29 14:36:06.189500',1),(159,'IMG_20250529_143359.jpg','group1/M00/00/02/mIigM2g4AF6AUtwEAAT81rIPXGU164.jpg','319.21KB','2025-05-29 14:36:14.099281','2025-05-29 14:36:14.099310',1),(160,'IMG_20250529_143231.jpg','group1/M00/00/02/mIigM2g4AGaAXXO4AAUi1WxHvv8771.jpg','328.71KB','2025-05-29 14:36:22.009432','2025-05-29 14:36:22.009463',1),(161,'IMG_20250529_143251.jpg','group1/M00/00/02/mIigM2g4AGuADKMhAARhB424cPU865.jpg','280.26KB','2025-05-29 14:36:27.795064','2025-05-29 14:36:27.795094',1),(162,'IMG_20250529_143334.jpg','group1/M00/00/02/mIigM2g4AHGAc9lQAARE-y0Rwwo017.jpg','273.25KB','2025-05-29 14:36:33.629866','2025-05-29 14:36:33.629919',1),(163,'dn (2).png','group1/M00/00/02/mIigM2g4AyGAHk8eARO7QJxXVyI728.png','17.23MB','2025-05-29 14:48:01.906077','2025-05-29 14:48:01.906114',1),(164,'dn.png','group1/M00/00/02/mIigM2g4AziAYIR_AO40XFNo5Cg568.png','14.89MB','2025-05-29 14:48:24.082516','2025-05-29 14:48:24.082542',1),(166,'tingting.jpg','group1/M00/00/02/mIigM2g4BAeAdX-LABUTxajN-dA580.jpg','1.32MB','2025-05-29 14:51:51.580102','2025-05-29 14:51:51.580126',1),(167,'IMG_20250529_151756.jpg','group1/M00/00/02/mIigM2g4CqaARFtRAAs-3ZoN0uk769.jpg','719.72KB','2025-05-29 15:20:06.521368','2025-05-29 15:20:06.521394',1),(168,'IMG_20250529_151714.jpg','group1/M00/00/02/mIigM2g4Cq-AQ9LvAAXPA4GEDVE898.jpg','371.75KB','2025-05-29 15:20:15.810278','2025-05-29 15:20:15.810305',1),(169,'IMG_20250530_102058.jpg','group1/M00/00/02/mIigM2g5FwiATki1AAYjp-4aP0I909.jpg','392.91KB','2025-05-30 10:25:12.360272','2025-05-30 10:25:12.360297',1),(170,'IMG_20250530_102009.jpg','group1/M00/00/02/mIigM2g5FwmANfsyAAVqgJ5HRcA947.jpg','346.62KB','2025-05-30 10:25:13.745037','2025-05-30 10:25:13.745064',1),(171,'IMG_20250530_101740.jpg','group1/M00/00/02/mIigM2g5FxGAHAQ9AAYf7siS4gc366.jpg','391.98KB','2025-05-30 10:25:21.251109','2025-05-30 10:25:21.251137',1),(172,'IMG_20250530_101651.jpg','group1/M00/00/02/mIigM2g5FxmAb0sUAA0WAxO68iM048.jpg','837.50KB','2025-05-30 10:25:29.145493','2025-05-30 10:25:29.145520',1),(173,'IMG_20250530_101621.jpg','group1/M00/00/02/mIigM2g5FxuAazSfAAmV9hpFaPo680.jpg','613.49KB','2025-05-30 10:25:31.361688','2025-05-30 10:25:31.361715',1),(174,'IMG_20250530_101601.jpg','group1/M00/00/02/mIigM2g5FxyAHW1EAAZ8MEuCD1Y756.jpg','415.05KB','2025-05-30 10:25:32.572767','2025-05-30 10:25:32.572808',1),(175,'IMG_20250530_101520.jpg','group1/M00/00/02/mIigM2g5Fx6AUicXAAivhkGiWkY610.jpg','555.88KB','2025-05-30 10:25:34.811381','2025-05-30 10:25:34.811408',1),(176,'IMG_20250530_101413.jpg','group1/M00/00/02/mIigM2g5FyKADkaRABDVr52F45Q136.jpg','1.05MB','2025-05-30 10:25:38.617580','2025-05-30 10:25:38.617607',1),(177,'IMG_20250530_101351.jpg','group1/M00/00/02/mIigM2g5FySATpXzAAMs9kikaqQ078.jpg','203.24KB','2025-05-30 10:25:40.108612','2025-05-30 10:25:40.108638',1),(178,'IMG_20250530_101317.jpg','group1/M00/00/02/mIigM2g5FyWAGZpWAARKlM41Tw0947.jpg','274.64KB','2025-05-30 10:25:41.551721','2025-05-30 10:25:41.551747',1),(179,'kx2.jpg','group1/M00/00/02/mIigM2g-cMKAJoUkAA0dZr-XNeE568.jpg','839.35KB','2025-06-03 11:49:22.644154','2025-06-03 11:49:22.644180',1),(180,'kx1.jpg','group1/M00/00/02/mIigM2g-cNOATSlQAA36JnapM50702.jpg','894.54KB','2025-06-03 11:49:39.810960','2025-06-03 11:49:39.810988',1),(181,'kx.jpg','group1/M00/00/02/mIigM2g-cN2AIX9yAArov4K8kGI286.jpg','698.19KB','2025-06-03 11:49:50.093147','2025-06-03 11:49:50.093175',1);
/*!40000 ALTER TABLE `fdfs_file` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fdfs_user`
--

DROP TABLE IF EXISTS `fdfs_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fdfs_user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `phone` varchar(11) NOT NULL,
  `passwd` varchar(50) NOT NULL,
  `create_time` datetime(6) NOT NULL,
  `modify_time` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fdfs_user`
--

LOCK TABLES `fdfs_user` WRITE;
/*!40000 ALTER TABLE `fdfs_user` DISABLE KEYS */;
INSERT INTO `fdfs_user` VALUES (1,'','19935765756','123456','2022-06-28 16:28:22.158987','2022-06-28 16:28:22.159012'),(2,'','19118347221','123456','2022-06-28 17:48:45.169546','2022-06-28 17:48:45.169569'),(3,'','15235929141','123456','2022-11-14 11:47:51.844508','2022-11-14 11:47:51.844530');
/*!40000 ALTER TABLE `fdfs_user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-29 22:44:23
