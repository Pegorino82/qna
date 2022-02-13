$(document).on('turbolinks:load', function() {
    document.querySelector('.full-search').addEventListener('ajax:success', (event) => {
        console.log(event);
        console.log(!event.target.classList.contains('page-link'));
        const result = event.detail[0];
        if (document.querySelector('.full-search-result').classList.contains('hidden')) {
            document.querySelector('.full-search form button').innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" width="16" height="16"><path fill-rule="evenodd" d="M3.404 12.596a6.5 6.5 0 119.192-9.192 6.5 6.5 0 01-9.192 9.192zM2.344 2.343a8 8 0 1011.313 11.314A8 8 0 002.343 2.343zM6.03 4.97a.75.75 0 00-1.06 1.06L6.94 8 4.97 9.97a.75.75 0 101.06 1.06L8 9.06l1.97 1.97a.75.75 0 101.06-1.06L9.06 8l1.97-1.97a.75.75 0 10-1.06-1.06L8 6.94 6.03 4.97z"></path></svg>`
        } else {
            document.querySelector('.full-search form button').innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" width="16" height="16"><path fill-rule="evenodd" d="M11.5 7a4.499 4.499 0 11-8.998 0A4.499 4.499 0 0111.5 7zm-.82 4.74a6 6 0 111.06-1.06l3.04 3.04a.75.75 0 11-1.06 1.06l-3.04-3.04z"></path></svg>`
        }
        document.querySelector('.full-search-result').innerHTML = '';
        document.querySelector('.full-search-result').innerHTML = result.body.innerHTML;

        if (!event.target.classList.contains('page-link')) {
            document.querySelector('.full-search-result').classList.toggle('hidden');
            document.querySelector('.main-content').classList.toggle('hidden');
        }

        if (document.querySelector('.full-search-result').classList.contains('hidden')) {
            document.querySelector('.full-search form input#text').value = ''
        }
    })
});
