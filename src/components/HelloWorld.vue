<script setup>
import { ref, inject, reactive } from 'vue';
import DataTable from 'datatables.net-vue3';
import DataTablesLib from 'datatables.net-bs5';
import DataTablesCore from 'datatables.net';
DataTable.use(DataTablesLib);
DataTable.use(DataTablesCore);

const columns = [
  { data: 'dep_academyno', title: '學院代碼' },
  { data: 'dep_area', title: '校區' },
  { data: 'dep_depename', title: '系所英文名稱' },
  { data: 'dep_depesname', title: '系所英文簡稱' },
  { data: 'dep_depname', title: '系所名稱' },
  { data: 'dep_depno', title: '系所代碼' },
  { data: 'dep_depsname', title: '系所簡稱' },
  { data: 'dep_year', title: '適用學年度' },
];
const deptdata = ref([]);
let deptQuery = reactive({
  depYear: 113,
});

import { api } from '@api/demoAPI.ts';
import LoadingSpinner from './LoadingSpinner.vue';
const loading = ref(false);

const getDepts = async () => {
  loading.value = true;
  await api
    .Depts(deptQuery)
    .then((res) => {
      if (res.data.error.length !== 0) {
        alert(res.data.error);
        return;
      }
      deptdata.value = res.data.data;
    })
    .catch((res) => {
      alert(res);
    });
  setTimeout(() => {
    loading.value = false;
  }, 1000);
};

defineProps({
  msg: String,
});

const count = ref(0);
const data = ref([]);
const increment = () => {
  count.value++;
};

const connectAPI = async () => {
  loading.value = true;
  await api
    .Get()
    .then((res) => {
      [data.value] = [res.data];
    })
    .catch(() => {
      data.value = res;
    });
  setTimeout(() => {
    loading.value = false;
  }, 1000);
};

const connectSQL = async () => {
  loading.value = true;
  await api
    .Sql()
    .then((res) => {
      [data.value] = [res.data];
    })
    .catch(() => {
      data.value = res;
    });
  setTimeout(() => {
    loading.value = false;
  }, 1000);
};

const downloadGCS = async () => {
  loading.value = true;
  api.Gcs('sample.pdf').then((res) => {
    startDownload(res, 'application/pdf');
  });
  setTimeout(() => {
    loading.value = false;
  }, 1000);
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

const generateNumbers = (start, end) => {
  let numbers = [];
  for (let i = start; i <= end; i++) {
    numbers.push(i);
  }
  return numbers;
};

const years = generateNumbers(97, 113);
</script>

<template>
  <LoadingSpinner v-if="loading" />
  <h1>{{ msg }}</h1>

  <div class="card">
    <div class="input-group mb-3">
      <select
        v-model="deptQuery.depYear"
        class="form-select"
        name="depYear"
        id="depYear"
      >
        <option v-for="(year, index) in years" :key="index" :value="year">
          {{ year }} 學年度
        </option>
      </select>
      <button type="button" class="btn btn-outline-primary" @click="getDepts">
        取回教學單位
      </button>
    </div>
    <hr />
    <DataTable :columns="columns" :data="deptdata" class="display"></DataTable>
  </div>

  <hr />
  <div class="btn-group">
    <button class="btn btn-secondary" type="button" @click="increment">
      count is {{ count }}
    </button>
    <button class="btn btn-secondary" type="button" @click="connectAPI">
      取回靜態API
    </button>
    <button class="btn btn-secondary" type="button" @click="connectSQL">
      取回資料庫API
    </button>
    <button class="btn btn-secondary" type="button" @click="downloadGCS">
      下載GCS(sample.pdf)
    </button>
    <button class="btn btn-secondary" type="button" @click="cleanData">
      清空取回內容
    </button>
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
  max-width: 400px;
  margin: auto;
  text-align: left;
  height: 200px;
  overflow: auto;
}
button + button {
  margin-left: 1rem;
}
</style>
