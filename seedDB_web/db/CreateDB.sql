PRAGMA foreign_keys=ON;
BEGIN TRANSACTION;

CREATE TABLE SeedTypes (
seedTypeId integer not null primary key autoincrement,
seedTypeName text,
seedDescription text
);

CREATE TABLE Seeds 
(
seedId integer not null primary key autoincrement,
seedVarietyName text,
seedTypeId integer references SeedTypes(seedTypeId),
seedVarietyNote text
);

CREATE TABLE Companies (
companyId integer not null primary key,
companyName text,
companyAddress text,
companyUrl text
);

CREATE TABLE SeedPackets (
packetId integer not null primary key autoincrement,
packetCode text,
seedId integer references Seeds(seedId),
companyId integer references Companies(companyId),
datePurchased text, -- can be date collected
dateUseBy text,
seedCount integer,
seedGram integer,
packetTreatment text,
storageLocation text
);

CREATE TABLE Plantings(
plantingId integer not null primary key autoincrement,
packetId references SeedPackets(packetId),
plantingCode text,
datePlanted text,
dateGerminated text,
numberPlanted integer,
numberGerminated integer,
areaPlanted text,
plantingNote text,
germinationNote text,
generalNote
);

CREATE VIEW ViewSeedList as 
select
	SeedTypes.seedTypeId
	,SeedTypes.seedTypeName
	,Seeds.seedId
	,Seeds.seedVarietyName
	,count(SeedPackets.packetId) as seedPacketCount
	,ifnull(sum(SeedPackets.seedCount),0) as totalSeedCount
	,ifnull(sum(SeedPackets.seedGram),0) as totalSeedGram
from SeedTypes 
join Seeds 
using (seedTypeId)
left outer join SeedPackets
using (seedId)
group by
	seedTypeId,
	seedTypeName,
	seedId,
	seedVarietyName;

CREATE VIEW schema as select * from sqlite_master;

CREATE VIEW ViewPacketsList as 
select
	SeedTypes.seedTypeId,
	SeedTypes.seedTypeName,
	Seeds.seedId,
	Seeds.seedVarietyName,
	SeedPackets.packetId,
	SeedPackets.packetCode,
	SeedPackets.companyId,
	SeedPackets.datePurchased,
	SeedPackets.dateUseBy,
	SeedPackets.seedCount,
	SeedPackets.seedGram,
	Companies.companyName,
	--Plantings.numberPlanted,
	--Plantings.numberGerminated,
	ifnull(sum(Plantings.numberPlanted),0) as totalPlanted,
	ifnull(sum(Plantings.numberGerminated),0) as totalGerminated,
	ifnull(((sum(cast(Plantings.numberGerminated as real))/sum(cast(Plantings.numberPlanted as real)))*100),0) as percentGerminated
from SeedTypes 
join Seeds 
using (seedTypeId)
join SeedPackets
using (seedId)
join Companies
using (companyId)
left outer join Plantings
using (packetId)
group by
	SeedTypes.seedTypeId,
	SeedTypes.seedTypeName,
	Seeds.seedId,
	Seeds.seedVarietyName,
	SeedPackets.packetId,
	SeedPackets.packetCode,
	SeedPackets.companyId,
	SeedPackets.datePurchased,
	SeedPackets.dateUseBy,
	SeedPackets.seedCount,
	SeedPackets.seedGram,
	Companies.companyName
;

CREATE VIEW ViewAllTables AS
SELECT--A
	--SeedTypes fields
	seedTypeId,seedTypeName, seedDescription,
	--Seeds fields
	seedId, seedVarietyName, seedVarietyNote,
	--SeedPackets fields
	packetId, packetCode, companyId, datePurchased, dateUseBy, seedCount, seedGram, packetTreatment, storageLocation,
	--Company fields
	companyName, companyAddress, companyUrl,
	--Plantings fields
	plantingId, plantingCode, datePlanted, dateGerminated, numberPlanted, numberGerminated, 
	areaPlanted, plantingNote, germinationNote, generalNote, percentGerminated
FROM--A

	(SELECT--B
		--Seeds fields
		seedId, seedVarietyName, seedTypeId, seedVarietyNote, 
		--SeedPackets fields
		packetId, packetCode, companyId, datePurchased, dateUseBy, seedCount, seedGram, packetTreatment, storageLocation,
		--Company fields
		companyName, companyAddress, companyUrl,
		--Plantings fields
		plantingId, plantingCode, datePlanted, dateGerminated, numberPlanted, numberGerminated, 
		areaPlanted, plantingNote, germinationNote, generalNote, percentGerminated
	FROM--B 
		Seeds
	LEFT OUTER JOIN--B
		
		(SELECT--C
			--SeedPackets fields
			packetId, seedId, companyId, packetCode, datePurchased, dateUseBy, 
			seedCount, seedGram, packetTreatment, storageLocation,
			--Company fields
			companyName, companyAddress, companyUrl,
			--Plantings fields
			plantingId, plantingCode, datePlanted, dateGerminated,
			numberPlanted, numberGerminated, areaPlanted, 
			plantingNote, germinationNote, generalNote,
			IFNULL(CAST(numberGerminated AS REAL)/CAST(numberPlanted AS REAL)*100,0.0) AS percentGerminated
		FROM--C
		
			(SELECT--D
				--SeedPackets fields
				packetId, seedId, companyId, packetCode, datePurchased, dateUseBy, 
				seedCount, seedGram, packetTreatment, storageLocation,
				--Company fields
				companyName, companyAddress, companyUrl
			FROM--D
				COMPANIES
			LEFT OUTER JOIN--D 
				SeedPackets
			USING--D
				(companyId)
				)--end D
		
		LEFT OUTER JOIN--C
			Plantings
		USING--C
			(packetId)
		)--end C
	USING--B 
		(seedId)
		)--end B
		
LEFT OUTER JOIN--A
	SeedTypes
USING--A
	(seedTypeId)--end A
;


COMMIT;
