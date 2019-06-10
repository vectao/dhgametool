-- Command line was: E:\github\dhgametool\scripts\ui\trial\rank.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local player = require("data.player")
local net = require("net.netClient")
local cfgwave = require("config.wavetrial")
local cfgmonster = require("config.monster")
local trial = require("data.trial")
ui.create = function()
  local layer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  local board = img.createLogin9Sprite(img.login.dialog)
  board:setPreferredSize(CCSize(660, 510))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY)
  layer:addChild(board)
  local titleRank = lbl.createFont1(26, i18n.global.trial_rank_title.string, ccc3(230, 208, 174))
  titleRank:setPosition(330, 481)
  board:addChild(titleRank, 1)
  local titleRankShade = lbl.createFont1(26, i18n.global.trial_rank_title.string, ccc3(89, 48, 27))
  titleRankShade:setPosition(330, 479)
  board:addChild(titleRankShade)
  local innerBg = img.createUI9Sprite(img.ui.hero_equip_lab_frame)
  innerBg:setPreferredSize(CCSize(600, 410))
  innerBg:setPosition(330, 240)
  board:addChild(innerBg)
  local btnCloseSprite = img.createUISprite(img.ui.close)
  local btnClose = SpineMenuItem:create(json.ui.button, btnCloseSprite)
  btnClose:setPosition(636, 484)
  local menuClose = CCMenu:createWithItem(btnClose)
  menuClose:setPosition(0, 0)
  board:addChild(menuClose)
  btnClose:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end)
  local createRankList = function(l_2_0)
    if not l_2_0 then
      local ranks = {}
    end
    local Height = 82 * #ranks + 6
    local scroll = CCScrollView:create()
    scroll:setDirection(kCCScrollViewDirectionVertical)
    scroll:setAnchorPoint(ccp(0, 0))
    scroll:setPosition(0, 2)
    scroll:setViewSize(CCSize(600, 405))
    scroll:setContentSize(CCSize(600, Height))
    scroll:setContentOffset(ccp(0, 405 - Height))
    innerBg:addChild(scroll)
    for i,v in ipairs(ranks) do
      tbl2string(ranks)
      local showBg = img.createUI9Sprite(img.ui.botton_fram_2)
      showBg:setPreferredSize(CCSize(577, 77))
      showBg:setAnchorPoint(ccp(0.5, 0))
      showBg:setPosition(300, Height - 6 - i * 79)
      scroll:getContainer():addChild(showBg)
      local rank = i
      local showRank = nil
      if rank <= 3 then
        showRank = img.createUISprite(img.ui.arena_rank_" .. ran)
      else
        showRank = lbl.createFont1(18, rank, ccc3(81, 39, 18))
      end
      showRank:setPosition(43, 39)
      showBg:addChild(showRank)
      local showHead = img.createPlayerHead(v.logo)
      showHead:setScale(0.65)
      showHead:setPosition(105, 40)
      showBg:addChild(showHead)
      local showLvBg = img.createUISprite(img.ui.main_lv_bg)
      showLvBg:setPosition(158, 39)
      showBg:addChild(showLvBg)
      local showLv = lbl.createFont1(14, v.lv)
      showLv:setPosition(showLvBg:getContentSize().width / 2, showLvBg:getContentSize().height / 2)
      showLvBg:addChild(showLv)
      local showName = lbl.createFontTTF(20, v.name, ccc3(81, 39, 18))
      showName:setAnchorPoint(ccp(0, 0.5))
      showName:setPosition(190, showBg:getContentSize().height / 2)
      showBg:addChild(showName)
      local titleLayer = lbl.createFont1(14, i18n.global.trial_rank_layer.string, ccc3(122, 83, 52))
      titleLayer:setPosition(523, 53)
      showBg:addChild(titleLayer)
      local showLayer = lbl.createFont1(22, v.stage, ccc3(156, 69, 45))
      showLayer:setPosition(523, 30)
      showBg:addChild(showLayer)
    end
   end
  addBackEvent(layer)
  layer.onAndroidBack = function()
    layer:removeFromParentAndCleanup(true)
   end
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
    local params = {}
    params.sid = player.sid
    addWaitNet()
    net:trial_rank(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if not l_1_0.rank then
        local ranks = {}
      end
      createRankList(ranks)
      end)
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_6_0)
    if l_6_0 == "enter" then
      onEnter()
    elseif l_6_0 == "exit" then
      onExit()
    end
   end)
  layer:registerScriptTouchHandler(function()
    return true
   end)
  layer:setTouchEnabled(true)
  board:setScale(0.5 * view.minScale)
  local anim_arr = CCArray:create()
  anim_arr:addObject(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  anim_arr:addObject(CCDelayTime:create(0.15))
  anim_arr:addObject(CCCallFunc:create(function()
   end))
  board:runAction(CCSequence:create(anim_arr))
  return layer
end

return ui

