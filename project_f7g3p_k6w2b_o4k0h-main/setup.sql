CREATE TABLE Village (
    name VARCHAR(20) PRIMARY KEY,
    region VARCHAR(20) NOT NULL,
    population INTEGER NOT NULL,
    minLevel INTEGER NOT NULL
);

CREATE TABLE PetAbility(
    species VARCHAR(10) PRIMARY KEY,
    ability VARCHAR(10) NOT NULL
);

CREATE TABLE PetSpecies(
    name VARCHAR(15) PRIMARY KEY,
    species VARCHAR(10) NOT NULL,
    FOREIGN KEY (species) REFERENCES PetAbility(species)
    ON DELETE CASCADE
);

CREATE TABLE PlayableCharacter(
    username VARCHAR(10) PRIMARY KEY,
    class VARCHAR(15) NOT NULL,
    charLevel INTEGER NOT NULL,
    health INTEGER NOT NULL,
    energy INTEGER NOT NULL,
    attack INTEGER NOT NULL,
    defense INTEGER NOT NULL,
    speed INTEGER NOT NULL,
    pet VARCHAR(15),
    FOREIGN KEY (pet) REFERENCES PetSpecies(name)
    ON DELETE SET NULL
);

CREATE TABLE EquipmentType(
    type VARCHAR(10) PRIMARY KEY,
    affectedStat VARCHAR(10) NOT NULL
);

CREATE TABLE EquipmentName (
    name VARCHAR(15) PRIMARY KEY,
    rarity VARCHAR(10) NOT NULL,
    type VARCHAR(10) NOT NULL,
    FOREIGN KEY (type) REFERENCES EquipmentType(type)
    ON DELETE CASCADE
);

CREATE TABLE Sells (
    village VARCHAR(20),
    equipment VARCHAR(15),
    price INTEGER NOT NULL,
    PRIMARY KEY (village, equipment),
    FOREIGN KEY (village) REFERENCES Village(name)
    ON DELETE CASCADE,
    FOREIGN KEY (equipment) REFERENCES EquipmentName(name)
    ON DELETE CASCADE
);

CREATE TABLE EquipmentUser (
    name VARCHAR(15) PRIMARY KEY,
    usedBy VARCHAR(10),
    FOREIGN KEY (name) REFERENCES EquipmentName(name)
    ON DELETE CASCADE,
    FOREIGN KEY (usedBy) REFERENCES PlayableCharacter(username)
    ON DELETE SET NULL
);

CREATE TABLE EquipmentStatBoost (
    name VARCHAR(15) PRIMARY KEY,
    statBoost INTEGER NOT NULL,
    FOREIGN KEY (name) REFERENCES EquipmentName(name)
    ON DELETE CASCADE
);

CREATE TABLE DungeonName(
    name VARCHAR(30) PRIMARY KEY,
    boss VARCHAR(25) NOT NULL,
    difficulty INTEGER NOT NULL
);

CREATE TABLE Contains(
    equipment VARCHAR(15),
    dungeon VARCHAR(30),
    PRIMARY KEY (equipment, dungeon),
    FOREIGN KEY (equipment) REFERENCES EquipmentName(name)
    ON DELETE CASCADE,
    FOREIGN KEY (dungeon) REFERENCES DungeonName(name)
    ON DELETE CASCADE
);

CREATE TABLE DungeonMinLevelToDifficulty(
    minLevel INTEGER PRIMARY KEY,
    difficulty INTEGER NOT NULL
);

CREATE TABLE DungeonMinLevel(
    name VARCHAR(30) PRIMARY KEY,
    minLevel INTEGER,
    FOREIGN KEY (name) REFERENCES DungeonName(name)
    ON DELETE CASCADE,
    FOREIGN KEY (minLevel) REFERENCES DungeonMinLevelToDifficulty(minLevel)
    ON DELETE CASCADE
);

CREATE TABLE DungeonRegion(
    name VARCHAR(30) PRIMARY KEY,
    region VARCHAR(20) NOT NULL,
    FOREIGN KEY (name) REFERENCES DungeonName(name)
    ON DELETE CASCADE
);

CREATE TABLE NPC(
    name VARCHAR(10) PRIMARY KEY,
    title VARCHAR(20),
    village VARCHAR(20),
    FOREIGN KEY (village) REFERENCES Village(name)
    ON DELETE SET NULL
);

