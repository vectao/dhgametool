-- Command line was: E:\github\dhgametool\scripts\fight\solo\loading.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local i18n = require("res.i18n")
local json = require("res.json")
local audio = require("res.audio")
local cfgmons = require("config.monster")
local herosdata = require("data.heros")
local memflag = false
ui.create = function(l_1_0)
  local layer = require("fight.base.loading").create()
  memflag = false
  local fx = require("common.helper")
  if fx.isLowMem() then
    memflag = true
    require("fight.base.loading").unloadUIBeforFight()
  end
  local resInfo = ui.getMapAndHeroIds2(l_1_0)
  local params = {mapId = resInfo.mapId, heroIds = resInfo.heroIds, pets = resInfo.pets, skins = resInfo.skins, heroList = resInfo.heroList}
  layer.startLoadingWithParams(params, function()
    replaceScene(require("fight.solo.video").create(video))
   end)
  return layer
end

ui.backToUI = function(l_2_0)
  local mapId, heroIds, pets, skins = ui.getMapAndHeroIds(l_2_0)
  local params = {mapId = mapId, heroIds = heroIds, pets = pets, skins = skins}
  require("fight.base.loading").unloadFightWithParams(params)
  if memflag == true then
    local layer = require("fight.base.uiloading").create()
    replaceScene(layer)
    layer.startLoading(mapId, heroIds, function()
      require("ui.solo.main").refreshFightData(video.data)
      replaceScene(require("ui.solo.main").create(video.from_layer))
      end)
  else
    require("ui.solo.main").refreshFightData(l_2_0.data)
    replaceScene(require("ui.solo.main").create(l_2_0.from_layer))
  end
end

ui.getMapAndHeroIds = function(l_3_0)
  local mapId, heroIds, pets = MAP_ID_ARENA, {}, {}
  local skins = {}
  for _,h in pairs(l_3_0.atk.camp) do
    if h.skin then
      skins[#skins + 1] = h.skin
    end
    heroIds[#heroIds + 1] = h.id
  end
  if l_3_0.atk and l_3_0.atk.pet then
    pets[#pets + 1] = l_3_0.atk.pet
  end
  for _,h in pairs(l_3_0.def.camp) do
    if h.skin then
      skins[#skins + 1] = h.skin
    end
    heroIds[#heroIds + 1] = h.id
  end
  return mapId, heroIds, pets, skins
end

ui.getMapAndHeroIds2 = function(l_4_0)
  local mapId, heroIds, pets = MAP_ID_ARENA, {}, {}
  local skins = {}
  local heroList = {}
  for _,h in pairs(l_4_0.atk.camp) do
    if h.skin then
      skins[#skins + 1] = h.skin
    end
    heroIds[#heroIds + 1] = h.id
    heroList[#heroList + 1] = h
  end
  if l_4_0.atk and l_4_0.atk.pet then
    pets[#pets + 1] = l_4_0.atk.pet
  end
  for _,h in pairs(l_4_0.def.camp) do
    if h.skin then
      skins[#skins + 1] = h.skin
    end
    if h.hid then
      h.hid = nil
    end
    heroIds[#heroIds + 1] = h.id
    heroList[#heroList + 1] = h
  end
  return {mapId = mapId, heroIds = heroIds, pets = pets, skins = skins, heroList = heroList}
end

return ui

