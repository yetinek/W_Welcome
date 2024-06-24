let currentQuestion = 0
let selectedAnswers = []
let Questions = [];
let timerInterval;

window.addEventListener("message", function(event) {
    switch (event.data.action) {
        case "Open":
            selectedAnswers = []
            Questions = []
            currentQuestion = 0
            Questions = event.data.questions
            $(".container").css("display", "flex")
            $(".timeContainer").hide()
            $(".questionContainer").html(`<div class="firstWelcome">
                <div class="title">Witaj!</div>
                <div class="desc">Aby uzyskać dostęp do serwera musisz przejść test wiedzy. <br>Jeśli jesteś gotów, aby rozpocząć test kliknij przycisk poniżej!</div>
            </div>`)
            break;
    }
})

const NextQuestion = (QuestionID) => {
    $(".timeContainer").show()
    let skipQuestion = false
    if(QuestionID != 0){
        if($(".answer").hasClass("selected")){
            selectedAnswers[QuestionID] = [Questions[QuestionID-1].index, Number($(".answer.selected").data("id"))+1]
        }else{
            skipQuestion = true
            selectedAnswers[QuestionID] = [Questions[QuestionID-1].index, -1]
        }
    }
    if(QuestionID == Questions.length){
        if (timerInterval) {
            clearInterval(timerInterval);
        }
        $.post(`https://w_welcome/SendAnswers`, JSON.stringify({
            answers: selectedAnswers
        }));
        $(".container").css("display", "none")
        return
    }
    if(($(".answer").hasClass("selected") && QuestionID != 0) || QuestionID == 0 || skipQuestion){
        currentQuestion += 1
        startTimer()
        $(".container > .content > .questionContainer").html(`
            <div class="question">Pytanie ${QuestionID + 1}: ${Questions[QuestionID].Question}</div>
            ${Questions[QuestionID].Answers.map((answer, index) => `<div class="answer" data-id="${index}" onclick="selectAnswer(this)">${answer.Label}</div>`).join('')}
        `)
    }
}

const startTimer = () => {
    if (timerInterval) {
        clearInterval(timerInterval);
    }
    let seconds = 20;
    const timerElement = $(".container > .header > .timeContainer > .time");

    function updateTimer() {
        timerElement.text(`${seconds}s`);

        if (seconds === 0) {
            clearInterval(timerInterval);
            NextQuestion(currentQuestion)
        } else {
            timerElement.css("color", seconds > 5 ? "#0B9908" : "#AD0303");

            if (seconds >= 0) {
                playSound();
            }

            seconds--;
        }
    }

    function playSound() {
        const tickerAudio = new Audio("sound/timer.wav");
        tickerAudio.volume = 0.4;
        tickerAudio.play();
    }

    timerInterval = setInterval(updateTimer, 1000);
}


const selectAnswer = (div) => {
    $('.answer').removeClass("selected")
    $(div).addClass("selected")
}