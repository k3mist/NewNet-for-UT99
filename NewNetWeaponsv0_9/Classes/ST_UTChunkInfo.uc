// ===============================================================
// Stats.ST_UTChunkInfo: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_UTChunkInfo extends Info;

var Actor Victim[8];
var int HitCount;
var int ChunkCount;
var int zzNN_ProjIndex;

var ST_Mutator STM;

function AddChunk(ST_UTChunk Chunk)
{
	if (Chunk == None)
		return;				// If it for some reason failed to spawn.
	Chunk.Chunkie = Self;
	Chunk.ChunkIndex = ChunkCount++;
	if (STM != None)
		STM.PlayerFire(Pawn(Owner), 14);	// Register that this player has made a new flak chunk.
}

function HitSomething(ST_UTChunk Chunk, Actor Other)
{
	local Actor A;
	local int x;

	HitCount++;
	Victim[Chunk.ChunkIndex] = Other;

	if (STM != None)
		STM.PlayerHit(Pawn(Owner), 14, False);	// 14 = Flak Chunk

	if (HitCount == ChunkCount)
	{
		Destroy();			// Not really destroyed immediately, so we can do it this way :P
		if (ChunkCount != 8)
			return;			// Flak Slugs produce only 5 chunks.

		A = Victim[0];
		if (!A.IsA('Pawn'))
			return;			// Only give perfects for pawns (Not carcasses etc)

		for (x = 1; x < ChunkCount; x++)
			if (Victim[x] != A)
				return;
		// Whoa! Perfect man!
		if (STM != None)
			STM.PlayerSpecial(Pawn(Owner), 14);	// 15 = Flak Chunk
	}
}

function EndHit()
{
	if (STM != None)
		STM.PlayerClear();
}

// The chunks have a lifespan of 1.5-1.8 seconds, so this is sufficient.
defaultproperties {
	LifeSpan=2.0
}
