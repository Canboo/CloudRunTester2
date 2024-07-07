import { apiServer } from '../index';

export const api = {
  Get: () => apiServer.get('WeatherForecast'),
  Sql: () => apiServer.get('CloudSQL'),
};