CREATE TABLE Interacts(
    npc VARCHAR(10),
    playableCharacter VARCHAR(10),
    PRIMARY KEY (npc, playableCharacter),
    FOREIGN KEY (npc) REFERENCES NPC(name)
    ON DELETE CASCADE,
    FOREIGN KEY (playableCharacter) REFERENCES PlayableCharacter(username)
    ON DELETE CASCADE
);

CREATE TABLE Quest(
    title VARCHAR(30) PRIMARY KEY,
    difficulty INTEGER NOT NULL,
    reward INTEGER NOT NULL,
    length INTEGER NOT NULL,
    minLevel INTEGER NOT NULL
);

CREATE TABLE WorksOn(
    quest VARCHAR(25),
    npc VARCHAR(10),
    playableCharacter VARCHAR(10),
    PRIMARY KEY (quest, playableCharacter),
    FOREIGN KEY (quest) REFERENCES Quest(title)
    ON DELETE CASCADE,
    FOREIGN KEY (npc) REFERENCES NPC(name)
    ON DELETE CASCADE,
    FOREIGN KEY (playableCharacter) REFERENCES PlayableCharacter(username)
    ON DELETE CASCADE
);

CREATE TABLE PetOwner(
    name VARCHAR(10) PRIMARY KEY,
    owner VARCHAR(10),
    FOREIGN KEY (name) REFERENCES PetSpecies(name)
    ON DELETE CASCADE,
    FOREIGN KEY (owner) REFERENCES PlayableCharacter(username)
    ON DELETE CASCADE
);

CREATE TABLE PetLevel(
    species VARCHAR(10),
    abilityCooldown INTEGER,
    pLevel INTEGER NOT NULL,
    PRIMARY KEY (species, abilityCooldown),
    FOREIGN KEY (species) REFERENCES PetAbility(species)
    ON DELETE CASCADE
);

CREATE TABLE Monster(
    name VARCHAR(25) PRIMARY KEY,
    type VARCHAR(15) NOT NULL,
    monsLevel INTEGER NOT NULL,
    health INTEGER NOT NULL,
    attack INTEGER NOT NULL,
    defense INTEGER NOT NULL,
    defends VARCHAR(30),
    FOREIGN KEY (defends) REFERENCES DungeonName(name)
    ON DELETE SET NULL
);

CREATE TABLE Fights(
    playableCharacter VARCHAR(10),
    monster VARCHAR(25),
    PRIMARY KEY (playableCharacter, monster),
    FOREIGN KEY (playableCharacter) REFERENCES PlayableCharacter(username)
    ON DELETE CASCADE,
    FOREIGN KEY (monster) REFERENCES Monster(name)
    ON DELETE CASCADE
);

CREATE TABLE Boss(
    name VARCHAR(25) PRIMARY KEY,
    ability VARCHAR(20) UNIQUE,
    FOREIGN KEY (name) REFERENCES Monster(name)
    ON DELETE CASCADE
);

CREATE TABLE Neutral(
    name VARCHAR(25) PRIMARY KEY,
    triggeredBy VARCHAR(15) NOT NULL,
    FOREIGN KEY (name) REFERENCES Monster(name)
    ON DELETE CASCADE
);

-- INSERTS

INSERT
INTO Village(name, region, population, minLevel)
VALUES ('Tutorial Town', 'Lowlands', 25, 1);

INSERT
INTO Village(name, region, population, minLevel)
VALUES ('Farms', 'Lowlands', 40, 5);

INSERT
INTO Village(name, region, population, minLevel)
VALUES ('Aria Falls', 'Wicked Forest', 20, 20);

INSERT
INTO Village(name, region, population, minLevel)
VALUES ('Shipton', 'Beach', 50, 30);

INSERT
INTO Village(name, region, population, minLevel)
VALUES ('Frostford', 'Mount Veritas', 25, 40);

INSERT
INTO PetAbility(species, ability)
VALUES ('Cat', 'Heal');

INSERT
INTO PetAbility(species, ability)
VALUES ('Dog', 'Bite');

INSERT
INTO PetAbility(species, ability)
VALUES ('Snake', 'Stun');

INSERT
INTO PetAbility(species, ability)
VALUES ('Bird', 'Fly');

INSERT
INTO PetAbility(species, ability)
VALUES ('Horse', 'Gallop');

INSERT
INTO PetSpecies(name, species)
VALUES ('Bob', 'Cat');

INSERT
INTO PetSpecies(name, species)
VALUES ('Larry', 'Dog');

