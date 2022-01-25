document.addEventListener('turbolinks:load', () => {
    const question = document.querySelector('.question');
    if (question) {
        question.addEventListener('click', (event) => {
            if (event.target.classList.contains('edit-question-link')) {
                event.preventDefault();
                event.target.classList.add('hidden');
                question.querySelectorAll('form #links .nested-fields').forEach(elem => {
                    elem.parentNode.removeChild(elem)
                });
                console.log(question.querySelector('form'))
                question.querySelector('#question-form').classList.toggle('hidden')
            }
        })
    }
})
