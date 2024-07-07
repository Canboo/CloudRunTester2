import axios from 'axios';

// API Server
export const apiServer = axios.create({
  // @ts-ignore
  baseURL: import.meta.env.VITE_APP_API_URL,
});