INSERT
INTO PetSpecies(name, species)
VALUES ('Tabby', 'Cat');

INSERT
INTO PetSpecies(name, species)
VALUES ('Edwin', 'Bird');

INSERT
INTO PetSpecies(name, species)
VALUES ('Stacy', 'Horse');

INSERT
INTO PlayableCharacter(username, class, charLevel, health, energy, attack, defense, speed, pet)
VALUES ('Jay', 'Warrior', 5, 400, 100, 30, 15, 10, 'Bob');

INSERT
INTO PlayableCharacter(username, class, charLevel, health, energy, attack, defense, speed, pet)
VALUES ('Elle', 'Mage', 10, 1200, 110, 40, 25, 15, 'Larry');

INSERT
INTO PlayableCharacter(username, class, charLevel, health, energy, attack, defense, speed, pet)
VALUES ('Simon', 'Archer', 20, 1000, 150, 80, 50, 25, 'Tabby');

INSERT
INTO PlayableCharacter(username, class, charLevel, health, energy, attack, defense, speed, pet)
VALUES ('Alice', 'Warrior', 30, 2000, 270, 100, 80, 30, 'Edwin');

INSERT
INTO PlayableCharacter(username, class, charLevel, health, energy, attack, defense, speed, pet)
VALUES ('Steven', 'Assassin', 40, 3000, 370, 150, 110, 50, 'Stacy');

INSERT
INTO PlayableCharacter(username, class, charLevel, health, energy, attack, defense, speed, pet)
VALUES ('Felix', 'Scout', 15, 350, 100, 40, 20, 30, NULL);

INSERT
INTO PlayableCharacter(username, class, charLevel, health, energy, attack, defense, speed, pet)
VALUES ('Edward', 'Assassin', 25, 2200, 250, 95, 20, 30, NULL);

INSERT
INTO PlayableCharacter(username, class, charLevel, health, energy, attack, defense, speed, pet)
VALUES ('Lockhart', 'Mage', 77, 3400, 850, 150, 125, 50, NULL);

INSERT
INTO PlayableCharacter(username, class, charLevel, health, energy, attack, defense, speed, pet)
VALUES ('Keanu', 'Warrior', 50, 3000, 120, 180, 150, 35, NULL);

INSERT
INTO PlayableCharacter(username, class, charLevel, health, energy, attack, defense, speed, pet)
VALUES ('Kate', 'Archer', 80, 3600, 150, 400, 240, 60, NULL);

INSERT
INTO PlayableCharacter(username, class, charLevel, health, energy, attack, defense, speed, pet)
VALUES ('Jerry', 'Scout', 30, 900, 130, 90, 40, 50, NULL);

INSERT
INTO EquipmentType(type, affectedStat)
VALUES ('Sword', 'Attack');

INSERT
INTO EquipmentType(type, affectedStat)
VALUES ('Polearm', 'Attack');

INSERT
INTO EquipmentType(type, affectedStat)
VALUES ('Armour', 'Defense');

INSERT
INTO EquipmentType(type, affectedStat)
VALUES ('Staff', 'Attack');

INSERT
INTO EquipmentType(type, affectedStat)
VALUES ('Boots', 'Speed');

INSERT
INTO EquipmentType(type, affectedStat)
VALUES ('Helmet', 'Health');

INSERT
INTO EquipmentType(type, affectedStat)
VALUES ('Bow', 'Attack');

INSERT
INTO EquipmentType(type, affectedStat)
VALUES ('Cloak', 'Speed');

INSERT
INTO EquipmentType(type, affectedStat)
VALUES ('Spell', 'Energy');

INSERT
INTO EquipmentName(name, rarity, type)
VALUES ('Light Bow', 'Uncommon', 'Bow');

INSERT
INTO EquipmentName(name, rarity, type)
VALUES ('Shadow Cloak', 'Uncommon', 'Cloak');

INSERT
INTO EquipmentName(name, rarity, type)
VALUES ('Ritual Grail', 'Rare', 'Spell');

INSERT
INTO EquipmentName(name, rarity, type)
VALUES ('Singed Wand', 'Rare', 'Staff');

INSERT
INTO EquipmentName(name, rarity, type)
VALUES ('Soulless Sabre', 'Epic', 'Sword');

INSERT
INTO EquipmentName(name, rarity, type)
VALUES ('Short Sword', 'Common', 'Sword');

