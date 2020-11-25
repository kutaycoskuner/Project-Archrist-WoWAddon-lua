
function (_, _, eventType, _, _, sourceName, _, _, _, destName, _, _, spellID, spellName)
    
    if (not UnitInParty(sourceName)) then return false end    
    
    if (spellID == 64843 and eventType == "SPELL_AURA_APPLIED") then
        -- Divine Hymn --        
        if (_raidCDs_priests == nil) then _raidCDs_priests = { } end        
        if (_raidCDs_priests[sourceName] == nil) then _raidCDs_priests[sourceName] = { } end
        
        _raidCDs_priests[sourceName]["D-Hymn"] = GetTime() + 180;        
        
    elseif (spellID == 740 and eventType == "SPELL_AURA_APPLIED") then
        -- Tranquility --
        if (_raidCDs_druids == nil) then _raidCDs_druids = { } end        
        if (_raidCDs_druids[sourceName] == nil) then _raidCDs_druids[sourceName] = { } end
        
        _raidCDs_druids[sourceName]["Tranq"] = GetTime() + 180;
        
    elseif(spellID == 97462 and eventType == "SPELL_CAST_SUCCESS") then
        -- Rallying Cry --
        if (_raidCDs_warriors == nil) then _raidCDs_warriors = { } end        
        if (_raidCDs_warriors[sourceName] == nil) then _raidCDs_warriors[sourceName] = { } end
        
        _raidCDs_warriors[sourceName]["R-Cry"] = GetTime() + 180;
        
    elseif(spellID == 51052 and eventType == "SPELL_CAST_SUCCESS") then
        -- Anti-Magic Zone
        if (_raidCDs_dks == nil) then _raidCDs_dks = { } end        
        if (_raidCDs_dks[sourceName] == nil) then _raidCDs_dks[sourceName] = { } end
        
        _raidCDs_dks[sourceName]["AMZ"] = GetTime() + 120;
        
    elseif(spellID == 172106 and eventType == "SPELL_CAST_SUCCESS") then
        -- Aspect of the Fox --
        if (_raidCDs_hunters == nil) then _raidCDs_hunters = { } end        
        if (_raidCDs_hunters[sourceName] == nil) then _raidCDs_hunters[sourceName] = { } end
        
        _raidCDs_hunters[sourceName]["Fox"] = GetTime() + 180;
        
    elseif(spellID == 159916 and eventType == "SPELL_CAST_SUCCESS") then
        -- Amplify Magic --
        if (_raidCDs_mages == nil) then _raidCDs_mages = { } end        
        if (_raidCDs_mages[sourceName] == nil) then _raidCDs_mages[sourceName] = { } end
        
        _raidCDs_mages[sourceName]["Amp-M"] = GetTime() + 120;       
        
    elseif(spellID == 31821 and eventType == "SPELL_CAST_SUCCESS") then
        -- Devotion Aura --
        if (_raidCDs_paladins == nil) then _raidCDs_paladins = { } end        
        if (_raidCDs_paladins[sourceName] == nil) then _raidCDs_paladins[sourceName] = { } end
        
        _raidCDs_paladins[sourceName]["Dev Aura"] = GetTime() + 180;  
        
    elseif(spellID == 108280 and eventType == "SPELL_CAST_SUCCESS") then
        -- Healing Tide --
        if (_raidCDs_shamans == nil) then _raidCDs_shamans = { } end        
        if (_raidCDs_shamans[sourceName] == nil) then _raidCDs_shamans[sourceName] = { } end
        
        _raidCDs_shamans[sourceName]["H-Tide"] = GetTime() + 180;  
        
    elseif(spellID == 62618 and eventType == "SPELL_CAST_SUCCESS") then
        -- Power Word: Barrier --
        if (_raidCDs_priests == nil) then _raidCDs_priests = { } end        
        if (_raidCDs_priests[sourceName] == nil) then _raidCDs_priests[sourceName] = { } end
        
        _raidCDs_priests[sourceName]["Barrier"] = GetTime() + 180;        
        
    elseif(spellID == 98008 and eventType == "SPELL_CAST_SUCCESS") then
        -- Spirit Link Totem --
        if (_raidCDs_shamans == nil) then _raidCDs_shamans = { } end        
        if (_raidCDs_shamans[sourceName] == nil) then _raidCDs_shamans[sourceName] = { } end
        
        _raidCDs_shamans[sourceName]["SLT"] = GetTime() + 180;      
        
    elseif(spellID == 76577 and eventType == "SPELL_CAST_SUCCESS") then
        -- Smoke Bomb --
        if (_raidCDs_rogues == nil) then _raidCDs_rogues = { } end        
        if (_raidCDs_rogues[sourceName] == nil) then _raidCDs_rogues[sourceName] = { } end
        
        _raidCDs_rogues[sourceName]["S-Bomb"] = GetTime() + 180;      
        
    elseif(spellID == 115310 and eventType == "SPELL_CAST_SUCCESS") then
        -- Revival --
        if (_raidCDs_monks == nil) then _raidCDs_monks = { } end        
        if (_raidCDs_monks[sourceName] == nil) then _raidCDs_monks[sourceName] = { } end
        
        _raidCDs_monks[sourceName]["Revival"] = GetTime() + 180;                         
        
    elseif(spellID == 15286 and eventType == "SPELL_CAST_SUCCESS") then
        -- Vampiric Embrace --
        if (_raidCDs_priests == nil) then _raidCDs_priests = { } end        
        if (_raidCDs_priests[sourceName] == nil) then _raidCDs_priests[sourceName] = { } end
        
        _raidCDs_priests[sourceName]["Vamp-E"] = GetTime() + 180;   
        
    end      
    
end

-- ==== SpellIDS
-- 

