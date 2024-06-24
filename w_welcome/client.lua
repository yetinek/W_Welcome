
exports('OpenWelcomeTest', function()
    ESX.TriggerServerCallback('w_welcome:CheckList', function(CallbackData) 
        if not CallbackData then
            SendNUIMessage({
                action = 'Open',
                questions = GetRandomQuestions(Config.Questions)
            })
            SetNuiFocus(true, true)
        end
    end)
end)

RegisterNUICallback('SendAnswers', function(data)
    TriggerServerEvent('w_welcome:CheckAnswers', data.answers)
    SetNuiFocus(false, false)
end)

GetRandomQuestions = function(table)
    local selectedIndexes = {}
    local resultTable = {}
    for i = 1, Config.QuestionsAmount do
        local randomIndex
        repeat
            Wait(10)
            randomIndex = math.random(1, #table)
        until not selectedIndexes[randomIndex]
        selectedIndexes[randomIndex] = true
        local selectedTable = table[randomIndex]
        selectedTable.index = randomIndex
        resultTable[#resultTable+1] = selectedTable
    end
    return resultTable
end