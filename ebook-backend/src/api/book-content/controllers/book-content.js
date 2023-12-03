'use strict';

const { createCoreController } = require('@strapi/strapi').factories;

module.exports = createCoreController('api::book-content.book-content', ({ strapi }) =>  ({
  async findContentByBookUUID(ctx) {
    // retrieve the logged in user, i.e his information
    const user = ctx.state.user;
    // console.log(ctx.state.user);

    // handle users who aren't logged in
    if (!user) {
      return ctx.unauthorized(`You must be logged in to perform this action`);
    }

    // retrieve bookUUID from the request
    const { bookUUID } = ctx.params;

    // check if the user has a relation with the book
    const userWithBooks = await strapi.entityService.findOne('plugin::users-permissions.user', user.id, {
      filters: {
        books: {
          bookuuid: bookUUID
        }
      },
      populate: ['books'],
    });

    // check if the user owns the book
    if (!userWithBooks || userWithBooks.books.length === 0) {
      return ctx.forbidden(`You do not own the book with UUID: ${bookUUID}`);
    }

    // the user owns the book
    const bookContents = await strapi.entityService.findMany('api::book-content.book-content', {
      filters: {
        book: {
          bookuuid: bookUUID
        }
      },
      populate: ['content', 'book'],
    });

    return bookContents;
  },
}));
