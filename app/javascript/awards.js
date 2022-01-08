document.addEventListener('turbolinks:load', () => {
    const award = document.querySelector('#award');
    if (award) {
        award.addEventListener('click', (event) => {
            if (event.target.classList.contains('add-award-link')) {
                event.preventDefault();
                event.target.classList.add('hidden');

                award.querySelector('.award_fields').classList.toggle('hidden')
            }
            if (event.target.classList.contains('remove-award-link')) {
                event.preventDefault();
                award.querySelector('.award_fields').classList.toggle('hidden')
                award.querySelector('.add-award-link').classList.toggle('hidden')
                award.querySelectorAll('.award_fields input').forEach(elem => {
                    elem.value = ''
                });
            }
        })
    }
})