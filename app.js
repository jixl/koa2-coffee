'use strict'
require('coffeescript/register');
// require('./app.coffee');

const log4js = require('log4js');
log4js.configure('./log4js.json');

const koa = require('koa');
const app = new koa();
app.getLogger = log4js.getLogger;
app.logger = log4js.getLogger('app');
const access = log4js.getLogger('access');

require('./app/middleware')(app);

const router = require('./app/router.coffee');
app.use(router.routes())
   .use(router.allowedMethods());

app.on('error', (err, ctx) => {
  log.error('server error', err, ctx)
});

app.listen(3000, err => {
  console.log(`server start ${err || 'success'}`)
});