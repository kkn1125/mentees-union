-- Active: 1737113705955@@menteeunion.kro.kr@3306
drop schema if exists `mentee-union`;
show tables;
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mentee-union
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mentee-union
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mentee-union` DEFAULT CHARACTER SET utf8mb4 ;
USE `mentee-union` ;

-- -----------------------------------------------------
-- Table `mentee-union`.`grade`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mentee-union`.`grade` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `description` TEXT NOT NULL,
  `deleted_at` DATETIME NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mentee-union`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mentee-union`.`user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `grade_id` INT NOT NULL,
  `username` VARCHAR(45) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `phone_number` VARCHAR(45) NOT NULL,
  `birth` DATE NOT NULL,
  `gender` TINYINT NOT NULL DEFAULT 0,
  `password` VARCHAR(150) NOT NULL,
  `auth_email` TINYINT NOT NULL DEFAULT 0,
  `level` INT NOT NULL DEFAULT 0,
  `points` INT NOT NULL DEFAULT 0,
  `fail_login_count` INT NULL DEFAULT 0,
  `last_login_at` DATETIME NULL DEFAULT NULL,
  `status` VARCHAR(45) NOT NULL DEFAULT 'logout',
  `deleted_at` DATETIME NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC),
  INDEX `fk_user_grade1_idx` (`grade_id` ASC),
  CONSTRAINT `fk_user_grade1`
    FOREIGN KEY (`grade_id`)
    REFERENCES `mentee-union`.`grade` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mentee-union`.`forum`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mentee-union`.`forum` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `title` VARCHAR(50) NOT NULL,
  `content` LONGTEXT NOT NULL,
  `view_count` INT NOT NULL DEFAULT 0,
  `deleted_at` DATETIME NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  PRIMARY KEY (`id`),
  INDEX `fk_forums_user_idx` (`user_id` ASC),
  CONSTRAINT `fk_forums_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `mentee-union`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mentee-union`.`category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mentee-union`.`category` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `description` TEXT NOT NULL,
  `deleted_at` DATETIME NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mentee-union`.`seminar`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mentee-union`.`seminar` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `host_id` INT NOT NULL,
  `category_id` INT NOT NULL,
  `title` VARCHAR(50) NOT NULL,
  `content` LONGTEXT NOT NULL,
  `view_count` INT NOT NULL DEFAULT 0,
  `meeting_place` VARCHAR(150) NOT NULL,
  `limit_participant_amount` INT NOT NULL DEFAULT 0,
  `recruit_start_date` DATETIME NOT NULL,
  `recruit_end_date` DATETIME NOT NULL,
  `seminar_start_date` DATETIME NOT NULL,
  `seminar_end_date` DATETIME NOT NULL,
  `is_recruit_finished` TINYINT NOT NULL DEFAULT 0,
  `is_seminar_finished` TINYINT NOT NULL DEFAULT 0,
  `deleted_at` DATETIME NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  PRIMARY KEY (`id`),
  INDEX `fk_seminars_host1_idx` (`host_id` ASC),
  INDEX `fk_seminar_category1_idx` (`category_id` ASC),
  CONSTRAINT `fk_seminar_host1`
    FOREIGN KEY (`host_id`)
    REFERENCES `mentee-union`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_seminar_category1`
    FOREIGN KEY (`category_id`)
    REFERENCES `mentee-union`.`category` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mentee-union`.`seminar_participant`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mentee-union`.`seminar_participant` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `seminar_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `is_confirm` TINYINT NOT NULL DEFAULT 0,
  `deleted_at` DATETIME NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  INDEX `fk_seminars_has_users_users1_idx` (`user_id` ASC),
  INDEX `fk_seminars_has_users_seminars1_idx` (`seminar_id` ASC),
  PRIMARY KEY (`id`, `user_id`, `seminar_id`),
  CONSTRAINT `fk_seminar_has_user_seminar1`
    FOREIGN KEY (`seminar_id`)
    REFERENCES `mentee-union`.`seminar` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_seminar_has_user_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mentee-union`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mentee-union`.`mentoring_session`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mentee-union`.`mentoring_session` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `category_id` INT NULL,
  `topic` VARCHAR(50) NOT NULL,
  `objective` VARCHAR(100) NOT NULL,
  `format` VARCHAR(30) NOT NULL,
  `note` VARCHAR(200) NOT NULL,
  `limit` INT NOT NULL DEFAULT 2,
  `password` VARCHAR(150) NULL,
  `is_private` TINYINT NOT NULL DEFAULT 0,
  `deleted_at` DATETIME NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  PRIMARY KEY (`id`),
  INDEX `fk_mento-mentee-session_category1_idx` (`category_id` ASC),
  CONSTRAINT `fk_mento-mentee-session_category1`
    FOREIGN KEY (`category_id`)
    REFERENCES `mentee-union`.`category` (`id`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mentee-union`.`mentoring`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mentee-union`.`mentoring` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `mentee_id` INT NOT NULL,
  `mentoring_session_id` INT NOT NULL,
  `status` VARCHAR(45) NOT NULL DEFAULT 'waitlist',
  `deleted_at` DATETIME NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  PRIMARY KEY (`id`),
  INDEX `fk_mentor_mentee_matches_mento_mentee_users2_idx` (`mentee_id` ASC),
  INDEX `fk_mentor_mentee_matches_mento_mentee_session1_idx` (`mentoring_session_id` ASC),
  CONSTRAINT `fk_mentor_mentee_matches_mento_mentee_users2`
    FOREIGN KEY (`mentee_id`)
    REFERENCES `mentee-union`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_mentor_mentee_matches_mento_mentee_session1`
    FOREIGN KEY (`mentoring_session_id`)
    REFERENCES `mentee-union`.`mentoring_session` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mentee-union`.`user_recommend`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mentee-union`.`user_recommend` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `giver_id` INT NOT NULL,
  `receiver_id` INT NOT NULL,
  `points` INT NOT NULL DEFAULT 1,
  `reason` VARCHAR(300) NOT NULL,
  `deleted_at` DATETIME NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  PRIMARY KEY (`id`, `giver_id`, `receiver_id`),
  INDEX `fk_users_has_users_users3_idx` (`receiver_id` ASC),
  INDEX `fk_users_has_users_users2_idx` (`giver_id` ASC),
  CONSTRAINT `fk_users_has_users_users2`
    FOREIGN KEY (`giver_id`)
    REFERENCES `mentee-union`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_has_users_users3`
    FOREIGN KEY (`receiver_id`)
    REFERENCES `mentee-union`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mentee-union`.`interest`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mentee-union`.`interest` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(150) NOT NULL,
  `deleted_at` DATETIME NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  INDEX `fk_interest_user1_idx` (`user_id` ASC),
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_interest_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mentee-union`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mentee-union`.`terms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mentee-union`.`terms` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(100) NOT NULL,
  `content` LONGTEXT NOT NULL,
  `deleted_at` DATETIME NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mentee-union`.`allow_terms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mentee-union`.`allow_terms` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `terms_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `agree` TINYINT NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  PRIMARY KEY (`id`, `terms_id`, `user_id`),
  INDEX `fk_terms_has_user_user1_idx` (`user_id` ASC),
  INDEX `fk_terms_has_user_terms1_idx` (`terms_id` ASC),
  CONSTRAINT `fk_terms_has_user_terms1`
    FOREIGN KEY (`terms_id`)
    REFERENCES `mentee-union`.`terms` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_terms_has_user_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mentee-union`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mentee-union`.`profile`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mentee-union`.`profile` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `new_name` VARCHAR(300) NULL DEFAULT NULL,
  `origin_name` VARCHAR(150) NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  PRIMARY KEY (`id`),
  INDEX `fk_profile_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_profile_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mentee-union`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mentee-union`.`message`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mentee-union`.`message` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NULL,
  `mentoring_session_id` INT NOT NULL,
  `message` VARCHAR(300) NOT NULL,
  `is_top` TINYINT NOT NULL DEFAULT 0,
  `is_deleted` TINYINT NOT NULL DEFAULT 0,
  `deleted_at` DATETIME NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  PRIMARY KEY (`id`),
  INDEX `fk_messages_mentoring_session1_idx` (`mentoring_session_id` ASC),
  INDEX `fk_message_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_messages_mentoring_session1`
    FOREIGN KEY (`mentoring_session_id`)
    REFERENCES `mentee-union`.`mentoring_session` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_message_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mentee-union`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mentee-union`.`read_message`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mentee-union`.`read_message` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NULL,
  `message_id` INT NOT NULL,
  PRIMARY KEY (`id`, `message_id`),
  INDEX `fk_user_has_message_message1_idx` (`message_id` ASC),
  INDEX `fk_user_has_message_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_user_has_message_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mentee-union`.`user` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_has_message_message1`
    FOREIGN KEY (`message_id`)
    REFERENCES `mentee-union`.`message` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mentee-union`.`board`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mentee-union`.`board` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `type` VARCHAR(20) NOT NULL DEFAULT 'notice' COMMENT 'board type\n- faq\n- event\n- notice',
  `title` VARCHAR(50) NOT NULL,
  `content` LONGTEXT NOT NULL,
  `view_count` INT NOT NULL DEFAULT 0,
  `visible` TINYINT NOT NULL DEFAULT 1,
  `sequence` INT NOT NULL DEFAULT -1,
  `deleted_at` DATETIME NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  PRIMARY KEY (`id`),
  INDEX `fk_board_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_board_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mentee-union`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mentee-union`.`forum_like`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mentee-union`.`forum_like` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `forum_id` INT NOT NULL,
  `deleted_at` DATETIME NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  INDEX `fk_user_has_forum_forum1_idx` (`forum_id` ASC),
  INDEX `fk_user_has_forum_user1_idx` (`user_id` ASC),
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_user_has_forum_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mentee-union`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_has_forum_forum1`
    FOREIGN KEY (`forum_id`)
    REFERENCES `mentee-union`.`forum` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mentee-union`.`cover`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mentee-union`.`cover` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `seminar_id` INT NULL,
  `origin_name` VARCHAR(150) NOT NULL,
  `new_name` VARCHAR(200) NOT NULL,
  `deleted_at` DATETIME NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  PRIMARY KEY (`id`),
  INDEX `fk_cover_seminar1_idx` (`seminar_id` ASC),
  CONSTRAINT `fk_cover_seminar1`
    FOREIGN KEY (`seminar_id`)
    REFERENCES `mentee-union`.`seminar` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
