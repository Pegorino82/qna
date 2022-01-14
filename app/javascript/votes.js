document.addEventListener('turbolinks:load', () => {

    document.querySelector('.question .votes')
        .addEventListener('ajax:success', (event) => {
            const votes = document.querySelector('.question .votes');
            const vote = event.detail[0]
            votes.querySelector('.vote-count').textContent = vote.vote_count;
    })

    document.querySelector('.question .votes')
        .addEventListener('ajax:error', (event) => {
        console.error(event);
        for (const error of event.detail[0]) {
            document.querySelector('.question_errors ul')
                .insertAdjacentHTML('beforeend', `<li>${error}</li>`)
        }
    })
})
