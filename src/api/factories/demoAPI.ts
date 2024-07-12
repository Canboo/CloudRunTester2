import { apiServer } from '../index';

export const api = {
  Get: () => apiServer.get('WeatherForecast'),
  Sql: () => apiServer.get('CloudSQL'),
  Gcs: (data: string) =>
    apiServer.get('GCS/' + data, {
      responseType: 'blob',
    }),
  Depts: (query: Object) => apiServer.post('Depts', query),
};
