'use strict';

const { createCoreRouter } = require('@strapi/strapi').factories;

module.exports = {

    routes: [
        {
            method: 'GET',
            path: '/book-contents/:bookUUID',
            handler: 'api::book-content.book-content.findContentByBookUUID',
        },
    ],
}
