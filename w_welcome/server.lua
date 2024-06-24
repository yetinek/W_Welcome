
ESX.RegisterServerCallback('w_welcome:CheckList', function(source, cb)
    local playerId = source
    local hexId = GetPlayerIdentifier(playerId, 0) 
    local userFile = LoadResourceFile(GetCurrentResourceName(), 'user.json')
    local users = json.decode(userFile) or {}
    local complete = false
    local exists = false

    for _, user in ipairs(users) do
        if user.hexId == hexId then
            exists = true
            complete = user.complete 
            break
        end
    end

    if not exists then
        print('First join')
        table.insert(users, { hexId = hexId, complete = false })
        SaveResourceFile(GetCurrentResourceName(), 'user.json', json.encode(users, { indent = true }), -1)
    end

    cb(complete) 
end)

RegisterNetEvent("w_welcome:CheckAnswers")
AddEventHandler("w_welcome:CheckAnswers", function(answers)
    local playerId = source
    local correctCount = 0
    local incorrectCount = 0

    for index, question in ipairs(Config.Questions) do
        question.Index = index
    end
    for i = 2, #answers do 
        local questionIndex = answers[i][1] 
        local selectedAnswerIndex = answers[i][2]
        if questionIndex and selectedAnswerIndex ~= -1 then
            local question = Config.Questions[questionIndex]
            local correctAnswerIndex = nil
            for j, answer in ipairs(question.Answers) do
                if answer.correct then
                    correctAnswerIndex = j
                    break
                end
            end
            if correctAnswerIndex and selectedAnswerIndex == correctAnswerIndex then
                correctCount = correctCount + 1
            else
                incorrectCount = incorrectCount + 1
            end
        end
    end
    
    if incorrectCount > Config.MaxMisstakes then
        print("Gracz nie zdał testu i został wyrzucony z serwera pozdro")
        Wait(100)
        DropPlayer(playerId, "Nie zdałeś testu. Przekroczono limit błędów.")
    else
        local userHexId = GetPlayerIdentifier(playerId, 0)
        local file = LoadResourceFile(GetCurrentResourceName(), "user.json")

        if file then
            local userData = json.decode(file)
            for _, user in ipairs(userData) do
                if user.hexId == userHexId then
                    user.complete = true 
                    break
                end
            end
            SaveResourceFile(GetCurrentResourceName(), "user.json", json.encode(userData, { indent = true }), -1)
        end
    end
end)
