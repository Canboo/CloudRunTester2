<script setup>
import { ref } from 'vue';
import { api } from '@api/demoAPI.ts';

defineProps({
  msg: String,
});

const count = ref(0);
const data = ref([]);
const increment = () => {
  count.value++;
};

const connectAPI = () => {
  api
    .Get()
    .then((res) => {
      [data.value] = [res.data];
    })
    .catch(() => {
      data.value = res;
    });
};

const connectSQL = () => {
  api
    .Sql()
    .then((res) => {
      [data.value] = [res.data];
    })
    .catch(() => {
      data.value = res;
    });
};

const downloadGCS = () => {
  api.Gcs('sample.pdf').then((res) => {
    startDownload(res, 'application/pdf');
  });
};

const startDownload = (res, mimeType) => {
  const url = window.URL.createObjectURL(
    new Blob([res.data], { type: mimeType })
  );
  let filename = getBlobFilename(res);
  const link = document.createElement('a');
  link.setAttribute('download', filename);
  link.href = url;
  link.target = '_blank';
  link.click();
};

const getBlobFilename = (res) => {
  let filename = '';
  const contentDisposition = res.headers.get('Content-Disposition');
  if (contentDisposition) {
    const filenameStarMatch = contentDisposition.match(
      /filename\*=UTF-8''([^;]+)/
    );
    if (filenameStarMatch && filenameStarMatch.length === 2) {
      filename = decodeURIComponent(filenameStarMatch[1]);
    } else {
      const filenameMatch = contentDisposition.match(
        /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/
      );
      if (filenameMatch !== null && filenameMatch[1]) {
        filename = filenameMatch[1].replace(/['"]/g, '');
      }
    }
  }
  return filename;
};

const cleanData = () => {
  data.value = [];
};
</script>

<template>
  <h1>{{ msg }}</h1>

  <div class="card">
    <button type="button" @click="increment">count is {{ count }}</button>
    <button type="button" @click="connectAPI">取回靜態API</button>
    <button type="button" @click="connectSQL">取回資料庫API</button>
    <button type="button" @click="downloadGCS">下載GCS(sample.pdf)</button>
    <button type="button" @click="cleanData">清空取回內容</button>
  </div>

  <p>API取回內容:</p>
  <pre>{{ data }}</pre>

  <p>
    Check out
    <a href="https://vuejs.org/guide/quick-start.html#local" target="_blank"
      >create-vue</a
    >, the official Vue + Vite starter
  </p>
  <p>
    Learn more about IDE Support for Vue in the
    <a
      href="https://vuejs.org/guide/scaling-up/tooling.html#ide-support"
      target="_blank"
      >Vue Docs Scaling up Guide</a
    >.
  </p>
  <p class="read-the-docs">Click on the Vite and Vue logos to learn more</p>
</template>

<style scoped>
.read-the-docs {
  color: #888;
}
pre {
  border: 1px solid #ccc;
  padding: 1rem;
  width: 400px;
  margin: auto;
  text-align: left;
}
button + button {
  margin-left: 1rem;
}
</style>
