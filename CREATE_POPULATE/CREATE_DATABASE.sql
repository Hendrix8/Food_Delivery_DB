DROP DATABASE food_delivery;

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema food_delivery
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `food_delivery` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `food_delivery` ;

-- -----------------------------------------------------
-- Table `food_delivery`.`CUSTOMER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `food_delivery`.`CUSTOMER` (
  `customer_username` VARCHAR(100) NOT NULL,
  `fname` VARCHAR(50) NOT NULL,
  `lname` VARCHAR(50) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(50) NOT NULL,
  `address` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`customer_username`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `food_delivery`.`RESTAURANT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `food_delivery`.`RESTAURANT` (
  `rest_vat` VARCHAR(100) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `location` VARCHAR(255) NOT NULL,
  `cuisine_type` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`rest_vat`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `food_delivery`.`COUPON`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `food_delivery`.`COUPON` (
  `coupon_id` VARCHAR(100) NOT NULL,
  `coupon_code` VARCHAR(100) NOT NULL,
  `discount` DECIMAL(4,2) NOT NULL,
  `expiration_date` DATETIME NOT NULL,
  PRIMARY KEY (`coupon_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `food_delivery`.`ORDERS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `food_delivery`.`ORDERS` (
  `receipt_num` VARCHAR(100) NOT NULL,
  `customer_username` VARCHAR(100),
  `rest_vat` VARCHAR(100) NOT NULL,
  `coupon_id` VARCHAR(100) NULL DEFAULT NULL,
  `delivery_address` VARCHAR(100) NOT NULL,
  `total_cost` DECIMAL(10,2) NOT NULL,
  `order_date` DATETIME NOT NULL,
  `status` DECIMAL(2,1) NOT NULL,
  PRIMARY KEY (`receipt_num`),
  INDEX `customer_id` (`customer_username` ASC) VISIBLE,
  INDEX `restaurant_id` (`rest_vat` ASC) VISIBLE,
  INDEX `coupon_id` (`coupon_id` ASC) VISIBLE,
  CONSTRAINT `client_order_ibfk_1`
    FOREIGN KEY (`customer_username`)
    REFERENCES `food_delivery`.`CUSTOMER` (`customer_username`)
    ON DELETE SET NULL,
  CONSTRAINT `client_order_ibfk_2`
    FOREIGN KEY (`rest_vat`)
    REFERENCES `food_delivery`.`RESTAURANT` (`rest_vat`)
    ON DELETE CASCADE,
  CONSTRAINT `client_order_ibfk_4`
    FOREIGN KEY (`coupon_id`)
    REFERENCES `food_delivery`.`COUPON` (`coupon_id`)
    ON DELETE SET NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `food_delivery`.`DRIVER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `food_delivery`.`DRIVER` (
  `ssn` VARCHAR(100) NOT NULL,
  `fname` VARCHAR(50) NOT NULL,
  `lname` VARCHAR(50) NOT NULL,
  `phone` VARCHAR(50) NOT NULL,
  `address` VARCHAR(255) NOT NULL,
  `status` BINARY(1) NOT NULL,
  `gender` BINARY(1) NOT NULL,
  `birth_date` DATETIME NOT NULL,
  PRIMARY KEY (`ssn`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `food_delivery`.`MENU_ITEM`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `food_delivery`.`MENU_ITEM` (
  `item_barcode` VARCHAR(100) NOT NULL,
  `rest_vat` VARCHAR(100) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `price` DECIMAL(4,2) NOT NULL,
  `availability` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`item_barcode`),
  INDEX `restaurant_id` (`rest_vat` ASC) VISIBLE,
  CONSTRAINT `menu_item_ibfk_1`
    FOREIGN KEY (`rest_vat`)
    REFERENCES `food_delivery`.`RESTAURANT` (`rest_vat`)
    ON DELETE CASCADE) 
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;



-- -----------------------------------------------------
-- Table `food_delivery`.`PAYMENT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `food_delivery`.`PAYMENT` (
  `trans_id` VARCHAR(100) NOT NULL,
  `receipt_num` VARCHAR(100) NOT NULL,
  `payment_method` VARCHAR(100) NOT NULL,
  `payment_status` VARCHAR(100) NOT NULL,
  `trans_date` DATETIME NOT NULL,
  PRIMARY KEY (`trans_id`),
  INDEX `fk_PAYMENT_ORDERS1_idx` (`receipt_num` ASC) VISIBLE,
  CONSTRAINT `fk_PAYMENT_ORDERS1`
    FOREIGN KEY (`receipt_num`)
    REFERENCES `food_delivery`.`ORDERS` (`receipt_num`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- If a row in PAYMENT is deleted then the corresponding row in ORDERS will be deleted 
DELIMITER $$
CREATE TRIGGER delete_order_on_payment_delete
AFTER DELETE ON PAYMENT
FOR EACH ROW
BEGIN
  DELETE FROM ORDERS WHERE receipt_num = OLD.receipt_num;
END $$
DELIMITER ;


-- -----------------------------------------------------
-- Table `food_delivery`.`RATING`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `food_delivery`.`RATING` (
  `rating_id` VARCHAR(100) NOT NULL,
  `customer_username` VARCHAR(100),
  `rest_vat` VARCHAR(100) NULL DEFAULT NULL,
  `driver_ssn` VARCHAR(100) NULL DEFAULT NULL,
  `item_barcode` VARCHAR(100) NULL DEFAULT NULL,
  `rating` DECIMAL(2,1) NOT NULL,
  `review` TEXT(200) NULL DEFAULT NULL,
  PRIMARY KEY (`rating_id`),
  INDEX `customer_id` (`customer_username` ASC) VISIBLE,
  INDEX `restaurant_id` (`rest_vat` ASC) VISIBLE,
  INDEX `driver_id` (`driver_ssn` ASC) VISIBLE,
  INDEX `item_id` (`item_barcode` ASC) VISIBLE,
  CONSTRAINT `rating_ibfk_1`
    FOREIGN KEY (`customer_username`)
    REFERENCES `food_delivery`.`CUSTOMER` (`customer_username`)
    ON DELETE SET NULL,
  CONSTRAINT `rating_ibfk_2`
    FOREIGN KEY (`rest_vat`)
    REFERENCES `food_delivery`.`RESTAURANT` (`rest_vat`) 
    ON DELETE CASCADE,
  CONSTRAINT `rating_ibfk_3`
    FOREIGN KEY (`driver_ssn`)
    REFERENCES `food_delivery`.`DRIVER` (`ssn`)
    ON DELETE CASCADE,
  CONSTRAINT `rating_ibfk_4`
    FOREIGN KEY (`item_barcode`)
    REFERENCES `food_delivery`.`MENU_ITEM` (`item_barcode`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `food_delivery`.`DELIVERS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `food_delivery`.`DELIVERS` (
  `receipt_num` VARCHAR(100) NOT NULL,
  `driver_ssn` VARCHAR(100) NOT NULL,
  `time_start` TIME NOT NULL,
  `time_end` TIME NOT NULL,
  `distance` DECIMAL(10,2) NOT NULL,
  `tips` DECIMAL(10,2) NOT NULL DEFAULT 0,
  PRIMARY KEY (`receipt_num`, `driver_ssn`),
  INDEX `fk_ORDER_has_DRIVER_DRIVER1_idx` (`driver_ssn` ASC) VISIBLE,
  INDEX `fk_ORDER_has_DRIVER_ORDER1_idx` (`receipt_num` ASC) VISIBLE,
  CONSTRAINT `fk_ORDER_has_DRIVER_ORDER1`
    FOREIGN KEY (`receipt_num`)
    REFERENCES `food_delivery`.`ORDERS` (`receipt_num`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ORDER_has_DRIVER_DRIVER1`
    FOREIGN KEY (`driver_ssn`)
    REFERENCES `food_delivery`.`DRIVER` (`ssn`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;



DELIMITER $$

-- Cannot delete in DELIVERS if corresponding rows in DRIVER and ORDERS are not deleted 
CREATE TRIGGER tr_delivers_restriction
BEFORE DELETE ON DELIVERS
FOR EACH ROW
BEGIN
    DECLARE driver_exists INT DEFAULT 0;
    DECLARE order_exists INT DEFAULT 0;

    SELECT COUNT(*) INTO driver_exists
    FROM DRIVER
    WHERE ssn = OLD.driver_ssn;

    SELECT COUNT(*) INTO order_exists
    FROM ORDERS
    WHERE receipt_num = OLD.receipt_num;

    IF driver_exists > 0 OR order_exists > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete from DELIVERS if corresponding rows in DRIVER and ORDERS are not deleted';
    END IF;
END$$

DELIMITER ;


-- -----------------------------------------------------
-- Table `food_delivery`.`INCLUDES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `food_delivery`.`INCLUDES` (
  `item_barcode` VARCHAR(100) NOT NULL,
  `receipt_num` VARCHAR(100) NOT NULL,
  `quantity` INT NOT NULL DEFAULT 1,
  PRIMARY KEY (`item_barcode`, `receipt_num`),
  INDEX `fk_MENU_ITEM_has_ORDER_ORDER1_idx` (`receipt_num` ASC) VISIBLE,
  INDEX `fk_MENU_ITEM_has_ORDER_MENU_ITEM1_idx` (`item_barcode` ASC) VISIBLE,
  CONSTRAINT `fk_MENU_ITEM_has_ORDER_MENU_ITEM1`
    FOREIGN KEY (`item_barcode`)
    REFERENCES `food_delivery`.`MENU_ITEM` (`item_barcode`) 
		ON DELETE CASCADE
		ON UPDATE NO ACTION,
  CONSTRAINT `fk_MENU_ITEM_has_ORDER_ORDER1`
    FOREIGN KEY (`receipt_num`)
    REFERENCES `food_delivery`.`ORDERS` (`receipt_num`)
		ON DELETE CASCADE
		ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;




DELIMITER $$

-- Cannot delete in INCLUDES if corresponding rows in MENU_ITEM and ORDERS are not deleted 
CREATE TRIGGER tr_includes_restriction
BEFORE DELETE ON INCLUDES
FOR EACH ROW
BEGIN
    DECLARE item_exists INT DEFAULT 0;
    DECLARE order_exists INT DEFAULT 0;

    SELECT COUNT(*) INTO item_exists
    FROM MENU_ITEM
    WHERE item_barcode = OLD.item_barcode;

    SELECT COUNT(*) INTO order_exists
    FROM ORDERS
    WHERE receipt_num = OLD.receipt_num;

    IF item_exists > 0 OR order_exists > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete from INCLUDES if corresponding rows in MENU_ITEM and ORDERS are not deleted';
    END IF;
END$$

DELIMITER ;



-- -----------------------------------------------------
-- Table `food_delivery`.`OWNER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `food_delivery`.`OWNER` (
  `ssn` VARCHAR(100) NOT NULL,
  `fname` VARCHAR(50) NOT NULL,
  `lname` VARCHAR(50) NOT NULL,
  `phone` VARCHAR(50) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `address` VARCHAR(255) NOT NULL,
  `gender` BINARY(1) NOT NULL,
  `birth_date` DATETIME NOT NULL,
  PRIMARY KEY (`ssn`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `food_delivery`.`OWNED`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `food_delivery`.`OWNED` (
  `rest_vat` VARCHAR(100) NOT NULL,
  `owner_ssn` VARCHAR(100) NOT NULL,
  `start_date` DATETIME NOT NULL,
  `hours` DECIMAL(10,2) NOT NULL,
  `investment` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`rest_vat`, `owner_ssn`),
  INDEX `fk_RESTAURANT_has_OWNER_OWNER1_idx` (`owner_ssn` ASC) VISIBLE,
  INDEX `fk_RESTAURANT_has_OWNER_RESTAURANT1_idx` (`rest_vat` ASC) VISIBLE,
  CONSTRAINT `fk_RESTAURANT_has_OWNER_RESTAURANT1`
    FOREIGN KEY (`rest_vat`)
    REFERENCES `food_delivery`.`RESTAURANT` (`rest_vat`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_RESTAURANT_has_OWNER_OWNER1`
    FOREIGN KEY (`owner_ssn`)
    REFERENCES `food_delivery`.`OWNER` (`ssn`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

DELIMITER $$

-- Cannot delete in OWNED if corresponding rows in RESTAURANT and OWNED are not deleted 

CREATE TRIGGER tr_owned_restriction
BEFORE DELETE ON OWNED
FOR EACH ROW
BEGIN
    DECLARE owner_exists INT DEFAULT 0;
    DECLARE rest_exists INT DEFAULT 0;

    SELECT COUNT(*) INTO owner_exists
    FROM OWNER
    WHERE ssn = OLD.owner_ssn;

    SELECT COUNT(*) INTO rest_exists
    FROM RESTAURANT
    WHERE rest_vat = OLD.rest_vat;

    IF owner_exists > 0 OR rest_exists > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete from OWNED if corresponding rows in OWNER and RESTAURANT are not deleted';
    END IF;
END$$

DELIMITER ;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
