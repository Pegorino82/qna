import consumer from './consumer';


consumer.subscriptions.create('AnswersChannel', {
    connected() {
        console.log('AnswersChannel connected');
        this.perform('follow', { question_id: gon.question_id })
    },

    disconnected() {
        console.log('AnswersChannel disconnected');
    },

    received(data) {
        console.log(JSON.stringify(data));
        console.log(gon.current_user_id);
        console.log(gon.question_id);
        if (data.author_id === gon.current_user_id) {
            return
        }
        if (!location.pathname.endsWith(gon.question_id)) {
            return
        }

        // document.querySelector(`.answers #answer-${data.id} .answer-body`)
        //     .textContent = data.body
    }
})
