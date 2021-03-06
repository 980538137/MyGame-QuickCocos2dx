local UpdateLayer = class("UpdateLayer",function()
	return display.newScene("UpdateLayer")
end)

function UpdateLayer:ctor()
	-- local node = cc.CSLoader:createNode("UpdateScene.csb")
	local node =  cc.uiloader:load("UpdateScene.csb")
	local s = cc.Director:getInstance():getWinSize()
    node:setPosition(s.width/2,s.height/2)
    node:setScale(0.57)
    node:setAnchorPoint(0.5,0.5)
	self:addChild(node)

	--LoadingBar
	local updateProgress = node:getChildByName("UpdateProgress")
	-- local updateProgress = ccui.Helper:seekWidgetByName(node, "UpdateProgress")
	updateProgress:setPercent(50)

	local function touchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.began then

        elseif eventType == ccui.TouchEventType.moved then

        elseif eventType == ccui.TouchEventType.ended then
            printf("Touch Down")
 

            self:download()
            -- self:enterGame()
        elseif eventType == ccui.TouchEventType.canceled then

        end
    end
    local login = node:getChildByName("LoginButton")
    -- local login = ccui.Helper:seekWidgetByName(node, "EnterButton")
    login:addTouchEventListener(touchEvent)
end

function UpdateLayer:onEnter()
	printf("UpdateLayer onEnter")

end

function UpdateLayer:onExit()
	printf("UpdateLayer onExit")
end

function UpdateLayer:checkVersion()
    --从服务器检测版本号
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

        local cjson = require("cjson")
        local status, result = pcall(cjson.decode, response)
        if status then 
            print("data:"..result["IsNeedUpdate"])
            local IsNeedUpdate = result["IsNeedUpdate"]
            if IsNeedUpdate == 1 then --是否需要更新
                local IsAllUpdate = result["IsAllUpdate"]
                if IsAllUpdate  == 1 then  --是否整包更新
                    --进入下载页面
                else
                    --增量更新
                end
            else
                --直接进入游戏
            end
        end
    end
    -- local url = "http://182.92.237.220:8080/dyncfg?channelId=101&ver=1.3.3"
    local url = "http://127.0.0.1:8080/check_update?app_version=1&script_version=1.0.0&channel=test"
    local request = network.createHTTPRequest(onRequestFinished, url, "GET")
    --开始请求
    request:start()
end

function UpdateLayer:download()
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

        local path = "/Users/liming/Documents/src.zip"
        printf("Dwn Path:%s",path)
        local fp = io.open(path,"w")
        if fp then
            fp:write(response)
            fp:close()
        end
        
        
    end
    local url = "http://127.0.0.1:8080/download?filename=src.zip"
    local request = network.createHTTPRequest(onRequestFinished, url, "GET")
    --开始请求
    request:start()
end

function UpdateLayer:enterGame()
    cc.LuaLoadChunksFromZIP("app.zip")
    require("src")
    printf("finish")
    -- local scene = require("app.scenes.MainScene").new()
    -- display.replaceScene(scene)
    -- display.replaceScene(main,nil,nil,nil)
    -- display.replaceScene(scene, "fade", 0.5, cc.c3b(255, 0, 0))
    -- 创建一个新场景
    -- local nextScene = display.newScene("NextScene")
    -- 包装过渡效果
    -- local transition = display.wrapSceneWithTransition(scene, "fadeBL", 0.5)
    -- 切换到新场景
            
end


return UpdateLayer