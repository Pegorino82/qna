import consumer from './consumer';


consumer.subscriptions.create('QuestionsChannel', {
    connected() {
        console.log('QuestionsChannel connected');
        this.perform('follow')
    },

    disconnected() {
        console.log('QuestionsChannel disconnected');
    },

    received(data) {
        document.querySelector('.question-items')
            .insertAdjacentHTML('afterbegin', data)
    }
})
