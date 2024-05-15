CREATE TABLE `mms_bottleshooting` (
	`identifier` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`charidentifier` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`firstname` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`lastname` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`easyfinish` INT(11) NULL DEFAULT NULL,
	`middlefinish` INT(11) NULL DEFAULT NULL,
	`hardfinish` INT(11) NULL DEFAULT NULL
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;
