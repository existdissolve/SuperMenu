DROP TABLE IF EXISTS `sm_LinkMenuContent`,`sm_MenuItem`,`sm_Menu`,`sm_Zone`;

CREATE TABLE `sm_LinkMenuContent` (
`LinkMenuContentID` int(11) NOT NULL AUTO_INCREMENT,
`ContentID` int(11) NOT NULL,
`MenuID` int(11) NOT NULL,
`ZoneID` int(11) NULL DEFAULT NULL,
PRIMARY KEY (`LinkMenuContentID`) ,
INDEX `MenuID` (`MenuID`),
INDEX `ZoneID` (`ZoneID`),
INDEX `ContentID` (`ContentID`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `sm_Menu` (
`MenuID` int(11) NOT NULL AUTO_INCREMENT,
`Title` varchar(255) NOT NULL DEFAULT '',
`Slug` varchar(255) NOT NULL,
`MenuClass` varchar(255) NULL DEFAULT '',
`ListType` varchar(12) NULL DEFAULT 'ul',
`ZoneID` int(11) NULL DEFAULT NULL,
PRIMARY KEY (`MenuID`) ,
INDEX `fk_sm_Menu_Zone` (`ZoneID`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `sm_MenuItem` (
`MenuItemID` int(11) NOT NULL AUTO_INCREMENT,
`MenuID` int(11) NOT NULL,
`Label` varchar(255) NOT NULL,
`Title` varchar(255) NULL DEFAULT NULL,
`URL` varchar(255) NULL DEFAULT '',
`ParentID` int(11) NULL DEFAULT NULL,
`ContentID` int(11) NULL DEFAULT NULL,
`Type` varchar(255) NOT NULL DEFAULT '',
PRIMARY KEY (`MenuItemID`) ,
INDEX `ParentID` (`ParentID`),
INDEX `sm_MenuID_fk` (`MenuID`),
INDEX `ContentID` (`ContentID`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE `sm_Zone` (
`ZoneID` int(11) NOT NULL AUTO_INCREMENT,
`Name` varchar(255) NOT NULL DEFAULT '',
PRIMARY KEY (`ZoneID`) 
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=latin1 COLLATE=latin1_swedish_ci;

ALTER TABLE `sm_LinkMenuContent` ADD CONSTRAINT `sm_LinkMenuContent_ibfk_2` FOREIGN KEY (`ZoneID`) REFERENCES `sm_Zone` (`ZoneID`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `sm_LinkMenuContent` ADD CONSTRAINT `sm_LinkMenuContent_ibfk_1` FOREIGN KEY (`MenuID`) REFERENCES `sm_Menu` (`MenuID`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `sm_Menu` ADD CONSTRAINT `sm_Menu_ibfk_1` FOREIGN KEY (`ZoneID`) REFERENCES `sm_Zone` (`ZoneID`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `sm_MenuItem` ADD CONSTRAINT `sm_MenuItem_ibfk_3` FOREIGN KEY (`ContentID`) REFERENCES `cb_content` (`contentID`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `sm_MenuItem` ADD CONSTRAINT `sm_MenuItem_ibfk_1` FOREIGN KEY (`MenuID`) REFERENCES `sm_Menu` (`MenuID`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `sm_MenuItem` ADD CONSTRAINT `sm_MenuItem_ibfk_2` FOREIGN KEY (`ParentID`) REFERENCES `sm_MenuItem` (`MenuItemID`) ON DELETE CASCADE ON UPDATE CASCADE;