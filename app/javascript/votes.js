document.addEventListener('turbolinks:load', () => {
    const votesNodeList = document.querySelectorAll('.votes');
    if (votesNodeList.length) {
        votesNodeList.forEach(voteElement => {
            voteElement.addEventListener('ajax:success', (event) => {
                const vote = event.detail[0];
                if (voteElement.dataset.resourceName === vote.votable_class
                    && voteElement.dataset.resourceId == vote.votable_id) {
                    voteElement.querySelector('.vote-count').textContent = vote.vote_count;
                }
            });

            voteElement.addEventListener('ajax:error', (event) => {
                console.error(event);
                for (const error of event.detail[0]) {
                    document.querySelector('.question_errors ul')
                        .insertAdjacentHTML('beforeend', `<li>${error}</li>`)
                }
            })
        })
    }
})
