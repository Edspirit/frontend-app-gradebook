import arMessages from './messages/ar.json';
import faIRMessages from './messages/fa_IR.json';
// no need to import en messages-- they are in the defaultMessage field
import es419Messages from './messages/es_419.json';
import frMessages from './messages/fr.json';
import zhcnMessages from './messages/zh_CN.json';

const messages = {
  ar: arMessages,
  fa: faIRMessages,
  'es-419': es419Messages,
  fr: frMessages,
  'zh-cn': zhcnMessages,
};

export default messages;