INSERT
INTO EquipmentName(name, rarity, type)
VALUES ('Chainmail', 'Common', 'Armour');

INSERT
INTO EquipmentName(name, rarity, type)
VALUES ('Demonic Staff', 'Rare', 'Staff');

INSERT
INTO EquipmentName(name, rarity, type)
VALUES ('Magic Boots', 'Common', 'Boots');

INSERT
INTO EquipmentName(name, rarity, type)
VALUES ('Frost Glaive', 'Epic', 'Polearm');

INSERT
INTO Sells(village, equipment, price)
VALUES ('Tutorial Town', 'Short Sword', 100);

INSERT
INTO Sells(village, equipment, price)
VALUES ('Farms', 'Chainmail', 250);

INSERT
INTO Sells(village, equipment, price)
VALUES ('Aria Falls', 'Demonic Staff', 800);

INSERT
INTO Sells(village, equipment, price)
VALUES ('Shipton', 'Magic Boots', 500);

INSERT
INTO Sells(village, equipment, price)
VALUES ('Frostford', 'Frost Glaive', 900);

INSERT
INTO EquipmentUser(name, usedBy)
VALUES ('Short Sword', NULL);

INSERT
INTO EquipmentUser(name, usedBy)
VALUES ('Chainmail', 'Jay');

INSERT
INTO EquipmentUser(name, usedBy)
VALUES ('Demonic Staff', 'Simon');

INSERT
INTO EquipmentUser(name, usedBy)
VALUES ('Magic Boots', NULL);

INSERT
INTO EquipmentUser(name, usedBy)
VALUES ('Frost Glaive', 'Alice');

INSERT
INTO EquipmentStatBoost(name, statBoost)
VALUES ('Light Bow', 12);

INSERT
INTO EquipmentStatBoost(name, statBoost)
VALUES ('Shadow Cloak', 15);

INSERT
INTO EquipmentStatBoost(name, statBoost)
VALUES ('Ritual Grail', 50);

INSERT
INTO EquipmentStatBoost(name, statBoost)
VALUES ('Singed Wand', 20);

INSERT
INTO EquipmentStatBoost(name, statBoost)
VALUES ('Soulless Sabre', 45);

INSERT
INTO EquipmentStatBoost(name, statBoost)
VALUES ('Short Sword', 5);

INSERT
INTO EquipmentStatBoost(name, statBoost)
VALUES ('Chainmail', 10);

INSERT
INTO EquipmentStatBoost(name, statBoost)
VALUES ('Demonic Staff', 40);

INSERT
INTO EquipmentStatBoost(name, statBoost)
VALUES ('Magic Boots', 5);

INSERT
INTO EquipmentStatBoost(name, statBoost)
VALUES ('Frost Glaive', 75);

INSERT
INTO DungeonName(name, boss, difficulty)
VALUES ('The Abandoned Farm', 'The Bull', 1);

INSERT
INTO DungeonName(name, boss, difficulty)
VALUES ('Lair of the Perished Mountain', 'The Frost Dragon', 4);

INSERT
INTO DungeonName(name, boss, difficulty)
VALUES ('The Raging Catacombs', 'Skulls of Fear', 3);

INSERT
INTO DungeonName(name, boss, difficulty)
VALUES ('The Eternal Cells', 'The Prison Guard', 3);

INSERT
INTO DungeonName(name, boss, difficulty)
VALUES ('The Bleak Tunnels', 'The Tree of Evil', 2);

INSERT
INTO DungeonName(name, boss, difficulty)
VALUES ('Dimension of Paranoia', 'Transcended Nightmare', 10);

INSERT
INTO Contains(equipment, dungeon)
VALUES ('Light Bow', 'The Abandoned Farm');

INSERT
INTO Contains(equipment, dungeon)
VALUES ('Shadow Cloak', 'Lair of the Perished Mountain');

INSERT
INTO Contains(equipment, dungeon)
VALUES ('Ritual Grail', 'The Raging Catacombs');

INSERT
INTO Contains(equipment, dungeon)
VALUES ('Singed Wand', 'The Eternal Cells');

INSERT
INTO Contains(equipment, dungeon)
VALUES ('Soulless Sabre', 'The Bleak Tunnels');

INSERT
INTO DungeonMinLevelToDifficulty(minLevel, difficulty)
VALUES (5, 1);

INSERT
INTO DungeonMinLevelToDifficulty(minLevel, difficulty)
VALUES (10, 1);

