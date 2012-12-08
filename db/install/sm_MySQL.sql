DROP TABLE IF EXISTS `sm_Menu`;
DROP TABLE IF EXISTS `sm_MenuItem`;
DROP TABLE IF EXISTS `sm_LinkMenuPage`;
DROP TABLE IF EXISTS `sm_LinkMenuLayout`;

CREATE TABLE `sm_Menu` (
`MenuID` integer(11) NOT NULL AUTO_INCREMENT,
`Slug` varchar(255) NOT NULL,
`Orientation` varchar(12) NOT NULL,
PRIMARY KEY (`MenuID`) 
);

CREATE TABLE `sm_MenuItem` (
`MenuItemID` integer(11) NOT NULL AUTO_INCREMENT,
`MenuID` integer(11) NOT NULL,
`Label` varchar(255) NOT NULL,
`Title` varchar(255) NULL,
`Slug` varchar(255) NOT NULL,
PRIMARY KEY (`MenuItemID`) 
);

CREATE TABLE `sm_LinkMenuPage` (
`ContentID` integer(11) NOT NULL,
`MenuID` integer(11) NOT NULL
);

CREATE TABLE `sm_LinkMenuLayout` (
`Layout` varchar(255) NOT NULL,
`MenuID` integer(11) NOT NULL
);


ALTER TABLE `sm_MenuItem` ADD CONSTRAINT `fk_sm_MenuItem` FOREIGN KEY (`MenuID`) REFERENCES `sm_Menu` (`MenuID`);
ALTER TABLE `sm_LinkMenuPage` ADD CONSTRAINT `fk_sm_LinkMenuPage` FOREIGN KEY (`MenuID`) REFERENCES `sm_Menu` (`MenuID`);
ALTER TABLE `sm_LinkMenuLayout` ADD CONSTRAINT `fk_sm_LinkMenuLayout` FOREIGN KEY (`MenuID`) REFERENCES `sm_Menu` (`MenuID`);

