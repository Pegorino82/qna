document.addEventListener('turbolinks:load', () => {

    document.querySelector('.question .votes')
        .addEventListener('ajax:success', (event) => {
        document.querySelector('.question .votes')
            .innerHTML = event.detail[2].responseText
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