INSERT
INTO DungeonMinLevelToDifficulty(minLevel, difficulty)
VALUES (20, 2);

INSERT
INTO DungeonMinLevelToDifficulty(minLevel, difficulty)
VALUES (30, 3);

INSERT
INTO DungeonMinLevelToDifficulty(minLevel, difficulty)
VALUES (40, 4);

INSERT
INTO DungeonMinLevelToDifficulty(minLevel, difficulty)
VALUES (50, 5);

INSERT
INTO DungeonMinLevelToDifficulty(minLevel, difficulty)
VALUES (65, 6);

INSERT
INTO DungeonMinLevelToDifficulty(minLevel, difficulty)
VALUES (75, 7);

INSERT
INTO DungeonMinLevelToDifficulty(minLevel, difficulty)
VALUES (90, 8);

INSERT
INTO DungeonMinLevelToDifficulty(minLevel, difficulty)
VALUES (95, 9);

INSERT
INTO DungeonMinLevelToDifficulty(minLevel, difficulty)
VALUES (100, 10);

INSERT
INTO DungeonMinLevel(name, minLevel)
VALUES ('The Abandoned Farm', 5);

INSERT
INTO DungeonMinLevel(name, minLevel)
VALUES ('Lair of the Perished Mountain', 40);

INSERT
INTO DungeonMinLevel(name, minLevel)
VALUES ('The Raging Catacombs', 30);

INSERT
INTO DungeonMinLevel(name, minLevel)
VALUES ('The Eternal Cells', 30);

INSERT
INTO DungeonMinLevel(name, minLevel)
VALUES ('The Bleak Tunnels', 20);

INSERT
INTO DungeonMinLevel(name, minLevel)
VALUES ('Dimension of Paranoia', 100);

INSERT
INTO DungeonRegion(name, region)
VALUES ('The Abandoned Farm', 'Lowlands');

INSERT
INTO DungeonRegion(name, region)
VALUES ('Lair of the Perished Mountain', 'Mount Veritas');

INSERT
INTO DungeonRegion(name, region)
VALUES ('The Raging Catacombs', 'Beach');

INSERT
INTO DungeonRegion(name, region)
VALUES ('The Eternal Cells', 'Beach');

INSERT
INTO DungeonRegion(name, region)
VALUES ('The Bleak Tunnels', 'Wicked Forest');

INSERT
INTO DungeonRegion(name, region)
VALUES ('Dimension of Paranoia', 'The Void');

INSERT
INTO NPC(name, title, village)
VALUES ('Gerald', 'Leader', 'Tutorial Town');

INSERT
INTO NPC(name, title, village)
VALUES ('Franky', 'Blacksmith', 'Tutorial Town');

INSERT
INTO NPC(name, title, village)
VALUES ('Gordon', 'Head Chef', 'Tutorial Town');

INSERT
INTO NPC(name, title, village)
VALUES ('Sarah', 'Combat Teacher', 'Tutorial Town');

INSERT
INTO NPC(name, title, village)
VALUES ('Rachel', 'Shopkeeper', 'Tutorial Town');

INSERT
INTO NPC(name, title, village)
VALUES ('Lily', 'Musician', 'Tutorial Town');

INSERT
INTO NPC(name, title, village)
VALUES ('Lisa', 'Librarian', 'Tutorial Town');

INSERT
INTO NPC(name, title, village)
VALUES ('Severus', 'Potion Master', 'Tutorial Town');

INSERT
INTO NPC(name, title, village)
VALUES ('Archibald', 'Forest Elf Leader', 'Aria Falls');

INSERT
INTO NPC(name, title, village)
VALUES ('Thornald', 'Forest Elf Deputy', 'Aria Falls');

INSERT
INTO NPC(name, title, village)
VALUES ('Fletchald', 'Forest Elf Seeker', 'Aria Falls');

INSERT
INTO NPC(name, title, village)
VALUES ('Clerald', 'Forest Elf Healer', 'Aria Falls');

INSERT
INTO NPC(name, title, village)
VALUES ('Levius', 'Forest Fairy', 'Aria Falls');

INSERT
INTO NPC(name, title, village)
VALUES ('Petra', 'Farmer', 'Farms');

INSERT
INTO NPC(name, title, village)
VALUES ('Rob', 'Animal Keeper', 'Farms');

INSERT
INTO NPC(name, title, village)
VALUES ('Harold', 'Farmer', 'Farms');

