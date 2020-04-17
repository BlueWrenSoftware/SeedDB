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

CREATE TABLE Propagations(
propagationId integer not null primary key autoincrement,
packetId references SeedPackets(packetId),
propagationCode text,
dateSeeded text, --date seeded in punnet etc
dateGerminated text,
numberSeeded integer,
numberGerminated integer,
germinationRate text, --excellent, good , avarage, poor, none
propagationSubstrate, --purlite, soil, water, etc
areaPropagated text, --which greenhouse, part in the garden etc
propagationNote text
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
	--Propagations.numberSeeded,
	--Propagations.numberGerminated,
	ifnull(sum(Propagations.numberSeeded),0) as totalPlanted,
	ifnull(sum(Propagations.numberGerminated),0) as totalGerminated,
	ifnull(((sum(cast(Propagations.numberGerminated as real))/sum(cast(Propagations.numberSeeded as real)))*100),0) as percentGerminated
from SeedTypes 
join Seeds 
using (seedTypeId)
join SeedPackets
using (seedId)
join Companies
using (companyId)
left outer join Propagations
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
	--Propagations fields
	propagationId, propagationCode, dateSeeded, dateGerminated, numberSeeded, numberGerminated, 
	germinationRate, propagationSubstrate, areaPropagated, propagationNote, percentGerminated
FROM--A

	(SELECT--B
		--Seeds fields
		seedId, seedVarietyName, seedTypeId, seedVarietyNote, 
		--SeedPackets fields
		packetId, packetCode, companyId, datePurchased, dateUseBy, seedCount, seedGram, packetTreatment, storageLocation,
		--Company fields
		companyName, companyAddress, companyUrl,
		--Propagations fields
		propagationId, propagationCode, dateSeeded, dateGerminated, numberSeeded, numberGerminated,germinationRate, propagationSubstrate, areaPropagated, propagationNote, percentGerminated
	FROM--B 
		Seeds
	LEFT OUTER JOIN--B
		
		(SELECT--C
			--SeedPackets fields
			packetId, seedId, companyId, packetCode, datePurchased, dateUseBy, 
			seedCount, seedGram, packetTreatment, storageLocation,
			--Company fields
			companyName, companyAddress, companyUrl,
			--Propagations fields
			propagationId, propagationCode, dateSeeded, dateGerminated,
			numberSeeded, numberGerminated, germinationRate, propagationSubstrate, areaPropagated, propagationNote,
			IFNULL(CAST(numberGerminated AS REAL)/CAST(numberSeeded AS REAL)*100,0.0) AS percentGerminated
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
			Propagations
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
