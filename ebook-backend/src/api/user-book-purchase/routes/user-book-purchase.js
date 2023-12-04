'use strict';

/**
 * user-book-purchase router
 */

const { createCoreRouter } = require('@strapi/strapi').factories;


module.exports = {
  routes: [
    {
      method: 'POST',
      path: '/purchase',
      handler: 'api::user-book-purchase.user-book-purchase.createWithRelations'
    },
  ],
};

