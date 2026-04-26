local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- กันส่งซ้ำ
if getgenv().webhookSent then return end
getgenv().webhookSent = true

local player = Players.LocalPlayer
local mapName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
local time = os.date("%X")

local url = "https://discord.com/api/webhooks/1487385803645522071/BoGWNA1mXyvloY49pvBRG3SzM7z-cegNLR0v5-LTSdVZ2DrXJCFKn6bm4h0n9vMQrAkm"

local data = {
    ["username"] = "FIATX2 HUB",
    ["embeds"] = {{
        ["title"] = "╔═══════════════╗\n      FIATX2 HUB\n╚═══════════════╝",
        ["description"] =
            "```"..
            "\nชื่อผู้ใช้ : "..player.Name..
            "\nแมพที่เล่น: "..mapName..
            "\nเวลาที่เล่น: "..time..
            "\n```",
        ["image"] = {
            ["url"] = "https://cdn.discordapp.com/attachments/1471824119199830239/1492749751207067678/fec7215bd5f3cf20ab2aab9754e97c11.gif"
        },
        ["color"] = 16753920
    }}
}

local jsonData = HttpService:JSONEncode(data)

request({
    Url = url,
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json"
    },
    Body = jsonData
})
