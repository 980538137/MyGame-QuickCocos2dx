
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    local node = cc.CSLoader:createNode("MainScene.csb")
    -- local node = ccs.GUIReader:getInstance():widgetFromBinaryFile("MainScene.csb")
    local s = cc.Director:getInstance():getWinSize()
    node:setPosition(s.width/2,s.height/2)
    node:setScale(0.57)
    node:setAnchorPoint(0.5,0.5)
    self:addChild(node)

    local function touchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.began then

        elseif eventType == ccui.TouchEventType.moved then

        elseif eventType == ccui.TouchEventType.ended then
            printf("Touch Down")

            function onRequestFinished(event)
                local ok = (event.name == "completed")
                local request = event.request

                if not ok then
                    --请求失败，显示错误代码和错误信息
                    print(request:getErrorCode(), request:getErrorMessage())
                    return
                end

                local code = request:getResponseStatusCode()
                if code ~= 200 then
                    -- 请求结束，但没有返回 200 响应代码
                    print("failed"..code)
                    return
                end

                --请求成功
                local response = request:getResponseString()
                print(response)
            end
            --创建一个链接，
            local url = "http://182.92.237.220:8080/dyncfg?channelId=101&ver=1.3.3"
            local request = network.createHTTPRequest(onRequestFinished, url, "GET")
            --开始请求
            request:start()
        elseif eventType == ccui.TouchEventType.canceled then

        end
    end
    local login = node:getChildByName("Login_Button")
    -- local login = ccui.Helper:seekWidgetByName(node, "EnterButton")
    login:addTouchEventListener(touchEvent)

    cc.ui.UILabel.new({
            UILabelType = 2, text = "Hello, World", size = 64})
        :align(display.CENTER, display.cx, display.cy)
        :addTo(self)

    -->>>>>>>>>>>>>>>>>>>>>>>>>> network
    -- SOCKET = require("src.app.network.socket").new("122.11.61.212",9080)
    -- SOCKET:connect()
    -->>>>>>>>>>>>>>>>>>>>>>>>>> pbc test
    import "protobuf-pbc.protobuf"
    --  Register
    local fullPath = cc.FileUtils:getInstance():fullPathForFilename("protobuf-pbc/addressbook.pb")
	-- local fullPath = cc.FileUtils:getInstance():fullPathForFilename("src/config.lua")
    printf("FullPath:%s",fullPath)
    -- -- local addr = cc.FileUtils:getInstance():getFileData("protobuf-pbc/addressbook.pb","rb",0)
    -- local addr = io.open(fullPath,"rb")
    local buffer = bsReadFile(fullPath)
    -- buffer = addr:read "*a"
    -- addr:close()
    protobuf.register(buffer)
    --or
    -- protobuf.register_file "/Users/liming/Documents/work/cocos2d-x-3.8/projects/MyGame/src/app/proto/addressbook.pb"
    
    
    local addressbook = {
        name = "Alice",
        id = 12345,
        phone = {
            { number = "1301234567" },
            { number = "87654321", type = "WORK" },
        }
    }
    local code = protobuf.encode("tutorial.Person", addressbook)
    local decode = protobuf.decode("tutorial.Person" , code)
    printf("Name:%s Id:%d",decode.name,decode.id)
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