INSERT
INTO NPC(name, title, village)
VALUES ('Maurelle', 'Shipwright Head', 'Shipton');

INSERT
INTO NPC(name, title, village)
VALUES ('Ichiko', 'Shipwright', 'Shipton');

INSERT
INTO NPC(name, title, village)
VALUES ('Reese', 'Mechanic', 'Shipton');

INSERT
INTO NPC(name, title, village)
VALUES ('Pauline', 'Shipwright', 'Shipton');

INSERT
INTO NPC(name, title, village)
VALUES ('Teddy', 'Shiphand', 'Shipton');

INSERT
INTO NPC(name, title, village)
VALUES ('Angelica', 'Messenger', 'Shipton');

INSERT
INTO NPC(name, title, village)
VALUES ('Chad', 'Apprentice', 'Shipton');

INSERT
INTO NPC(name, title, village)
VALUES ('Sampson', 'Adventurer', 'Frostford');

INSERT
INTO NPC(name, title, village)
VALUES ('Joyce', 'Ice Climber', 'Frostford');

INSERT
INTO NPC(name, title, village)
VALUES ('Erin', 'Medic', 'Frostford');

INSERT
INTO NPC(name, title, village)
VALUES ('Wrysley', 'Leader', 'Frostford');

INSERT
INTO NPC(name, title, village)
VALUES ('Vander', 'Guardian', 'Frostford');

INSERT
INTO NPC(name, title, village)
VALUES ('Rue', 'Cook', 'Frostford');

INSERT
INTO Interacts(NPC, playableCharacter)
VALUES ('Gerald', 'Jay');

INSERT
INTO Interacts(NPC, playableCharacter)
VALUES ('Archibald', 'Elle');

INSERT
INTO Interacts(NPC, playableCharacter)
VALUES ('Petra', 'Steven');

INSERT
INTO Interacts(NPC, playableCharacter)
VALUES ('Maurelle', 'Lockhart');

INSERT
INTO Interacts(NPC, playableCharacter)
VALUES ('Sampson', 'Alice');

INSERT
INTO Quest(title, difficulty, reward, length, minLevel)
VALUES ('First Steps', 1, 100, 1, 1);

INSERT
INTO Quest(title, difficulty, reward, length, minLevel)
VALUES ('Grasping the Basics', 1, 350, 3, 2);

INSERT
INTO Quest(title, difficulty, reward, length, minLevel)
VALUES ('Too Many Weeds', 2, '600', 2, 5);

INSERT
INTO Quest(title, difficulty, reward, length, minLevel)
VALUES ('Stop the Landslide!', 2, 500, 1, 10);

INSERT
INTO Quest(title, difficulty, reward, length, minLevel)
VALUES ('Forest Restoration', 3, 800, 3, 20);

INSERT
INTO Quest(title, difficulty, reward, length, minLevel)
VALUES ('Operation Anti-Invasion', 3, 1500, 5, 25);

INSERT
INTO Quest(title, difficulty, reward, length, minLevel)
VALUES ('Security Checkup', 2, 700, 2, 25);

INSERT
INTO Quest(title, difficulty, reward, length, minLevel)
VALUES ('Collect Clams', 4, 1500, 2, 30);

INSERT
INTO Quest(title, difficulty, reward, length, minLevel)
VALUES ('A Perilous Journey', 5, 2000, 4, 40);

INSERT
INTO Quest(title, difficulty, reward, length, minLevel)
VALUES ('Disease Overhaul', 6, 8000, 5, 50);

