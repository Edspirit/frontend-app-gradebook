import 'core-js/stable';
import 'regenerator-runtime/runtime';

import React from 'react';
import ReactDOM from 'react-dom';

import {
  APP_READY,
  initialize,
  mergeConfig,
  subscribe,
} from '@edx/frontend-platform';
import { messages as headerMessages } from '@edx/frontend-component-header';
import { messages as footerMessages } from '@edx/frontend-component-footer';

import appMessages from './i18n';
import App from './App';

subscribe(APP_READY, () => {
  ReactDOM.render(<App />, document.getElementById('root'));
});

initialize({
  handlers: {
    config: () => {
      mergeConfig({
        AC_INSTANCE_CONFIG_API_URL: process.env.AC_INSTANCE_CONFIG_API_URL,
      }, 'App loadConfig override handler');
    },
  },
  messages: [
    appMessages,
    headerMessages,
    footerMessages,
  ],
  requireAuthenticatedUser: true,
});
