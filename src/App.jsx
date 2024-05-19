import React from 'react';
import { Route, Routes } from 'react-router-dom';

import { AppProvider } from '@edx/frontend-platform/react';

import Footer from '@edx/frontend-component-footer';
import Header from '@edx/frontend-component-header';

import store from 'data/store';
import GradebookPage from 'containers/GradebookPage';
import './App.scss';

const App = () => (
  <AppProvider store={store}>
    <div>
      <Header mfeTitle="gradebook.page.title" />
      <main>
        <Routes>
          <Route
            path="/:courseId"
            element={<GradebookPage />}
          />
        </Routes>
      </main>
      <Footer logo={process.env.LOGO_POWERED_BY_OPEN_EDX_URL_SVG} />
    </div>
  </AppProvider>
);

export default App;
