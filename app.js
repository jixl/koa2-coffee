'use strict'
require('coffeescript/register');
// require('./app.coffee');

const koa = require('koa');
const app = new koa();

require('./app/middleware')(app);

const router = require('./app/router.coffee');
app.use(router.routes())
   .use(router.allowedMethods());

app.listen(3000, err => {
  console.log(`server start ${err || 'success'}`)
});