'use strict';

/**
 * user-book-purchase controller
 */

const { createCoreController } = require('@strapi/strapi').factories;

module.exports = createCoreController('api::user-book-purchase.user-book-purchase', ({ strapi }) =>  ({
  async createWithRelations(ctx) {
    const { bookUUID, price } = ctx.request.body;
    const user = ctx.state.user;
    // console.log(bookUUID);
    // console.log(price);
    if (!bookUUID || !user || !price) {
      return ctx.badRequest('Missing parameters');
    }

    // Fetch the user and the book using the provided UUIDs
    const book = await strapi.entityService.findMany('api::book.book', { filters: { bookuuid: bookUUID } });
    // console.log(user);
    // console.log(book);
    if (!user || !book) {
      return ctx.notFound('User or Book not found');
    }
    console.log('creating purchase entry')
    console.log(book.id);
    console.log(book[0].id)
    // Create the Purchase entry
    const purchase = await strapi.entityService.create('api::user-book-purchase.user-book-purchase', {
      data: {
        book: {
          connect: [book[0].id],
        },
        user: {
          connect: [user.id],
        },
        price_purchased_for: price,
        publishedAt: new Date()
      },
    });
    console.log('completed purchase')
    if (!purchase) {
      return ctx.internalServerError('Could not create purchase');
    }

    console.log('updating book-user relation')

    // Update the relations - this depends on how your relations are set up, here's a general idea
    await strapi.entityService.update('api::book.book', book[0].id, {
      data: {
        users: {
          connect: [user.id],
        },
      },
    });
    console.log('successfully updated book-user relation')


    // Return the Purchase entry
    return ctx.created(purchase);
  },
}));

