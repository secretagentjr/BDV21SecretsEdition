// Special Thanks to BlueShadow, as i couldn't figure out how to get this to
// work with the already declared RandomSpawner class

class SS_ScriptedSpawner : RandomSpawner
{
    // Function to be Overridden.
	virtual name SS_GetActorToSpawn ()
	{
		return 'None';
	}

	bool SS_IsMonster(name clsname)
	{
		class<Actor> pclass = clsname;

		if(pclass == null)
		{
			return false;
		}

		return GetDefaultByType(pclass).bIsMonster;
	}

	override void BeginPlay()
	{
		Actor.BeginPlay();
		//Super.BeginPlay;
        
		name clsname = SS_GetActorToSpawn();
		bool nomonsters = sv_nomonsters || level.nomonsters;

		if(clsname != 'None' && (!nomonsters || !SS_IsMonster(clsname)))
		{
			// Handle replacement here so as to get the proper speed and flags for missiles
			class<Actor> cls = clsname;

			if(cls != null)
			{
				class<Actor> rep = GetReplacement(cls);

				if(rep != null)
				{
					cls = rep;
				}
			}

			if (cls != null)
			{
				Species = Name(cls);
				readonly<Actor> defmobj = GetDefaultByType(cls);
				Speed = defmobj.Speed;
				bMissile |= defmobj.bMissile;
				bSeekerMissile |= defmobj.bSeekerMissile;
				bSpectral |= defmobj.bSpectral;
			}
			else
			{
				A_Log(TEXTCOLOR_RED .. "Unknown item class ".. clsname .." to drop from a scripted spawner\n");
				Species = 'None';
			}
		}
	}
}