INSERT
INTO Quest(title, difficulty, reward, length, minLevel)
VALUES ('Slippery Hike', 5, 3500, 1, 50);

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('First Steps', 'Gerald', 'Jay');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('First Steps', 'Gerald', 'Elle');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('First Steps', 'Gerald', 'Simon');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('First Steps', 'Gerald', 'Alice');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('First Steps', 'Gerald', 'Lockhart');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('First Steps', 'Gerald', 'Kate');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('First Steps', 'Gerald', 'Edward');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('First Steps', 'Gerald', 'Felix');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Grasping the Basics', NULL, 'Lockhart');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Grasping the Basics', NULL, 'Kate');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Too Many Weeds', 'Petra', 'Jay');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Too Many Weeds', 'Petra', 'Simon');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Too Many Weeds', 'Petra', 'Felix');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Too Many Weeds', 'Petra', 'Keanu');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Too Many Weeds', 'Petra', 'Elle');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Too Many Weeds', 'Petra', 'Kate');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Too Many Weeds', 'Petra', 'Jerry');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Too Many Weeds', 'Petra', 'Lockhart');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Stop the Landslide!', NULL, 'Lockhart');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Stop the Landslide!', NULL, 'Kate');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Forest Restoration', 'Archibald', 'Jay');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Forest Restoration', 'Archibald', 'Elle');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Forest Restoration', 'Archibald', 'Steven');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Forest Restoration', 'Archibald', 'Keanu');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Forest Restoration', 'Archibald', 'Felix');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Forest Restoration', 'Archibald', 'Lockhart');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Forest Restoration', 'Archibald', 'Kate');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Operation Anti-Invasion', 'Fletchald', 'Lockhart');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Operation Anti-Invasion', 'Fletchald', 'Kate');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Security Checkup', 'Franky', 'Lockhart');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Security Checkup', 'Franky', 'Kate');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Collect Clams', 'Maurelle', 'Jay');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Collect Clams', 'Maurelle', 'Edward');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Collect Clams', 'Maurelle', 'Steven');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Collect Clams', 'Maurelle', 'Elle');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Collect Clams', 'Maurelle', 'Kate');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Collect Clams', 'Maurelle', 'Lockhart');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Collect Clams', 'Maurelle', 'Alice');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('A Perilous Journey', 'Sampson', 'Jay');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('A Perilous Journey', 'Sampson', 'Elle');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('A Perilous Journey', 'Sampson', 'Steven');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('A Perilous Journey', 'Sampson', 'Lockhart');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('A Perilous Journey', 'Sampson', 'Alice');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('A Perilous Journey', 'Sampson', 'Kate');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Disease Overhaul', 'Erin', 'Lockhart');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Disease Overhaul', 'Erin', 'Kate');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Slippery Hike', 'Joyce', 'Jay');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Slippery Hike', 'Joyce', 'Elle');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Slippery Hike', 'Joyce', 'Lockhart');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Slippery Hike', 'Joyce', 'Edward');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Slippery Hike', 'Joyce', 'Alice');

INSERT
INTO WorksOn(quest, NPC, playableCharacter)
VALUES ('Slippery Hike', 'Joyce', 'Kate');

INSERT
INTO PetOwner(name, owner)
VALUES ('Bob', 'Jay');

INSERT
INTO PetOwner(name, owner)
VALUES ('Larry', 'Elle');

INSERT
INTO PetOwner(name, owner)
VALUES ('Tabby', 'Simon');

INSERT
INTO PetOwner(name, owner)
VALUES ('Edwin', 'Alice');

INSERT
INTO PetOwner(name, owner)
VALUES ('Stacy', 'Steven');

INSERT
INTO PetLevel(species, abilityCooldown, pLevel)
VALUES ('Cat', 8, 3);

INSERT
INTO PetLevel(species, abilityCooldown, pLevel)
VALUES ('Dog', 3, 8);

INSERT
INTO PetLevel(species, abilityCooldown, pLevel)
VALUES ('Cat', 6, 5);

INSERT
INTO PetLevel(species, abilityCooldown, pLevel)
VALUES ('Bird', 10, 6);

INSERT
INTO PetLevel(species, abilityCooldown, pLevel)
VALUES ('Dog', 5, 6);

INSERT
INTO Monster(name, type, monsLevel, health, attack, defense, defends)
VALUES ('Timid Zombie', 'Undead', 1, 50, 5, 0, NULL);

INSERT
INTO Monster(name, type, monsLevel, health, attack, defense, defends)
VALUES ('Clam', 'Water', 20, 800, 30, 10, NULL);

INSERT
INTO Monster(name, type, monsLevel, health, attack, defense, defends)
VALUES ('Tree Sprite', 'Earth', 5, 300, 10, 2, 'The Bleak Tunnels');

INSERT
INTO Monster(name, type, monsLevel, health, attack, defense, defends)
VALUES ('Mountain Goat', 'Ice', 30, 1700, 50, 30, NULL);

INSERT
INTO Monster(name, type, monsLevel, health, attack, defense, defends)
VALUES ('Clay Dummy', 'Earth', 20, 1200, 40, 100, 'The Raging Catacombs');

INSERT
INTO Monster(name, type, monsLevel, health, attack, defense, defends)
VALUES ('Angry Chicken', 'Normal', 3, 100, 8, 5, 'The Abandoned Farm');

