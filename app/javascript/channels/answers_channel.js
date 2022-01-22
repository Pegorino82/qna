import JsonpTemplatePlugin from 'webpack/lib/web/JsonpTemplatePlugin';
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
        if (data.answer.author_id === gon.current_user_id) {
            return
        }
        if (!location.pathname.endsWith(data.answer.question_id)) {
            return
        }
        data.disabled_vote = data.answer.author_id === gon.current_user_id
        const answer = require('templates/answer.hbs')(data);
        console.log(answer);


        document.querySelector(`.answers`)
            .insertAdjacentHTML('beforeend', answer)

        const votesEvent = new Event('votesEvent')
        document.dispatchEvent(votesEvent)
    }
})
