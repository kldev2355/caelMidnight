--[[	$Id: panels.lua 3536 2013-08-24 16:19:22Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.panels = caelUI.createModule("Panels")

local caelPanels = caelUI.panels
local pixelScale = caelUI.scale

local panels, n = {}, 1
local bgTexture = caelMedia.files.bgFile

-- Hard-coded layout for 3440x2160 (21:9 ultrawide).
-- These numbers are "UI units" that still go through pixelScale().
local LAYOUT_3440x2160 = {
	-- baseline margins
	marginBottom = 20,
	marginSide   = 30,

	-- main blocks
	chatW = 440,
	chatH = 140,

	combatW = 440,
	combatH = 160,

	minimap = 150,

	-- action/bar panels around the minimap
	barW = 190,
	barH = 64,

	-- datafeed bar
	dataW = 1500,
	dataH = 18,

	-- side action bar background
	sideW = 34,
	sideH = 420,

	-- edit box
	editW = 320,
	editH = 22,

	-- battlefield minimap panel
	bfmW = 260,
	bfmH = 170,
}

local function CreatePanel(name, x, y, width, height, point, rpoint, anchor, parent, strata)
	-- BackdropTemplate is important for modern clients (10.x/11.x/12.x) when using SetBackdrop.
	local f = CreateFrame("Frame", name, parent, "BackdropTemplate")
	panels[n] = f

	f:EnableMouse(false)
	f:SetFrameStrata(strata)
	f:SetSize(pixelScale(width), pixelScale(height))
	f:SetPoint(point, anchor, rpoint, pixelScale(x), pixelScale(y))
	f:SetBackdrop(caelMedia.backdropTable)
	f:SetBackdropColor(0, 0, 0, 0.33)
	f:SetBackdropBorderColor(0, 0, 0)
	f:Show()

	n = n + 1
	return f
end

caelPanels.createPanel = CreatePanel

-- == Panels (3440x2160 layout) ==

-- Chatframes: bottom-left
CreatePanel(
	"caelPanel1",
	LAYOUT_3440x2160.marginSide, LAYOUT_3440x2160.marginBottom,
	LAYOUT_3440x2160.chatW, LAYOUT_3440x2160.chatH,
	"BOTTOMLEFT", "BOTTOMLEFT",
	UIParent, UIParent,
	"BACKGROUND"
)

-- CombatLog: bottom-right
CreatePanel(
	"caelPanel2",
	-LAYOUT_3440x2160.marginSide, LAYOUT_3440x2160.marginBottom,
	LAYOUT_3440x2160.combatW, LAYOUT_3440x2160.combatH,
	"BOTTOMRIGHT", "BOTTOMRIGHT",
	UIParent, UIParent,
	"BACKGROUND"
)

-- Minimap: bottom-center
CreatePanel(
	"caelPanel3",
	0, LAYOUT_3440x2160.marginBottom,
	LAYOUT_3440x2160.minimap, LAYOUT_3440x2160.minimap,
	"BOTTOM", "BOTTOM",
	UIParent, UIParent,
	"MEDIUM"
)

-- TopLeftBar (left of minimap)
CreatePanel(
	"caelPanel4",
	-(LAYOUT_3440x2160.minimap / 2 + LAYOUT_3440x2160.barW / 2 + 18),
	LAYOUT_3440x2160.marginBottom + 80,
	LAYOUT_3440x2160.barW, LAYOUT_3440x2160.barH,
	"BOTTOM", "BOTTOM",
	UIParent, UIParent,
	"MEDIUM"
)

-- TopRightBar (right of minimap)
CreatePanel(
	"caelPanel5",
	(LAYOUT_3440x2160.minimap / 2 + LAYOUT_3440x2160.barW / 2 + 18),
	LAYOUT_3440x2160.marginBottom + 80,
	LAYOUT_3440x2160.barW, LAYOUT_3440x2160.barH,
	"BOTTOM", "BOTTOM",
	UIParent, UIParent,
	"MEDIUM"
)

-- BottomLeftBar
CreatePanel(
	"caelPanel6",
	-(LAYOUT_3440x2160.minimap / 2 + LAYOUT_3440x2160.barW / 2 + 18),
	LAYOUT_3440x2160.marginBottom,
	LAYOUT_3440x2160.barW, LAYOUT_3440x2160.barH,
	"BOTTOM", "BOTTOM",
	UIParent, UIParent,
	"MEDIUM"
)

-- BottomRightBar
CreatePanel(
	"caelPanel7",
	(LAYOUT_3440x2160.minimap / 2 + LAYOUT_3440x2160.barW / 2 + 18),
	LAYOUT_3440x2160.marginBottom,
	LAYOUT_3440x2160.barW, LAYOUT_3440x2160.barH,
	"BOTTOM", "BOTTOM",
	UIParent, UIParent,
	"MEDIUM"
)

-- DataFeeds bar: bottom-center, slightly above the edge
CreatePanel(
	"caelPanel8",
	0, 2,
	LAYOUT_3440x2160.dataW, LAYOUT_3440x2160.dataH,
	"BOTTOM", "BOTTOM",
	UIParent, UIParent,
	"BACKGROUND"
)

-- Side Action Bar background (right edge)
CreatePanel(
	"caelPanel9",
	-LAYOUT_3440x2160.marginSide, 0,
	LAYOUT_3440x2160.sideW, LAYOUT_3440x2160.sideH,
	"RIGHT", "RIGHT",
	UIParent, MultiBarLeft,
	"BACKGROUND"
)

-- ChatFrameEditBox (anchored to chat panel)
CreatePanel(
	"caelPanel10",
	0, 4,
	LAYOUT_3440x2160.editW, LAYOUT_3440x2160.editH,
	"BOTTOMLEFT", "TOPLEFT",
	caelPanel1, caelPanel1,
	"BACKGROUND"
)

-- Battlefield Minimap (top-right)
CreatePanel(
	"caelPanel11",
	-LAYOUT_3440x2160.marginSide, -LAYOUT_3440x2160.marginSide,
	LAYOUT_3440x2160.bfmW, LAYOUT_3440x2160.bfmH,
	"TOPRIGHT", "TOPRIGHT",
	UIParent, UIParent,
	"MEDIUM"
)

caelPanels:HookScript("OnEvent", function(self, event)
	if event == "PLAYER_LOGIN" then
		if NumerationFrame then
			CreatePanel("caelPanel12", LAYOUT_3440x2160.marginSide, 2, 210, 160, "BOTTOMLEFT", "BOTTOMLEFT", UIParent, NumerationFrame, "BACKGROUND")
			NumerationFrame:ClearAllPoints()
			NumerationFrame:SetPoint("TOPLEFT", caelPanel12, "TOPLEFT", pixelScale(3), pixelScale(-3))
		end

		if recThreatMeter then
			CreatePanel("caelPanel13", -LAYOUT_3440x2160.marginSide, 2, 210, 160, "BOTTOMRIGHT", "BOTTOMRIGHT", UIParent, recThreatMeter, "BACKGROUND")
			recThreatMeter:ClearAllPoints()
			recThreatMeter:SetPoint("TOPLEFT", caelPanel13, "TOPLEFT", pixelScale(3), pixelScale(-3))
		end

		for i = 1, 13 do
			local panel = panels[i]
			if panel then
				-- panel:GetWidth()/GetHeight() are already in scaled UI units (because we set scaled size).
				-- Don't pixelScale() again here, or gradients will be wrong on modern clients.
				local width = panel:GetWidth() - pixelScale(5)
				local height = panel:GetHeight() / 5

				local gradientTop = panel:CreateTexture(nil, "BORDER")
				gradientTop:SetTexture(bgTexture)
				gradientTop:SetSize(width, height)
				gradientTop:SetPoint("TOPLEFT", pixelScale(2.5), pixelScale(-2))
				gradientTop:SetGradientAlpha("VERTICAL", 0, 0, 0, 0, 0.84, 0.75, 0.65, 0.5)

				local gradientBottom = panel:CreateTexture(nil, "BORDER")
				gradientBottom:SetTexture(bgTexture)
				gradientBottom:SetSize(width, height)
				gradientBottom:SetPoint("BOTTOMLEFT", pixelScale(2.5), pixelScale(2))
				gradientBottom:SetGradientAlpha("VERTICAL", 0, 0, 0, 0.75, 0, 0, 0, 0)

				if i ~= 1 and i ~= 10 and i ~= 11 then
					RegisterStateDriver(panel, "visibility", "[petbattle] hide; show")
				end
			end
		end

	elseif event == "PET_BATTLE_OPENING_START" then
		caelPanel1:ClearAllPoints()
		caelPanel1:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", pixelScale(-15), pixelScale(LAYOUT_3440x2160.marginBottom))

	elseif event == "PET_BATTLE_OVER" then
		-- Fix invalid SetPoint signature from old file.
		caelPanel1:ClearAllPoints()
		caelPanel1:SetPoint(
			"BOTTOMLEFT", UIParent, "BOTTOMLEFT",
			pixelScale(LAYOUT_3440x2160.marginSide),
			pixelScale(LAYOUT_3440x2160.marginBottom)
		)
	end
end)

for _, event in next, {
	"PET_BATTLE_OPENING_START",
	"PET_BATTLE_OVER",
	"PLAYER_LOGIN",
} do
	caelPanels:RegisterEvent(event)
end

_G["caelPanels"] = panels
