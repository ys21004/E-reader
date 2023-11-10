'use strict';

/**
 * book-content service
 */

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::book-content.book-content');