INSERT
INTO Monster(name, type, monsLevel, health, attack, defense, defends)
VALUES ('Grumpy Sheep', 'Normal', 5, 250, 5, 15, 'The Abandoned Farm');

INSERT
INTO Monster(name, type, monsLevel, health, attack, defense, defends)
VALUES ('The Bull', 'Normal', 10, 900, 20, 10, 'The Abandoned Farm');

INSERT
INTO Monster(name, type, monsLevel, health, attack, defense, defends)
VALUES ('Skulls of Fear', 'Undead', 40, 2500, 125, 180, 'The Raging Catacombs');

INSERT
INTO Monster(name, type, monsLevel, health, attack, defense, defends)
VALUES ('The Prison Guard', 'Undead', 35, 2000, 5, 0, 'The Eternal Cells');

INSERT
INTO Monster(name, type, monsLevel, health, attack, defense, defends)
VALUES ('The Tree of Evil', 'Earth', 25, 1800, 100, 100, 'The Bleak Tunnels');

INSERT
INTO Monster(name, type, monsLevel, health, attack, defense, defends)
VALUES ('Enchanted Leaf Swarm', 'Earth', 15, 1100, 80, 30, 'The Bleak Tunnels');

INSERT
INTO Monster(name, type, monsLevel, health, attack, defense, defends)
VALUES ('The Frost Dragon', 'Ice', 75, 5000, 250, 400, 'Lair of the Perished Mountain');

INSERT
INTO Monster(name, type, monsLevel, health, attack, defense, defends)
VALUES ('Ice Witch', 'Ice', 60, 3500, 200, 200, 'Lair of the Perished Mountain');

INSERT
INTO Monster(name, type, monsLevel, health, attack, defense, defends)
VALUES ('Sleepy Spider', 'Earth', 10, 700, 20, 5, 'The Bleak Tunnels');

INSERT
INTO Monster(name, type, monsLevel, health, attack, defense, defends)
VALUES ('Beach Crab', 'Water', 30, 1200, 50, 30, NULL);

INSERT
INTO Monster(name, type, monsLevel, health, attack, defense, defends)
VALUES ('Mountain Bear', 'Ice', 30, 1200, 50, 30, NULL);

INSERT
INTO Monster(name, type, monsLevel, health, attack, defense, defends)
VALUES ('Transcended Nightmare', 'Spirit', 100, 75000, 900, 400, 'Dimension of Paranoia');

INSERT
INTO Fights(playableCharacter, monster)
VALUES ('Jay', 'Timid Zombie');

INSERT
INTO Fights(playableCharacter, monster)
VALUES ('Simon', 'Clam');

INSERT
INTO Fights(playableCharacter, monster)
VALUES ('Elle', 'Tree Sprite');

INSERT
INTO Fights(playableCharacter, monster)
VALUES ('Alice', 'Mountain Goat');

INSERT
INTO Fights(playableCharacter, monster)
VALUES ('Steven', 'Clay Dummy');

INSERT
INTO Boss(name, ability)
VALUES ('The Bull', 'Unstoppable Charge');

INSERT
INTO Boss(name, ability)
VALUES ('Clam', 'Water Gun');

INSERT
INTO Boss(name, ability)
VALUES ('Skulls of Fear', 'Death Bite');

INSERT
INTO Boss(name, ability)
VALUES ('The Prison Guard', 'Bat Strike');

INSERT
INTO Boss(name, ability)
VALUES ('The Tree of Evil', 'Roots of Doom');

INSERT
INTO Boss(name, ability)
VALUES ('The Frost Dragon', 'Frozen Roar');

INSERT
INTO Boss(name, ability)
VALUES ('Tree Sprite', 'Vine Whip');

INSERT
INTO Boss(name, ability)
VALUES ('Transcended Nightmare', 'Doomsday Void');

INSERT
INTO Neutral(name, triggeredBy)
VALUES ('Sleepy Spider', 'Loud noise');

INSERT
INTO Neutral(name, triggeredBy)
VALUES ('Timid Zombie', 'Proximity');

INSERT
INTO Neutral(name, triggeredBy)
VALUES ('Clay Dummy', 'Proximity');

INSERT
INTO Neutral(name, triggeredBy)
VALUES ('Beach Crab', 'Damage');

INSERT
INTO Neutral(name, triggeredBy)
VALUES ('Mountain Bear', 'Damage');