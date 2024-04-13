import React from 'react';
import { Helmet } from 'react-helmet';
import { useIntl } from '@edx/frontend-platform/i18n';
import { getConfig } from '@edx/frontend-platform';
import useGetConfig from '../hooks/useGetConfig';

import messages from './messages';

const Head = () => {
  const { formatMessage } = useIntl();
  const {
    platformName,
  } = useGetConfig();
  return (
    <Helmet>
      <title>
        {formatMessage(messages['gradebook.page.title'], { siteName: platformName || getConfig().siteName })}
      </title>
    </Helmet>
  );
};

Head.propTypes = {
};

export default Head;
