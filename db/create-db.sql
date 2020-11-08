BEGIN TRANSACTION;
DROP TABLE IF EXISTS "Harvests";
CREATE TABLE IF NOT EXISTS "Harvests" (
	"harvest_id"	INTEGER,
	"date_harvest"	TEXT,
	"harvest_amount"	TEXT,
	"harvest_notes"	TEXT,
	"id_user"	TEXT,
	PRIMARY KEY("harvest_id" AUTOINCREMENT),
	FOREIGN KEY("id_user") REFERENCES "Users"("id_user") ON DELETE SET NULL
);
DROP TABLE IF EXISTS "Plantings";
CREATE TABLE IF NOT EXISTS "Plantings" (
	"id_planting"	INTEGER,
	"date_planted"	TEXT,
	"id_location"	INTEGER,
	"planting_notes"	TEXT,
	"id_user"	TEXT,
	FOREIGN KEY("id_user") REFERENCES "Users"("id_user") ON DELETE SET NULL,
	PRIMARY KEY("id_planting" AUTOINCREMENT),
	FOREIGN KEY("id_location") REFERENCES "Locations"("id_location") ON DELETE SET NULL
);
DROP TABLE IF EXISTS "Propagations";
CREATE TABLE IF NOT EXISTS "Propagations" (
	"id_propagation"	INTEGER,
	"propagation_code"	TEXT,
	"date_planted"	TEXT,
	"date_germinated"	TEXT,
	"number_planted"	INTEGER,
	"number_germinated"	INTEGER,
	"germination_rate"	TEXT,
	"propagation_substrate"	TEXT,
	"id_location"	INTEGER,
	"propagation_notes"	TEXT,
	"id_user"	TEXT,
	PRIMARY KEY("id_propagation" AUTOINCREMENT),
	FOREIGN KEY("id_location") REFERENCES "Locations"("id_location"),
	FOREIGN KEY("id_user") REFERENCES "Users"("id_user") ON DELETE SET NULL
);
DROP TABLE IF EXISTS "Seeds";
CREATE TABLE IF NOT EXISTS "Seeds" (
	"id_seed_variety"	INTEGER,
	"id_seed_group"	INTEGER,
	"seed_variety_name"	TEXT,
	"seed_variety_description"	TEXT,
	"seed_variety_notes"	TEXT,
	"id_user"	TEXT,
	PRIMARY KEY("id_seed_variety" AUTOINCREMENT),
	FOREIGN KEY("id_seed_group") REFERENCES "SeedGroups"("id_seed_group") ON DELETE SET NULL,
	FOREIGN KEY("id_user") REFERENCES "Users"("id_user") ON DELETE SET NULL
);
DROP TABLE IF EXISTS "Locations";
CREATE TABLE IF NOT EXISTS "Locations" (
	"id_location"	INTEGER,
	"location"	TEXT,
	"location_description"	TEXT,
	"id_user"	TEXT,
	FOREIGN KEY("id_user") REFERENCES "Users"("id_user") ON DELETE SET NULL,
	PRIMARY KEY("id_location" AUTOINCREMENT)
);
DROP TABLE IF EXISTS "PropagationDates";
CREATE TABLE IF NOT EXISTS "PropagationDates" (
	"id_propagation_date"	INTEGER,
	"id_seed_packet"	INTEGER,
	"id_propagation"	INTEGER,
	FOREIGN KEY("id_seed_packet") REFERENCES "SeedPackets"("id_seed_packet") ON DELETE SET NULL,
	PRIMARY KEY("id_propagation_date" AUTOINCREMENT),
	FOREIGN KEY("id_propagation") REFERENCES "Propagations"("id_propagation") ON DELETE SET NULL
);
DROP TABLE IF EXISTS "PlantingDates";
CREATE TABLE IF NOT EXISTS "PlantingDates" (
	"id_planting_date"	INTEGER,
	"id_seed_variety"	INTEGER,
	"id_planting"	INTEGER,
	"id_propagation"	INTEGER,
	FOREIGN KEY("id_seed_variety") REFERENCES "Seeds"("id_seed_variety") ON DELETE SET NULL,
	PRIMARY KEY("id_planting_date" AUTOINCREMENT),
	FOREIGN KEY("id_propagation") REFERENCES "Propagations"("id_propagation") ON DELETE SET NULL,
	FOREIGN KEY("id_planting") REFERENCES "Plantings"("id_planting") ON DELETE SET NULL
);
DROP TABLE IF EXISTS "HarvestDates";
CREATE TABLE IF NOT EXISTS "HarvestDates" (
	"id_harvest_date"	INTEGER,
	"id_planting"	INTEGER,
	"id_harvest"	INTEGER,
	PRIMARY KEY("id_harvest_date" AUTOINCREMENT),
	FOREIGN KEY("id_planting") REFERENCES "Plantings"("id_planting") ON DELETE SET NULL,
	FOREIGN KEY("id_harvest") REFERENCES "Harvests"("harvest_id") ON DELETE SET NULL
);
DROP TABLE IF EXISTS "Users";
CREATE TABLE IF NOT EXISTS "Users" (
	"id_user"	TEXT NOT NULL CHECK(LENGTH("id_user") <= 3),
	"first_name"	TEXT,
	"last_name"	TEXT,
	PRIMARY KEY("id_user")
);
DROP TABLE IF EXISTS "SeedGroups";
CREATE TABLE IF NOT EXISTS "SeedGroups" (
	"id_seed_group"	INTEGER,
	"seed_group"	TEXT,
	"group_description"	TEXT,
	"id_user"	TEXT NOT NULL,
	PRIMARY KEY("id_seed_group" AUTOINCREMENT),
	FOREIGN KEY("id_user") REFERENCES "Users"("id_user") ON DELETE SET NULL
);
DROP TABLE IF EXISTS "Companies";
CREATE TABLE IF NOT EXISTS "Companies" (
	"id_company"	INTEGER,
	"company_name"	TEXT,
	"company_address"	TEXT,
	"company_http"	TEXT,
	"company_email"	TEXT,
	"id_user"	TEXT,
	FOREIGN KEY("id_user") REFERENCES "Users"("id_user") ON DELETE SET NULL,
	PRIMARY KEY("id_company" AUTOINCREMENT)
);
DROP TABLE IF EXISTS "SeedPackets";
CREATE TABLE IF NOT EXISTS "SeedPackets" (
	"id_seed_packet"	INTEGER NOT NULL,
	"id_seed_variety"	INTEGER,
	"id_company"	INTEGER,
	"id_location"	INTEGER,
	"packet_label"	TEXT,
	"date_obtained"	TEXT,
	"date_use_by"	TEXT,
	"seed_count"	INTEGER,
	"seed_gram"	INTEGER,
	"packet_treatment"	TEXT,
	"id_user"	TEXT,
	FOREIGN KEY("id_user") REFERENCES "Users"("id_user") ON DELETE SET NULL,
	FOREIGN KEY("id_company") REFERENCES "Companies"("id_company") ON DELETE SET NULL,
	FOREIGN KEY("id_location") REFERENCES "Locations"("id_location") ON DELETE SET NULL,
	FOREIGN KEY("id_seed_variety") REFERENCES "Seeds"("id_seed_variety") ON DELETE SET NULL,
	PRIMARY KEY("id_seed_packet" AUTOINCREMENT)
);
DROP VIEW IF EXISTS "ViewSeedList2";
CREATE VIEW ViewSeedList2 as 
select
	SeedGroups.seed_group
	,Seeds.seed_variety_name
	,count(SeedPackets.id_seed_packet) as seedPacketCount
	,ifnull(sum(SeedPackets.seed_count),0) as totalSeedCount
	,ifnull(sum(SeedPackets.seed_gram),0) as totalSeedGram
        ,Seeds.id_seed_variety
from SeedGroups 
join Seeds 
using (id_seed_group)
left outer join SeedPackets
using (id_seed_variety)
group by
	id_seed_group,
	seed_group,
	id_seed_variety,
	seed_variety_name;
COMMIT;
