const GistClient = require("gist-client");
const gistClient = new GistClient();
// const env = require('dotenv').config();
// console.log(process.env.GITHUB_QNA_ACCESS_TOKEN)

const isGist = (link) => {
    return link.href && link.href.startsWith('https://gist.github.com')
};

const gistHTML = (gist, gistLinkName) => {
    const root = document.createElement('div');

    const gistLink = document.createElement('a');
    gistLink.innerText = gistLinkName;
    gistLink.href = gist.html_url;
    gistLink.target = '_blank';

    root.insertAdjacentElement('afterbegin', gistLink);

    for (const file of Object.values(gist.files)) {
        const inner = document.createElement('div');
        inner.classList.add('border');
        inner.classList.add('mt-1');

        const filename = document.createElement('a');
        filename.innerText = file.filename;
        filename.href = file.raw_url;
        filename.target = '_blank';

        const content = document.createElement('p');
        content.innerText = file.content;

        inner.insertAdjacentElement('beforeend', filename);
        inner.insertAdjacentElement('beforeend', content);
        root.insertAdjacentElement('beforeend', inner)
    }
    return root
};

const addGistHTML = (elem, gist) => {
    const innerHTML = gistHTML(gist, elem.innerText)
    elem.parentElement.innerHTML = innerHTML.innerHTML
}

export const gistRenderer = async () => {
    for (const elem of document.querySelectorAll('.resource-link')) {
        if (isGist(elem)) {
            const gistId = elem.href.split('/')[elem.href.split('/').length - 1];
            const gist = await gistClient
                // .setToken(process.env.GITHUB_QNA_ACCESS_TOKEN)
                .setToken('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')
                .getOneById(gistId);
            addGistHTML(elem, gist)
        }
    }
};

document.addEventListener('turbolinks:load', () => {
    gistRenderer().catch(e => console.error(e))
})

document.addEventListener('gistRenderer', () => {
    gistRenderer().catch(e => console.error(e))})
