BEGIN TRANSACTION;
DROP TABLE IF EXISTS `Companies`;
CREATE TABLE IF NOT EXISTS `Companies` (
	`id_company`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`company_name`	TEXT,
	`company_address`	TEXT,
	`company_http`	TEXT,
	`company_email`	TEXT,
	`id_user`	TEXT,
	FOREIGN KEY(`id_user`) REFERENCES `Users`(`id_user`) ON DELETE SET NULL
);
DROP TABLE IF EXISTS `SeedTypes`;
CREATE TABLE IF NOT EXISTS `SeedTypes` (
	`id_seed_type`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`seed_catagory`	TEXT,
	'seed_description' TEXT,
	`id_user`	TEXT NOT NULL,
	FOREIGN KEY(`id_user`) REFERENCES `Users`(`id_user`) ON DELETE SET NULL
);
DROP TABLE IF EXISTS `Users`;
CREATE TABLE IF NOT EXISTS `Users` (
	`id_user`	TEXT NOT NULL CHECK(LENGTH ( id_user ) <= 3),
	`first_name`	TEXT,
	`last_name`	TEXT,
	PRIMARY KEY(`id_user`)
);
DROP TABLE IF EXISTS `HarvestDates`;
CREATE TABLE IF NOT EXISTS `HarvestDates` (
	`id_harvest_date`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`id_planting`	INTEGER,
	`id_harvest`	INTEGER,
	FOREIGN KEY(`id_planting`) REFERENCES `Plantings`(`id_planting`) ON DELETE SET NULL,
	FOREIGN KEY(`id_harvest`) REFERENCES `Harvests`(`harvest_id`) ON DELETE SET NULL
);
DROP TABLE IF EXISTS `PlantingDates`;
CREATE TABLE IF NOT EXISTS `PlantingDates` (
	`id_planting_date`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`id_seed`	INTEGER,
	`id_planting`	INTEGER,
	`id_propagation`	INTEGER,
	FOREIGN KEY(`id_seed`) REFERENCES `Seeds`(`id_seed`) ON DELETE SET NULL,
	FOREIGN KEY(`id_planting`) REFERENCES `Plantings`(`id_planting`) ON DELETE SET NULL,
	FOREIGN KEY(`id_propagation`) REFERENCES `Propagations`(`id_propagation`) ON DELETE SET NULL
);
DROP TABLE IF EXISTS `PropagationDates`;
CREATE TABLE IF NOT EXISTS `PropagationDates` (
	`id_propagation_date`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`id_seed`	INTEGER,
	`id_propagation`	INTEGER,
	FOREIGN KEY(`id_propagation`) REFERENCES `Propagations`(`id_propagation`) ON DELETE SET NULL,
	FOREIGN KEY(`id_seed`) REFERENCES `Seeds`(`id_seed`) ON DELETE SET NULL
);
DROP TABLE IF EXISTS `Locations`;
CREATE TABLE IF NOT EXISTS `Locations` (
	`id_location`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`location`	TEXT,
	`location_description`	TEXT,
	`id_user`	TEXT,
	FOREIGN KEY(`id_user`) REFERENCES `Users`(`id_user`) ON DELETE SET NULL
);
DROP TABLE IF EXISTS `Seeds`;
CREATE TABLE IF NOT EXISTS `Seeds` (
	`id_seed`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`id_seed_type`	INTEGER,
	`seed_variety_name`	TEXT,
	`seed_variety_description`	TEXT,
	`seed_variety_notes`	TEXT,
	`id_user`	TEXT,
	FOREIGN KEY(`id_user`) REFERENCES `Users`(`id_user`) ON DELETE SET NULL,
	FOREIGN KEY(`id_seed_type`) REFERENCES `SeedTypes`(`id_seed_type`) ON DELETE SET NULL
);
DROP TABLE IF EXISTS `SeedPackets`;
CREATE TABLE IF NOT EXISTS `SeedPackets` (
	`id_seed_packet`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`id_seed`	INTEGER,
	`id_company`	INTEGER,
	`packet_code`	TEXT,
	`date_purchased`	TEXT,
	`date_use_by`	TEXT,
	`seed_count`	INTEGER,
	`seed_gram`	INTEGER,
	`packet_treatment`	TEXT,
	`storage_location`	INTEGER,
	`id_user`	TEXT,
	FOREIGN KEY(`id_seed`) REFERENCES `Seeds`(`id_seed`) ON DELETE SET NULL,
	FOREIGN KEY(`storage_location`) REFERENCES `Companies`(`id_company`) ON DELETE SET NULL,
	FOREIGN KEY(`id_company`) REFERENCES `Companies`(`id_company`) ON DELETE SET NULL,
	FOREIGN KEY(`id_user`) REFERENCES `Users`(`id_user`) ON DELETE SET NULL
);
DROP TABLE IF EXISTS `Propagations`;
CREATE TABLE IF NOT EXISTS `Propagations` (
	`id_propagation`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`propagation_code`	TEXT,
	`date_seeded`	TEXT,
	`date_germinated`	TEXT,
	`number_seeded`	INTEGER,
	`number_germinated`	INTEGER,
	`germination_rate`	TEXT,
	`propagation_substrate`	TEXT,
	`propagation_location`	INTEGER,
	`propagation_notes`	TEXT,
	`id_user`	TEXT,
	FOREIGN KEY(`id_user`) REFERENCES `Users`(`id_user`) ON DELETE SET NULL,
	FOREIGN KEY(`propagation_location`) REFERENCES `Locations`(`id_location`)
);
DROP TABLE IF EXISTS `Plantings`;
CREATE TABLE IF NOT EXISTS `Plantings` (
	`id_planting`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`date_planted`	TEXT,
	`planting_location`	INTEGER,
	`planting_notes`	TEXT,
	`id_user`	TEXT,
	FOREIGN KEY(`planting_location`) REFERENCES `Locations`(`id_location`) ON DELETE SET NULL,
	FOREIGN KEY(`id_user`) REFERENCES `Users`(`id_user`) ON DELETE SET NULL
);
DROP TABLE IF EXISTS `Harvests`;
CREATE TABLE IF NOT EXISTS `Harvests` (
	`harvest_id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`date_harvest`	TEXT,
	`harvest_amount`	TEXT,
	`harvest_notes`	TEXT,
	`id_user`	TEXT,
	FOREIGN KEY(`id_user`) REFERENCES `Users`(`id_user`) ON DELETE SET NULL
);



CREATE VIEW ViewSeedList as 
select
	SeedTypes.id_seed_type
	,SeedTypes.seed_catagory
	,Seeds.id_seed
	,Seeds.seed_variety_name
	,count(SeedPackets.id_seed_packet) as seedPacketCount
	,ifnull(sum(SeedPackets.seed_count),0) as totalSeedCount
	,ifnull(sum(SeedPackets.seed_gram),0) as totalSeedGram
from SeedTypes 
join Seeds 
using (id_seed_type)
left outer join SeedPackets
using (id_seed)
group by
	id_seed_type,
	seed_catagory,
	id_seed,
	seed_variety_name;

COMMIT;


