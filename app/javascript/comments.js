const comments = () => {
    const createCommentsNodeList = document.querySelectorAll('.create-comment');
    if (createCommentsNodeList.length) {
        createCommentsNodeList.forEach(createCommentElement => {
            createCommentElement.addEventListener('ajax:error', (event) => {
                const errors = event.target.querySelector('.errors');
                const errorsList = document.createElement('ul');
                for (const error of event.detail[0]) {
                    errorsList.insertAdjacentHTML('afterbegin',
                        `<li>${error}</li>`)
                }
                errors.insertAdjacentElement('afterbegin', errorsList);
            })
            createCommentElement.addEventListener('ajax:success', (event) => {
                const createComment = event.detail[0];
                event.target.querySelector('.errors').innerHTML = '';
                const elId = `${createComment.comment.commentable_type.toLowerCase()}-${createComment.comment.commentable_id}`;
                document.querySelector(`#${elId} #comment_body`).value = ''
            })
        })
    }
}

document.addEventListener('turbolinks:load', () => {
    comments()
})
